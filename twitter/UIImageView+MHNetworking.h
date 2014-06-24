//
//  UIImageView+MHNetworking.h
//  twitter
//
//  Created by mhahn on 6/24/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MHNetworking)

- (void)setImageWithURL:(NSURL *)url
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

- (void)setImageWithURL:(NSURL *)url withAnimationDuration:(float)animationDuration;

@end
