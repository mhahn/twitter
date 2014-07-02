//
//  ProfileHeaderTableViewCell.m
//  twitter
//
//  Created by mhahn on 7/1/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "UIImageView+MHNetworking.h"

#import "ProfileHeaderTableViewCell.h"
#import "User.h"

@interface ProfileHeaderTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@end

@implementation ProfileHeaderTableViewCell

- (void)setUser:(User *)user {
    _user = user;
    self.userNameLabel.text = user.userName;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%@", user.numberOfTweets];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%@", user.numberOfFollowers];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%@", user.numberFollowing];
    [self.userProfileImage setImageWithURL:user.userProfilePictureLarge withAnimationDuration:0.25];
    [self.userProfileBackgroundImage setImageWithURL:user.userProfileBackgroundImage withAnimationDuration:0.25];
}

@end
