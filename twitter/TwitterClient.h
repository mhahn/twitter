//
//  TwitterClient.h
//  twitter
//
//  Created by mhahn on 6/23/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//
#import <ReactiveCocoa.h>

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

- (BOOL)isLoggedIn;
- (void)authorizeClient:(NSURL *)url;
- (RACSignal *)login;
- (RACSignal *)userTimeline:(NSString *)screenName;
- (RACSignal *)homeTimeline;
- (RACSignal *)mentions;
- (RACSignal *)sendTweet:(NSString *)tweetContent inReplyTo:(NSString *)tweetId;
- (RACSignal *)retweet:(NSString *)tweetId;
- (RACSignal *)favorite:(NSString *)tweetId;
- (RACSignal *)authedUserInfo;
- (RACSignal *)getUserInfo:(NSString *)screenName;

@end
