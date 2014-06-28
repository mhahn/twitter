//
//  ContentViewControllerDelegate.h
//  twitter
//
//  Created by mhahn on 6/26/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ContentViewControllerDelegate <NSObject>

@optional
- (void)movePanelRight;
- (void)togglePanel;
- (void)movePanel:(id)sender;

@required
- (void)movePanelToOriginalPosition;

@end
