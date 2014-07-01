//
//  TwitterManager.h
//  twitter
//
//  Created by mhahn on 6/23/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "User.h"
#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

#import "Tweet.h"

@interface TwitterManager : NSObject

@property (nonatomic) BOOL loggedIn;

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

- (BOOL)isLoggedIn;

- (void)authorizeClient:(NSURL *)url;
- (void)signOut;

- (User *)getCurrentUser;
- (Tweet *)getTweetAtIndex:(NSUInteger)index;
- (NSArray *)getCurrentTweets;

- (Tweet *)getMentionAtIndex:(NSUInteger)index;
- (NSArray *)getCurrentMentions;

- (RACSignal *)login;
- (RACSignal *)fetchTweetsFromTimeline;
- (RACSignal *)fetchMentions;
- (RACSignal *)sendTweet:(NSString *)tweetContent inReplyTo:(Tweet *)tweet;
- (RACSignal *)retweet:(Tweet *)tweet;
- (RACSignal *)favorite:(Tweet *)tweet;

+ (TwitterManager *)instance;

@end
