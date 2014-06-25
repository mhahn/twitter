//
//  User.h
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <Mantle.h>

@interface User : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSURL *userProfilePicture;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *userId;

@end
