//
//  TwitterManager.h
//  twitter
//
//  Created by mhahn on 6/23/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface TwitterManager : NSObject

@property (nonatomic) BOOL loggedIn;

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

- (BOOL)isLoggedIn;

- (void)authorizeClient:(NSURL *)url;
- (void)signOut;

- (RACSignal *)login;
- (RACSignal *)fetchTweetsFromTimeline;
- (RACSignal *)sendTweet:(NSString *)tweetContent;


+ (TwitterManager *)instance;

@end
