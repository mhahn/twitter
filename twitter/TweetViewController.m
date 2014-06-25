//
//  TweetViewController.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "TwitterManager.h"
#import "TweetViewController.h"
#import "UIImageView+MHNetworking.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;

- (IBAction)replyButtonAction:(id)sender;
- (IBAction)retweetButtonAction:(id)sender;
- (IBAction)favoriteButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Tweet";
    _tweetTextLabel.text = _tweet.text;
    _userNameLabel.text = _tweet.userName;
    _screenNameLabel.text = _tweet.screenName;
    _createdAtLabel.text = _tweet.createdAt;
    _retweetsCountLabel.text = [NSString stringWithFormat:@"%@", _tweet.retweetsCount];
    _favoritesCountLabel.text = [NSString stringWithFormat:@"%@", _tweet.favoritesCount];
    [_profilePictureImage setImageWithURL:_tweet.userProfilePicture withAnimationDuration:0.5];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateSelected];
    
}

- (IBAction)replyButtonAction:(id)sender {
    NSLog(@"replied");
}

- (IBAction)retweetButtonAction:(id)sender {
    [[[TwitterManager instance] retweet:_tweet] subscribeError:^(NSError *error) {
        NSLog(@"error retweeting: %@", error);
    } completed:^{
        NSLog(@"retweeted!");
    }];
}

- (IBAction)favoriteButtonAction:(id)sender {
    [[[TwitterManager instance] favorite:_tweet] subscribeError:^(NSError *error) {
        NSLog(@"error favoriting: %@", error);
    } completed:^{
        NSLog(@"favorited!");
    }];
}
@end
