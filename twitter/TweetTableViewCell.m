//
//  TweetTableViewCell.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "UIImageView+MHNetworking.h"

@interface TweetTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImage;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@end

@implementation TweetTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    _tweetText.text = tweet.text;
    _userNameLabel.text = tweet.userName;
    _screenNameLabel.text = tweet.formattedScreenName;
    _createdAtLabel.text = tweet.prettyCreatedAt;
    [_profilePictureImage setImageWithURL:tweet.userProfilePicture withAnimationDuration:0.5];
}

- (void)handleImagePushed {
    [_delegate didSelectProfileImage:self.tweet.screenName];
}

@end
