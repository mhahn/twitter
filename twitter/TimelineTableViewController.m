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
#import "TimelineTableViewController.h"
#import "TwitterManager.h"
#import "Tweet.h"
#import "TweetTableViewCell.h"
#import "TweetViewController.h"

@interface TimelineTableViewController () {
    NSInteger sections;
}

@property (strong, nonatomic) UIBarButtonItem *signOutButton;
@property (strong, nonatomic) UIBarButtonItem *composeButton;
@property (nonatomic, strong) TweetTableViewCell *prototypeCell;

- (void)signOut;
- (void)composeTweet;
- (void)fetchData:(id)sender;
- (void)finishFetching:(id)sender;

@end

@implementation TimelineTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // fetch the initial ddata
    [self fetchData:nil];
    // set sections to 0 while loading
    sections = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // setup the navigation bar
    self.navigationItem.title = @"Home";
    self.signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleDone target:self action:@selector(signOut)];
    self.composeButton = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStyleDone target:self action:@selector(composeTweet)];
    self.navigationItem.leftBarButtonItem = self.signOutButton;
    self.navigationItem.rightBarButtonItem = self.composeButton;
    
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
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[TwitterManager instance] getCurrentTweets] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = [[TwitterManager instance] getTweetAtIndex:indexPath.row];
    return cell;
}

- (void)signOut {
    [[TwitterManager instance] signOut];
    NSArray *viewControllers = [NSArray arrayWithObject:[[LoginViewController alloc] init]];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)composeTweet {
    [self.navigationController pushViewController:[[ComposeViewController alloc] init] animated:YES];
}

- (void)fetchData:(id)sender {
    [[[TwitterManager instance] fetchTweetsFromTimeline] subscribeError:^(NSError *error) {
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
    self.prototypeCell.tweet = [[TwitterManager instance] getTweetAtIndex:indexPath.row];
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
    tweetViewController.tweet = [[TwitterManager instance] getTweetAtIndex:indexPath.row];
    [self.navigationController pushViewController:tweetViewController animated:YES];
    
}


@end
