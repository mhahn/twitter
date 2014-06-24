//
//  UIImageView+MHNetworking.m
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "UIImageView+MHNetworking.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (MHNetworking)

- (void)setImageWithURL:(NSURL *)url success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, UIImage *))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *))failure {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self setImageWithURLRequest:request placeholderImage:nil success:success failure:failure];
    
}

- (void)setImageWithURL:(NSURL *)url withAnimationDuration:(float)animationDuration {
    __weak UIImageView *weakImageView = self;
    [self setImageWithURL:url
                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                      UIImageView *strongImageView = weakImageView;
                      if (animationDuration) {
                          strongImageView.alpha = 0.0;
                      }
                      strongImageView.image = image;
                      if (animationDuration) {
                          [UIView animateWithDuration:0.5 animations:^{
                              strongImageView.alpha = 1.0;
                          }];
                      }
                  }
                  failure:nil];
    
}

@end
