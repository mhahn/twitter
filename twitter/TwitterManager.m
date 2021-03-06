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
#import "TweetSortedSet.h"

@interface TwitterManager()

@property (nonatomic, strong) User *user;
@property (strong, nonatomic) TwitterClient *client;
@property (strong, nonatomic) TweetSortedSet *tweetSet;
@property (strong, nonatomic) TweetSortedSet *mentionSet;

- (RACSignal *)fetchCurrentUser;

@end

@implementation TwitterManager

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret {
    self = [super init];
    if (self) {
        self.client = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/"] consumerKey:consumerKey consumerSecret:consumerSecret];
        self.tweetSet = [[TweetSortedSet alloc] init];
        self.mentionSet = [[TweetSortedSet alloc] init];
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUser"];
}

- (Tweet *)getTweetAtIndex:(NSUInteger)index {
    return [self.tweetSet getTweetAtIndex:index];
}

- (NSArray *)getCurrentTweets {
    return [self.tweetSet getTweets];
}

- (Tweet *)getMentionAtIndex:(NSUInteger)index {
    return [self.mentionSet getTweetAtIndex:index];
}

- (NSArray *)getCurrentMentions {
    return [self.mentionSet getTweets];
}

- (RACSignal *)login {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self.client login] subscribeError:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [[self fetchCurrentUser] subscribeError:^(NSError *error) {
                [subscriber sendError:error];
            } completed:^{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }];
        }];
        return [[RACDisposable alloc] init];
    }];
}

- (RACSignal *)fetchCurrentUser {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self.client authedUserInfo] subscribeNext:^(NSDictionary *responseObject) {
            NSError *jsonError = nil;
            User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:&jsonError];
            self.user = user;
            [subscriber sendNext:user];
            [subscriber sendCompleted];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return [[RACDisposable alloc] init];
    }];
    
}

- (RACSignal *)fetchUserInfo:(NSString *)screenName {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self.client getUserInfo:screenName] subscribeNext:^(NSArray *responseObject) {
            NSError *jsonError = nil;
            User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject[0] error:&jsonError];
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
                [self.tweetSet addTweetsToSet:tweets];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
            
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [[RACDisposable alloc] init];
    }];
}

- (RACSignal *)fetchTweetsFromUserTimeline:(NSString *)screenName {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[self.client userTimeline:screenName] subscribeNext:^(id responseObject) {
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

- (RACSignal *)fetchMentions {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [[self.client mentions] subscribeNext:^(id responseObject) {
            NSError *jsonError = nil;
            NSArray *tweets = [MTLJSONAdapter modelsOfClass:[Tweet class] fromJSONArray:responseObject error:&jsonError];
            
            if (jsonError) {
                [subscriber sendError:jsonError];
            } else {
                [self.mentionSet addTweetsToSet:tweets];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
            
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [[RACDisposable alloc] init];
    }];
}

- (RACSignal *)sendTweet:(NSString *)tweetContent inReplyTo:(Tweet *)tweet {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self.client sendTweet:tweetContent inReplyTo:tweet.tweetId] subscribeNext:^(NSDictionary *responseObject) {
            NSError *jsonError = nil;
            Tweet *tweet = [MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:responseObject error:&jsonError];
            if (jsonError) {
                [subscriber sendError:jsonError];
            } else {
                // add the new tweet to the tweet set
                [[[TwitterManager instance] tweetSet] prependTweetToSet:tweet];
                [subscriber sendNext:tweet];
                [subscriber sendCompleted];
            }
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return [[RACDisposable alloc] init];
    }];
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

- (void)setUser:(User *)user {
    _user = user;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"currentUser"];
}

- (User *)getCurrentUser {
    if (!_user) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
        _user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return _user;
}

@end
