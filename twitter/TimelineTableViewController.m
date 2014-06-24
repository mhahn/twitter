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

@interface TimelineTableViewController () {
    NSArray *tweets;
}

@property (strong, nonatomic) UIBarButtonItem *signOutButton;
@property (strong, nonatomic) UIBarButtonItem *composeButton;

- (void)signOut;
- (void)composeTweet;
- (void)fetchData:(id)sender;
- (void)finishFetching:(id)sender;

@end

@implementation TimelineTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
