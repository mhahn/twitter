//
//  TwitterClient.m
//  twitter
//
//  Created by mhahn on 6/23/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//
#import <ReactiveCocoa.h>

#import "NSURL+dictionaryFromQueryString.h"
#import "TwitterClient.h"

@interface TwitterClient()

@property (nonatomic, strong) NSURL *authorizationURL;
@property (nonatomic) BOOL isLoggedIn;
@property (nonatomic) BOOL isAuthorized;
- (RACSignal *)fetchRequestToken;
- (RACSignal *)fetchAccessToken;

@end

@implementation TwitterClient

- (id)init {
    self = [super self];
    if (self) {
        _isAuthorized = NO;
        _isLoggedIn = NO;
    }
    return self;
}

- (BOOL)isLoggedIn {
    if (_isLoggedIn || [self.requestSerializer accessToken]) {
        if (!_isLoggedIn) {
            _isLoggedIn = YES;
        }
        return YES;
    } else {
        return NO;
    }
}

- (RACSignal *)login {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // XXX remove once we're proplery tracking login state
        [self.requestSerializer removeAccessToken];
        
        [[self fetchRequestToken] subscribeNext:^(NSString *authURL) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        }];
        
        [[[RACObserve(self, isAuthorized) ignore:nil] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            if (_isAuthorized) {
                [[self fetchAccessToken] subscribeCompleted:^{
                    _isLoggedIn = YES;
                    [subscriber sendCompleted];
                }];
            }
        }];
        
        return [[RACDisposable alloc] init];
        
    }] doError:^(NSError *error) {
        NSLog(@"Error client login: %@", error);
    }];
}

- (RACSignal *)fetchRequestToken {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [self fetchRequestTokenWithPath:@"oauth/request_token"
                                 method:@"POST"
                            callbackURL:[NSURL URLWithString:@"cptwitter://oauth"]
                                  scope:nil
                                success:^(BDBOAuthToken *requestToken) {
                                    NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
                                    [subscriber sendNext:authURL];
                                    [subscriber sendCompleted];
                                }
                                failure:^(NSError *error) {
                                    NSLog(@"request token failure: %@", error);
                                    [subscriber sendError:error];

                                }
         ];
        return [[RACDisposable alloc] init];
    }] doError:^(NSError *error) {
        NSLog(@"Error fetchRequestToken signal: %@", error);
    }];
}

- (RACSignal *)fetchAccessToken {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if ([_authorizationURL.host isEqualToString:@"oauth"]) {
            
            NSDictionary *parameters = [_authorizationURL dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                // XXX trigger some sort of loading screen
                [self fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:_authorizationURL.query] success:^(BDBOAuthToken *accessToken) {
                    [self.requestSerializer saveAccessToken:accessToken];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    [subscriber sendError:error];
                }];
            }
        }
        return [[RACDisposable alloc] init];
        
    }];
}

- (RACSignal *)homeTimeline {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response: %@", responseObject);
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return [[RACDisposable alloc] init];
    }];
}

- (RACSignal *)sendTweet:(NSString *)tweetContent {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [self POST:@"1.1/statuses/update.json" parameters:[NSDictionary dictionaryWithObject:tweetContent forKey:@"status"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return [[RACDisposable alloc] init];;
    }];
}

- (RACSignal *)retweet:(NSString *)tweetId {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *retweetURL = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
        [self POST:retweetURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return [[RACDisposable alloc] init];
    }];
}

- (RACSignal *)favorite:(NSString *)tweetId {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self POST:@"1.1/favorites/create.json" parameters:[NSDictionary dictionaryWithObject:tweetId forKey:@"id"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return [[RACDisposable alloc] init];
    }];
}

- (RACSignal *)userInfo {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        return [[RACDisposable alloc] init];
    }];
}

- (void)authorizeClient:(NSURL *)url {
    self.authorizationURL = url;
    self.isAuthorized = YES;
}

+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/"] consumerKey:@"gb0RrlHtD5jyDcg29nPejByNy" consumerSecret:@"ThMqGTDTgzI59OrfqZaoChsesH8op5bQ9kLEeiGLXLMHyZFDTQ"];
    });
    return instance;
}

@end
