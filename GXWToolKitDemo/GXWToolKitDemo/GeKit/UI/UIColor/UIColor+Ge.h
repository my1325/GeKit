//
//  UIColor+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/29.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Ge)
/**
 hex color with alpha
 
 @param color color string
 @param alpha alpha
 @return UIColor
 */
+ (UIColor *)g_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 hex color with 0 alpha
 
 @param color color string
 @return UIColor
 */
+ (UIColor *)g_colorWithHexString:(NSString *)color;

/**
 hex color with hex value
 
 @param hex hex value
 @return UIColor
 */
+ (UIColor *)g_colorWithHex: (NSInteger)hex;

@end
