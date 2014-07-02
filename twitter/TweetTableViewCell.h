//
//  TweetTableViewCell.h
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "ProfileImageSelectedDelegate.h"

@interface TweetTableViewCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, assign) id<ProfileImageSelectedDelegate> delegate;


@end
