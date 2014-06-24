//
//  TwitterManager.m
//  twitter
//
//  Created by mhahn on 6/23/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

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

- (RACSignal *)login {
    return [self.client login];
}

// XXX i think i like calling this "instance" more
+ (TwitterManager *)sharedManager {
    static TwitterManager *sharedManager = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedManager = [[TwitterManager alloc] initWithConsumerKey:@"gb0RrlHtD5jyDcg29nPejByNy" consumerSecret:@"ThMqGTDTgzI59OrfqZaoChsesH8op5bQ9kLEeiGLXLMHyZFDTQ"];
    });
    return sharedManager;
}


@end
