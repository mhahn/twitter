//
//  TimelineTableViewController.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "MBProgressHud.h"
#import <ReactiveCocoa.h>

#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "ProfileImageSelectedDelegate.h"
#import "ProfileTableViewController.h"
#import "TweetsTableViewController.h"
#import "TwitterManager.h"
#import "Tweet.h"
#import "TweetTableViewCell.h"
#import "TweetViewController.h"

@interface TweetsTableViewController () <ProfileImageSelectedDelegate> {
    NSInteger sections;
}

@property (nonatomic, assign) TweetsTableViewControllerType controllerType;
@property (nonatomic, strong) TweetTableViewCell *prototypeCell;

@end

// this is going to be used for both the mentions and the main timeline. we'll init it with a constant letting us know which one it is

@implementation TweetsTableViewController

- (id)initWithTypeOfController:(TweetsTableViewControllerType)controllerType {
    self = [super init];
    if (self) {
        self.controllerType = controllerType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // fetch the initial ddata
    [self fetchData:nil];
    // set sections to 0 while loading
    sections = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // setup referesh controller
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchData:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // setup nibs
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // setup the navigation bar
    self.navigationItem.title = @"Home";
    UIBarButtonItem *panelButton = [[UIBarButtonItem alloc] initWithTitle:@"Panel" style:UIBarButtonItemStyleDone target:self.delegate action:@selector(togglePanel)];
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStyleDone target:self action:@selector(composeTweet)];
    self.navigationItem.leftBarButtonItem = panelButton;
    self.navigationItem.rightBarButtonItem = composeButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.controllerType) {
        case TweetsTableViewControllerTimeline:
            return [[[TwitterManager instance] getCurrentTweets] count];
        case TweetsTableViewControllerMentions:
            return [[[TwitterManager instance] getCurrentMentions] count];
            
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:cell action:NSSelectorFromString(@"handleImagePushed")];
    [cell addGestureRecognizer:tap];
    cell.tweet = [self getTweetAtIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)composeTweet {
    [self.navigationController pushViewController:[[ComposeViewController alloc] init] animated:YES];
}

- (void)fetchData:(id)sender {
    switch (self.controllerType) {
        case TweetsTableViewControllerTimeline:
            [self fetchTweetsFromTimeline:sender];
            break;
        case TweetsTableViewControllerMentions:
            [self fetchMentions:sender];
            break;
            
        default:
            break;
    }

}

- (void)fetchTweetsFromTimeline:(id)sender {
    [[[TwitterManager instance] fetchTweetsFromTimeline] subscribeError:^(NSError *error) {
        NSLog(@"Error fetching tweets: %@", error);
    } completed:^{
        [self finishFetching:sender];
        [self.tableView reloadData];
    }];
}

- (void)fetchMentions:(id)sender {
    [[[TwitterManager instance] fetchMentions] subscribeError:^(NSError *error) {
        NSLog(@"Error fetching tweets: %@", error);
    } completed:^{
        [self finishFetching:sender];
        [self.tableView reloadData];
    }];
}

- (void)finishFetching:(id)sender {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (!sections) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        sections = 1;
    }
    
    if (sender) {
        [(UIRefreshControl *)sender endRefreshing];
    }
}


- (TweetTableViewCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    return _prototypeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell.tweet = [self getTweetAtIndexPath:indexPath];
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetViewController *tweetViewController = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
    tweetViewController.tweet = [self getTweetAtIndexPath:indexPath];
    [self.navigationController pushViewController:tweetViewController animated:YES];
    
}

- (Tweet *)getTweetAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.controllerType) {
        case TweetsTableViewControllerTimeline:
            return [[TwitterManager instance] getTweetAtIndex:indexPath.row];
            
        case TweetsTableViewControllerMentions:
            return [[TwitterManager instance] getMentionAtIndex:indexPath.row];
            
        default:
            break;
    }
}

- (void)didSelectProfileImage:(NSString *)screenName {
    ProfileTableViewController *vc = [[ProfileTableViewController alloc] initWithScreenName:screenName];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
