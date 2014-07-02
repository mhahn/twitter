//
//  ProfileTableViewController.h
//  twitter
//
//  Created by mhahn on 7/1/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContentViewControllerDelegate.h"

@interface ProfileTableViewController : UITableViewController

@property (nonatomic, assign) id<ContentViewControllerDelegate> delegate;

- (id)initWithScreenName:(NSString *)screenName;

@end
