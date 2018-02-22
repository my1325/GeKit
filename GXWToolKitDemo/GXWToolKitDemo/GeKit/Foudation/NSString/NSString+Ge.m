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

+ (NSString *)g_codeUpce {
    return AVMetadataObjectTypeUPCECode;
}

+ (NSString *)g_code39 {
    return AVMetadataObjectTypeCode39Code;
}

+ (NSString *)g_code93 {
    return AVMetadataObjectTypeCode93Code;
}

+ (NSString *)g_codeQR {
    return AVMetadataObjectTypeQRCode;
}

+ (NSString *)g_code128 {
    return AVMetadataObjectTypeCode128Code;
}

+ (NSString *)g_codeEan8 {
    return AVMetadataObjectTypeEAN8Code;
}

+ (NSString *)g_codeAztec {
    return AVMetadataObjectTypeAztecCode;
}

+ (NSString *)g_codeITF14 {
    return AVMetadataObjectTypeITF14Code;
}

+ (NSString *)g_codePDF417 {
    return AVMetadataObjectTypePDF417Code;
}

+ (NSString *)g_codeEan13 {
    return AVMetadataObjectTypeEAN13Code;
}

+ (NSString *)g_code39Mod43 {
    return AVMetadataObjectTypeCode39Mod43Code;
}

+ (NSString *)g_codeDataMatrix {
    return AVMetadataObjectTypeDataMatrixCode;
}

+ (NSString *)g_codeInterleaved2of5 {
    return AVMetadataObjectTypeInterleaved2of5Code;
}

+ (NSString *)g_aspect {
    return AVLayerVideoGravityResizeAspect;
}

+ (NSString *)g_aspectFill {
    return AVLayerVideoGravityResizeAspectFill;
}

+ (NSString *)g_normal {
    return AVLayerVideoGravityResize;
}

- (NSDate *)g_toDateWithFormat:(NSString *)format {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    
    return [formatter dateFromString:self];
}

- (NSString *)g_urlEncoded {
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}

- (id)g_jsonObject {
    
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

- (NSString *)g_reverse {
    
    NSMutableString * _reverseString = @"".mutableCopy;
    for (NSInteger index = self.length - 1; index < 0; index --) {
        
        unichar charactor = [self characterAtIndex:index];
        [_reverseString appendString:[NSString stringWithCharacters:&charactor length:1]];
    }

    return _reverseString.copy;
}

- (NSArray<NSString *> *)g_charactors {
    
    NSMutableArray * _charactors = @[].mutableCopy;
    for (NSInteger index = 0; index < self.length; index ++) {
        
        unichar charactor = [self characterAtIndex:index];
        [_charactors addObject:[NSString stringWithCharacters:&charactor length:1]];
    }
    return _charactors.copy;
}

- (void)g_enumerateWithHandler:(void (^)(NSString *))handler {
    
    if (!handler) return;
    
    for (NSString * charString in self.g_charactors)
        handler(charString);
}
@end
