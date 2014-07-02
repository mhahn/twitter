//
//  ProfileImageSelected.h
//  twitter
//
//  Created by mhahn on 7/1/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol ProfileImageSelectedDelegate <NSObject>

@required
- (void)didSelectProfileImage:(NSString *)screenName;

@end
