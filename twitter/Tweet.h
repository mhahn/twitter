//
//  Tweet.h
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <Mantle.h>

@interface Tweet : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *text;

@end
