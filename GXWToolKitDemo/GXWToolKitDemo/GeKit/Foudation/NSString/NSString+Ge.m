//
//  NSString+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "NSString+Ge.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSString (Ge)

+ (NSString *)g_libraryPath {
    
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)g_tempPath {
    
    return NSTemporaryDirectory();
}

+ (NSString *)g_cachePath {
    
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)g_documentPath {
    
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

- (NSString *)g_urlEncoded {
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}

- (id)g_jsonObject {
    
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

+ (NSString *)codeUpce {
    return AVMetadataObjectTypeUPCECode;
}

+ (NSString *)code39 {
    return AVMetadataObjectTypeCode39Code;
}

+ (NSString *)code93 {
    return AVMetadataObjectTypeCode93Code;
}

+ (NSString *)codeQR {
    return AVMetadataObjectTypeQRCode;
}

+ (NSString *)code128 {
    return AVMetadataObjectTypeCode128Code;
}

+ (NSString *)codeEan8 {
    return AVMetadataObjectTypeEAN8Code;
}

+ (NSString *)codeAztec {
    return AVMetadataObjectTypeAztecCode;
}

+ (NSString *)codeITF14 {
    return AVMetadataObjectTypeITF14Code;
}

+ (NSString *)codePDF417 {
    return AVMetadataObjectTypePDF417Code;
}

+ (NSString *)codeEan13 {
    return AVMetadataObjectTypeEAN13Code;
}

+ (NSString *)code39Mod43 {
    return AVMetadataObjectTypeCode39Mod43Code;
}

+ (NSString *)codeDataMatrix {
    return AVMetadataObjectTypeDataMatrixCode;
}

+ (NSString *)codeInterleaved2of5 {
    return AVMetadataObjectTypeInterleaved2of5Code;
}

+ (NSString *)aspect {
    return AVLayerVideoGravityResizeAspect;
}

+ (NSString *)aspectFill {
    return AVLayerVideoGravityResizeAspectFill;
}

+ (NSString *)normal {
    return AVLayerVideoGravityResize;
}

- (NSDate *)g_toDateWithFormat:(NSString *)format {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    
    return [formatter dateFromString:self];
}
@end
