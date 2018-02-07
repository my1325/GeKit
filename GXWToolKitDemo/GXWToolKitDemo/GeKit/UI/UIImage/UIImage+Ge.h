//
//  UIImage+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Ge)
/**
 图片选择修正
 */
@property (nonatomic, readonly) UIImage * g_fixOrientationImage;
/**
 解析图片中的二维码
 */
@property (nonatomic, readonly) NSArray<NSString *> * g_qrCodes;
/**
 生成二维码图片

 @param title title
 @param size size
 @param qrCodeColor 二维码颜色
 @param backgroundColor 背景颜色
 @param centerImage 中间的logo
 @return UIImage
 */
+ (UIImage *)qrCodeImageWithTitle: (NSString *)title
                             size: (CGSize)size
                      qrCodeColor: (UIColor *)qrCodeColor
                  backgroundColor: (UIColor *)backgroundColor
                      centerImage: (UIImage *)centerImage;
/**
 生成某种颜色得图片

 @param color 颜色
 @param size 大小
 @return UIImage
 */
+ (UIImage *)g_imageWithColor:(UIColor *)color useSize:(CGSize)size;

/**
 压缩图片到指定大小

 @param size 大小
 @return UIImage
 */
- (UIImage *)g_toTargetSize: (CGSize)size;

@end
