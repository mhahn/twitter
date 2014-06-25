//
//  ComposeViewController.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "UIImageView+MHNetworking.h"

#import "ComposeViewController.h"
#import "TimelineTableViewController.h"
#import "TwitterManager.h"
#import "User.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
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
    
    // load the user info
    User *user = [[TwitterManager instance] currentUser];
    _screenNameLabel.text = user.screenName;
    _userNameLabel.text = user.userName;
    [_profilePictureImage setImageWithURL:user.userProfilePicture withAnimationDuration:0.5];
    
    // open the keyboard immediately
    [self.tweetText becomeFirstResponder];
    
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
