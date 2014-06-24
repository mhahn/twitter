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
        
        return [RACDisposable disposableWithBlock:^{
            [self.operationQueue cancelAllOperations];
        }];
        
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
        return [RACDisposable disposableWithBlock:^{
            [self.operationQueue cancelAllOperations];
        }];
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
        return [RACDisposable disposableWithBlock:^{
            [self.operationQueue cancelAllOperations];
        }];
        
    }];
}

- (void)authorizeClient:(NSURL *)url {
    self.authorizationURL = url;
    self.isAuthorized = YES;
}

- (AFHTTPRequestOperation *)homeTimeline {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
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
