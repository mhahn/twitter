//
//  TweetSet.m
//  twitter
//
//  Created by mhahn on 6/25/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "TweetSet.h"
#import "Tweet.h"

@interface TweetSet()

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSMutableSet *tweetIds;

- (BOOL)addTweetToInteralSets:(Tweet *)tweet;
- (BOOL)insertTweetInToInternalSets:(Tweet *)tweet atIndex:(NSUInteger)index;

@end

@implementation TweetSet

- (id)init {
    self = [super init];
    if (self) {
        _tweets = [[NSMutableArray alloc] init];
        _tweetIds = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id)initWithTweets:(NSArray *)tweets {
    self = [super init];
    if (self) {
        _tweets = [NSMutableArray arrayWithArray:tweets];
        for (Tweet *tweet in tweets) {
            [_tweetIds addObject:tweet.tweetId];
        }
    }
    return self;
}

- (BOOL)insertTweetInToInternalSets:(Tweet *)tweet atIndex:(NSUInteger)index {
    BOOL added;
    if (![_tweetIds containsObject:tweet.tweetId]) {
        [_tweets insertObject:tweet atIndex:index];
        [_tweetIds addObject:tweet.tweetId];
        added = YES;
    } else {
        added = NO;
    }
    return added;
}

- (BOOL)addTweetToInteralSets:(Tweet *)tweet {
    return [self insertTweetInToInternalSets:tweet atIndex:[self.tweets count]];
}

- (BOOL)prependTweetToSet:(Tweet *)tweet {
    return [self insertTweetInToInternalSets:tweet atIndex:0];
}

- (BOOL)addTweetToSet:(Tweet *)tweet {
    return [self addTweetToInteralSets:tweet];
}

- (void)addTweetsToSet:(NSArray *)tweets {
    for (Tweet *tweet in tweets) {
        [self addTweetToInteralSets:tweet];
    }
}

- (Tweet *)getTweetAtIndex:(NSUInteger)index {
    return [_tweets objectAtIndex:index];
}

- (NSArray *)getTweets {
    return (NSArray *)_tweets;
}

@end
