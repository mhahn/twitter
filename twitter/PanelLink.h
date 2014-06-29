//
//  PanelLink.h
//  twitter
//
//  Created by mhahn on 6/28/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PanelLink : NSObject

@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *selectorString;

- (id)initWithDictionary:(NSDictionary *)data;

@end
