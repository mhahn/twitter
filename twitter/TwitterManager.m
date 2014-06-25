//
//  TwitterManager.m
//  twitter
//
//  Created by mhahn on 6/23/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TwitterManager.h"

@interface TwitterManager()

@property (strong, nonatomic) TwitterClient *client;

@end

@implementation TwitterManager

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret {
    self = [super init];
    if (self) {
        _client = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/"] consumerKey:consumerKey consumerSecret:consumerSecret];
    }
    return self;
}

- (BOOL)isLoggedIn {
    return [self.client isLoggedIn];
}

- (void)authorizeClient:(NSURL *)url {
    [self.client authorizeClient:url];
}

- (void)signOut {
    // ideally this would return a signal too, but not sure what to do about RACDisposable with no cancel operation
    [self.client.requestSerializer removeAccessToken];
}

- (RACSignal *)login {
    return [self.client login];
}

- (RACSignal *)getCurrentUser {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self.client userInfo] subscribeNext:^(NSDictionary *responseObject) {
            NSError *jsonError = nil;
            User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:&jsonError];
            self.currentUser = user;
            [subscriber sendNext:user];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return [[RACDisposable alloc] init];
    }];
    
}

- (RACSignal *)fetchTweetsFromTimeline {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[self.client homeTimeline] subscribeNext:^(id responseObject) {
            NSError *jsonError = nil;
            NSArray *tweets = [MTLJSONAdapter modelsOfClass:[Tweet class] fromJSONArray:responseObject error:&jsonError];
            
            if (jsonError) {
                [subscriber sendError:jsonError];
            } else {
                [subscriber sendNext:tweets];
                [subscriber sendCompleted];
            }
            
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [[RACDisposable alloc] init];
    }];
}

- (RACSignal *)sendTweet:(NSString *)tweetContent inReplyTo:(Tweet *)tweet {
    return [self.client sendTweet:tweetContent inReplyTo:tweet.tweetId];
}

- (RACSignal *)retweet:(Tweet *)tweet {
    return [self.client retweet:tweet.tweetId];
}

- (RACSignal *)favorite:(Tweet *)tweet {
    return [self.client favorite:tweet.tweetId];
}

+ (TwitterManager *)instance {
    static TwitterManager *instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[TwitterManager alloc] initWithConsumerKey:@"gb0RrlHtD5jyDcg29nPejByNy" consumerSecret:@"ThMqGTDTgzI59OrfqZaoChsesH8op5bQ9kLEeiGLXLMHyZFDTQ"];
    });
    return instance;
}


@end
