//
//  MainViewController.h
//  twitter
//
//  Created by mhahn on 6/26/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>

// this is going to be the main view that routes to the other views

// at any point in time for a logged in user we'll have two views:

// left pannel
// content view
//  - the content view can be either the TimelineView, TweetDetailsView, ProfileView, MentionsView

// should have some method to setContentView

@interface MainViewController : UIViewController <UIGestureRecognizerDelegate>

- (id)initWithContentViewController:(UIViewController *)contentViewController;
- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated;

@end
