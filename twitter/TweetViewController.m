//
//  TweetViewController.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

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
    
}

@end
