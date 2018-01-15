//
//  UIImage+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Ge)

+ (UIImage *)g_imageWithColor:(UIColor *)color useSize:(CGSize)size;

- (UIImage *)g_toTargetSize: (CGSize)size;
@end
