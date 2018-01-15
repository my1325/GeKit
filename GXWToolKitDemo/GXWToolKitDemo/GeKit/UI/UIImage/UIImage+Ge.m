//
//  UIImage+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "UIImage+Ge.h"

@implementation UIImage (Ge)

+ (UIImage *)g_imageWithColor:(UIColor *)color useSize:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect){0, 0, size.width, size.height});
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)g_toTargetSize:(CGSize)size {
    
    UIImage * newImage = nil;
    CGSize imageSize = self.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat twidth = size.width;
    CGFloat theight = size.height;
    CGPoint point = (CGPoint){0, 0};
    CGFloat scaleFactor = 0.0;
    CGFloat sacaledWidth = twidth;
    CGFloat scaledHeight = theight;
    
    if (imageSize.width != size.width && imageSize.height != size.height)
    {
        CGFloat widthFactor = twidth / (CGFloat)width;
        CGFloat heightFactor = height / (CGFloat)width;
        scaleFactor = MAX(widthFactor, heightFactor);
        
        sacaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) point.y = (theight - scaledHeight) * 0.5;
        else if (widthFactor < heightFactor)  point.x = (twidth - sacaledWidth) * 0.5;
    }
    
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = point;
    thumbnailRect.size.width = sacaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
