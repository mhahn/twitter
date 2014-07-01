//
//  ComposeViewController.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "UIImageView+MHNetworking.h"
#import "TSMessage.h"

#import "ComposeViewController.h"
#import "TimelineTableViewController.h"
#import "TwitterManager.h"
#import "User.h"
#import "Tweet.h"

@interface ComposeViewController () {
    UIBarButtonItem *wordCount;
}

@property (strong, nonatomic) Tweet *tweet;

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;


- (void)cancel;
- (void)sendTweet;
- (void)popToTimeline;
- (BOOL)isTweetValid;

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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(sendTweet)];
    wordCount = [[UIBarButtonItem alloc] initWithTitle:@"140" style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItems = @[tweetButton, wordCount];
    
    // load the user info
    User *user = [[TwitterManager instance] getCurrentUser];
    _screenNameLabel.text = user.screenName;
    _userNameLabel.text = user.userName;
    [_profilePictureImage setImageWithURL:user.userProfilePicture withAnimationDuration:0.5];
    
    if (_tweet) {
        self.tweetText.text = [NSString stringWithFormat:@"%@ ", _tweet.screenName];
    }
    
    // open the keyboard immediately
    [self.tweetText becomeFirstResponder];
    
    [self.tweetText.rac_textSignal subscribeNext:^(NSString *value) {
        [self updateWordCount:value];
    }];
    
}

- (void)updateWordCount:(NSString *)value {
    NSInteger length = 140 - [value length];
    wordCount.title = [NSString stringWithFormat:@"%d", length];

    if (length < 0) {
        wordCount.tintColor = [UIColor redColor];
        
    } else {
        UIColor *twitterWhite = [UIColor colorWithRed:0.961 green:0.973 blue:0.98 alpha:1]; /*#f5f8fa*/
        wordCount.tintColor = twitterWhite;
    }
    
}

- (void)cancel {
    [self popToTimeline];
}

- (void)sendTweet {
    if ([self isTweetValid]) {
        [[[TwitterManager instance] sendTweet:self.tweetText.text inReplyTo:_tweet] subscribeError:^(NSError *error) {
            // # XXX add error messaging
            NSLog(@"error sending tweet: %@", error);
        } completed:^{
            [self popToTimeline];
        }];
    } else {
        [TSMessage showNotificationInViewController:self title:@"Tweets must be less than 140 characters" subtitle:nil type:TSMessageNotificationTypeError duration:2 canBeDismissedByUser:YES];
    }
}

- (void)popToTimeline {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isTweetValid {
    if ([self.tweetText.text length] > 140) {
        return NO;
    } else {
        return YES;
    }
}

@end
