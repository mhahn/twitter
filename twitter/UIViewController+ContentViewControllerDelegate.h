//
//  UIViewController+ContentViewControllerDelegate.h
//  twitter
//
//  Created by mhahn on 6/28/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContentViewControllerDelegate.h"

@interface UIViewController (ContentViewControllerDelegate)

@property (nonatomic, assign) id<ContentViewControllerDelegate> delegate;

@end
