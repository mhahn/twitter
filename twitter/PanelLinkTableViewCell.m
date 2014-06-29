//
//  PanelLinkTableViewCell.m
//  twitter
//
//  Created by mhahn on 6/28/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "PanelLinkTableViewCell.h"

@interface PanelLinkTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *linkLabel;

@end

@implementation PanelLinkTableViewCell

- (void)setLink:(PanelLink *)link {
    _link = link;
    _linkLabel.text = link.label;
}

@end
