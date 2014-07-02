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
        @"userProfilePictureLarge": @"profile_image_url",
        @"userProfileBackgroundImage": @"profile_banner_url",
        @"numberOfFollowers": @"followers_count",
        @"numberFollowing": @"following",
        @"numberOfTweets": @"statuses_count",
    };
}

+ (NSValueTransformer *)userProfilePictureJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)userProfileBackgroundImageJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)userProfilePictureLargeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^NSString*(NSString *imageURL) {
        return [NSURL URLWithString:[imageURL stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]];
    }];
}

@end
