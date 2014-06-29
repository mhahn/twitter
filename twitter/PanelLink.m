//
//  PanelLink.m
//  twitter
//
//  Created by mhahn on 6/28/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "PanelLink.h"

@implementation PanelLink

- (id)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _label = data[@"label"];
        _selectorString = data[@"selector"];
    }
    return self;
}

@end
