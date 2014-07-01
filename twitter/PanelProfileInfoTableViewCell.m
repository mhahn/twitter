//
//  PanelProfileInfoTableViewCell.m
//  twitter
//
//  Created by mhahn on 7/1/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "UIImageView+MHNetworking.h"

#import "PanelProfileInfoTableViewCell.h"
#import "User.h"

@interface PanelProfileInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@end

@implementation PanelProfileInfoTableViewCell

- (void)setUser:(User *)user {
    _user = user;
    self.userNameLabel.text = user.userName;
    self.screenNameLabel.text = user.screenName;
    [self.userProfileImage setImageWithURL:user.userProfilePicture withAnimationDuration:0];
}

@end
