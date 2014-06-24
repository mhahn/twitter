//
//  ComposeViewController.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "ComposeViewController.h"
#import "TimelineTableViewController.h"
#import "TwitterManager.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tweetText;
- (void)cancel;
- (void)sendTweet;
- (void)popToTimeline;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup the navigation bar
    self.navigationItem.title = @"Home";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(sendTweet)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = tweetButton;
}

- (void)cancel {
    [self popToTimeline];
}

- (void)sendTweet {
    NSLog(@"Sending tweet: %@", self.tweetText.text);
    [[[TwitterManager instance] sendTweet:self.tweetText.text] subscribeError:^(NSError *error) {
        // # XXX add error messaging
        NSLog(@"error sending tweet: %@", error);
    } completed:^{
        [self popToTimeline];
    }];
}

- (void)popToTimeline {
    NSArray *viewControllers = [NSArray arrayWithObject:[[TimelineTableViewController alloc] init]];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

@end
