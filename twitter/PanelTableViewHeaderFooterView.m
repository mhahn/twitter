//
//  PanelProfileTableViewCell.m
//  twitter
//
//  Created by mhahn on 6/28/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "PanelTableViewHeaderFooterView.h"
#import "UIImageView+MHNetworking.h"

@interface PanelTableViewHeaderFooterView()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;

@end

@implementation PanelTableViewHeaderFooterView

- (void)setUser:(User *)user {
    _user = user;
    _userNameLabel.text = user.userName;
    _screenNameLabel.text = user.screenName;
    [_userProfileImage setImageWithURL:user.userProfilePicture withAnimationDuration:0];
}

@end
