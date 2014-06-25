//
//  Tweet.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "MHPrettyDate.h"

#import "Tweet.h"


@interface Tweet()

@end

@implementation Tweet

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"createdAt": @"created_at",
        @"tweetId": @"id_str",
        @"userName": @"user.name",
        @"screenName": @"user.screen_name",
        @"userProfilePicture": @"user.profile_image_url",
    };
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss ZZZZ yyyy";
    return dateFormatter;
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        NSDate *date = [[Tweet dateFormatter] dateFromString:str];
        return [MHPrettyDate prettyDateFromDate:date withFormat:MHPrettyDateShortRelativeTime];
    } reverseBlock:^(NSDate *date) {
        return [[Tweet dateFormatter] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)userProfilePictureJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
