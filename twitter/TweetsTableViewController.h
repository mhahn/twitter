//
//  TimelineTableViewController.h
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContentViewControllerDelegate.h"

typedef NS_ENUM(NSUInteger, TweetsTableViewControllerType) {
    TweetsTableViewControllerMentions = 1,
    TweetsTableViewControllerTimeline = 2,
};

@interface TweetsTableViewController : UITableViewController

- (id)initWithTypeOfController:(TweetsTableViewControllerType)controllerType;
@property (nonatomic, assign) id<ContentViewControllerDelegate> delegate;

@end
