//
//  TimelineTableViewController.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <ReactiveCocoa.h>

#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "TimelineTableViewController.h"
#import "TwitterManager.h"
#import "Tweet.h"
#import "TweetTableViewCell.h"
#import "TweetViewController.h"

@interface TimelineTableViewController () {
    NSArray *tweets;
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
    
    
    // fetch the current user
    [[[TwitterManager instance] getCurrentUser] subscribeError:^(NSError *error) {
        NSLog(@"Failed fetching user: %@", error);
    } completed:^{
        NSLog(@"Current user: %@", [[[TwitterManager instance] currentUser] screenName]);
    }];
    
    // fetch the initial ddata
    [self fetchData:nil];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tweets count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = tweets[indexPath.row];
    return cell;
}

- (void)signOut {
    [[TwitterManager instance] signOut];
    NSArray *viewControllers = [NSArray arrayWithObject:[[LoginViewController alloc] init]];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)composeTweet {
    NSArray *viewControllers = [NSArray arrayWithObject:[[ComposeViewController alloc] init]];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)fetchData:(id)sender {
    [[[TwitterManager instance] fetchTweetsFromTimeline] subscribeNext:^(NSArray *timelineTweets) {
        tweets = timelineTweets;
        [self.tableView reloadData];
        [self finishFetching:sender];
    } error:^(NSError *error) {
        NSLog(@"Error fetching tweets: %@", error);
    }];
}

- (void)finishFetching:(id)sender {
    // XXX dismiss loader
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
    self.prototypeCell.tweet = tweets[indexPath.row];
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
    tweetViewController.tweet = tweets[indexPath.row];
    [self.navigationController pushViewController:tweetViewController animated:YES];
    
}


@end
