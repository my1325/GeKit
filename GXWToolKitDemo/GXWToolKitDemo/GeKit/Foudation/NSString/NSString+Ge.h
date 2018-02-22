//
//  NSString+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Ge)

/**
 libraryPath
 */
@property(nonatomic, readonly, class) NSString * g_libraryPath;

/**
 cachePath
 */
@property(nonatomic, readonly, class) NSString * g_cachePath;

/**
 documentPath
 */
@property(nonatomic, readonly, class) NSString * g_documentPath;

/**
 tempPath
 */
@property(nonatomic, readonly, class) NSString * g_tempPath;

/**
 QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_codeUpce;
/**
 QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_code39;
/**
 QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_code39Mod43;
/**
 QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_codeEan13;
/**
QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_codeEan8;
/**
 QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_code93;
/**
QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_code128;
/**
 QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_codePDF417;
/**
 QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_codeQR;
/**
 QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_codeAztec;
/**
 QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_codeInterleaved2of5;
/**
 QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_codeITF14;
/**
 QRCodeType
 */
@property (nonatomic, class, readonly) NSString * g_codeDataMatrix;
/**
 QRCodeVideoGravity
 */
@property (nonatomic, class, readonly) NSString * g_aspect;
/**
 QRCodeVideoGravity
 */
@property (nonatomic, class, readonly) NSString * g_aspectFill;
/**
 QRCodeVideoGravity
 */
@property (nonatomic, class, readonly) NSString * g_normal;
/**
 字符集
 */
@property(nonatomic, readonly) NSArray<NSString *> * g_charactors;

/**
 url编码
 */
@property(nonatomic, readonly) NSString * g_urlEncoded;

/**
 倒序排列
 */
@property(nonatomic, readonly) NSString * g_reverse;

/**
 json转化
 */
@property(nonatomic, readonly) id g_jsonObject;

/**
 日期

 @param format format方式
 @return NSDate
 */
- (NSDate *) g_toDateWithFormat: (NSString *)format;

/**
 枚举

 @param handler handler
 */
- (void) g_enumerateWithHandler: (void(^)(NSString *))handler;
@end

