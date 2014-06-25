//
//  User.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"userId": @"id_str",
        @"userName": @"name",
        @"screenName": @"screen_name",
        @"userProfilePicture": @"profile_image_url",
    };
}

+ (NSValueTransformer *)userProfilePictureJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
