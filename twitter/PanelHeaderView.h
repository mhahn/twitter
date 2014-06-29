//
//  PanelHeaderView.h
//  twitter
//
//  Created by mhahn on 6/28/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface PanelHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) User *user;

@end
