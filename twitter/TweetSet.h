//
//  TweetSet.h
//  twitter
//
//  Created by mhahn on 6/25/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@interface TweetSet : NSObject

- (id)initWithTweets:(NSArray *)tweets;
- (BOOL)addTweetToSet:(Tweet *)tweet;
- (void)addTweetsToSet:(NSArray *)tweets;
- (BOOL)prependTweetToSet:(Tweet *)tweet;
- (NSArray *)getTweets;
- (Tweet *)getTweetAtIndex:(NSUInteger)index;

@end
