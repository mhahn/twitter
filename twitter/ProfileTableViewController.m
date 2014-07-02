//
//  ProfileTableViewController.m
//  twitter
//
//  Created by mhahn on 7/1/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "MBProgressHud.h"
#import <ReactiveCocoa.h>

#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "ProfileTableViewController.h"
#import "ProfileHeaderTableViewCell.h"
#import "TwitterManager.h"
#import "Tweet.h"
#import "TweetTableViewCell.h"
#import "TweetViewController.h"

@interface ProfileTableViewController() {
    NSInteger sections;
    NSArray *tweets;
}

@property (nonatomic, strong) TweetTableViewCell *prototypeCell;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) User *user;

@end

// this is going to be used for both the mentions and the main timeline. we'll init it with a constant letting us know which one it is

@implementation ProfileTableViewController

- (id)initWithScreenName:(NSString *)screenName {
    self = [super init];
    if (self) {
        self.screenName = screenName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // fetch the initial data
    [self fetchData:nil];
    // set sections to 0 while loading
    sections = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // setup nibs
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    UINib *profileHeaderCellNib = [UINib nibWithNibName:@"ProfileHeaderTableViewCell" bundle:nil];
    [self.tableView registerNib:profileHeaderCellNib forCellReuseIdentifier:@"ProfileHeader"];
    
    // fetch the user based on the screen name
    // fetch the tweets
    // finish loading
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileHeader" forIndexPath:indexPath];
        [(ProfileHeaderTableViewCell *)cell setUser:self.user];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
        [(TweetTableViewCell *)cell setTweet:tweets[indexPath.row]];
    }
    return cell;
}

- (void)fetchData:(id)sender {
    [[RACSignal merge: @[[[TwitterManager instance] fetchTweetsFromUserTimeline:self.screenName], [[TwitterManager instance] fetchUserInfo:self.screenName]]] subscribeNext:^(id x) {
        if ([x isKindOfClass:[User class]]) {
            self.user = x;
        } else {
            tweets = x;
        }
    } error:^(NSError *error) {
        NSLog(@"Error fetching profile info: %@", error);
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
    if (indexPath.row == 0) {
        return 200.f;
    } else {
        self.prototypeCell.tweet = tweets[indexPath.row];
        [self.prototypeCell layoutIfNeeded];
        CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 1.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        TweetViewController *tweetViewController = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
        tweetViewController.tweet = tweets[indexPath.row];
        [self.navigationController pushViewController:tweetViewController animated:YES];
    }
}

@end
