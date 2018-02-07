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

- (UIImage *)g_fixOrientationImage {
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
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
