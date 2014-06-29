//
//  PanelTableViewController.m
//  twitter
//
//  Created by mhahn on 6/28/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "LoginViewController.h"
#import "PanelHeaderView.h"
#import "PanelLink.h"
#import "PanelLinkTableViewCell.h"
#import "PanelTableViewController.h"
#import "TwitterManager.h"

@interface PanelTableViewController () {
    NSArray *panelLinks;
}

@end

@implementation PanelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UINib *panelHeader = [UINib nibWithNibName:@"PanelHeaderView" bundle:nil];
    [self.tableView registerNib:panelHeader forHeaderFooterViewReuseIdentifier:@"PanelHeader"];
    UINib *linkCell = [UINib nibWithNibName:@"PanelLinkTableViewCell" bundle:nil];
    [self.tableView registerNib:linkCell forCellReuseIdentifier:@"LinkCell"];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    
    panelLinks = @[
        [[PanelLink alloc] initWithDictionary:@{@"label": @"Sign Out", @"selector": @"signOut"}],
    ];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [panelLinks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCell" forIndexPath:indexPath];
    [(PanelLinkTableViewCell *)cell setLink:panelLinks[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PanelHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PanelHeader"];
    header.user = [[TwitterManager instance] getCurrentUser];
    return header;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PanelLink *panelLink = panelLinks[indexPath.row];
    NSLog(@"selector: %@", panelLink.selectorString);
    [self performSelectorOnMainThread:NSSelectorFromString(panelLink.selectorString) withObject:self waitUntilDone:NO];
}


- (void)signOut {
    NSLog(@"%@", self.view.superview);
    [[TwitterManager instance] signOut];
    [self presentViewController:[[LoginViewController alloc] init] animated:NO completion:nil];
}

@end
