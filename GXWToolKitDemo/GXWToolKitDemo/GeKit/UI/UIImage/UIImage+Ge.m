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

+ (UIImage *)qrCodeImageWithTitle:(NSString *)title
                             size:(CGSize)size
                      qrCodeColor:(UIColor *)qrCodeColor
                  backgroundColor:(UIColor *)backgroundColor
                      centerImage:(UIImage *)centerImage
{    
    NSData * stringData = [title dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter * qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIFilter * colorFilter = [CIFilter filterWithName:@"CIFalseColor" withInputParameters:@{@"inputImage": qrFilter.outputImage, @"inputColor0": [CIColor colorWithCGColor:qrCodeColor.CGColor], @"inputColor1": backgroundColor.CIColor}];
    
    CIImage * qrImage = colorFilter.outputImage;
    
    CGImageRef cgImage = [[CIContext new] createCGImage:qrImage fromRect:qrImage.extent];
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    
    //    // 3. 绘制小图片
    if (centerImage) {
        CGSize logoSize = centerImage.size;
        CGPoint origin = (CGPoint){(size.width - logoSize.width) * 0.5, (size.height - logoSize.height) * 0.5};
        CGContextDrawImage(context, (CGRect){origin.x, origin.y, logoSize.width, logoSize.height}, centerImage.CGImage);
    }
    
    UIImage * codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return codeImage;
}

- (NSArray<NSString *> *)g_qrCodes {
    
    CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    CIImage * qrCodeCIImage = [CIImage imageWithCGImage:self.CGImage];
    
    NSArray<CIFeature *> * qrCodeFeatures = [detector featuresInImage:qrCodeCIImage options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    NSMutableArray * results = @[].mutableCopy;
    for (CIFeature * feature in qrCodeFeatures) {
        
        if ([feature isKindOfClass:[CIQRCodeFeature class]]) {
            
            CIQRCodeFeature * qrCodeFeature = (CIQRCodeFeature *)feature;
            if (!qrCodeFeature.messageString) continue;
            [results addObject:qrCodeFeature.messageString];
        }
    }
    return results.copy;
}
@end
