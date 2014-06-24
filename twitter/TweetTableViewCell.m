//
//  TweetTableViewCell.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "TweetTableViewCell.h"

@interface TweetTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *tweetText;

@end

@implementation TweetTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    _tweetText.text = tweet.text;
}

@end
