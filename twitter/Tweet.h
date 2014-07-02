//
//  Tweet.h
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <Mantle.h>

@interface Tweet : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *prettyCreatedAt;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *formattedScreenName;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSURL *userProfilePicture;
@property (nonatomic, strong) NSString *favoritesCount;
@property (nonatomic, strong) NSString *retweetsCount;

@end
