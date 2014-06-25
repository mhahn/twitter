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
#import "Tweet.h"

@interface ComposeViewController ()

@property (strong, nonatomic) Tweet *tweet;

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *tweetText;

- (void)cancel;
- (void)sendTweet;
- (void)popToTimeline;

@end

@implementation ComposeViewController

- (id)initWithTweet:(Tweet *)tweet {
    self = [super init];
    if (self) {
        _tweet = tweet;
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
    
    if (_tweet) {
        self.tweetText.text = [NSString stringWithFormat:@"%@ ", _tweet.screenName];
    }
    
    // open the keyboard immediately
    [self.tweetText becomeFirstResponder];
    
}

- (void)cancel {
    [self popToTimeline];
}

- (void)sendTweet {
    [[[TwitterManager instance] sendTweet:self.tweetText.text inReplyTo:_tweet] subscribeError:^(NSError *error) {
        // # XXX add error messaging
        NSLog(@"error sending tweet: %@", error);
    } completed:^{
        [self popToTimeline];
    }];
}

- (void)popToTimeline {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
