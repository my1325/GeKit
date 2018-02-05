//
//  NSString+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Ge)

@property(nonatomic, readonly, class) NSString * g_libraryPath;

@property(nonatomic, readonly, class) NSString * g_cachePath;

@property(nonatomic, readonly, class) NSString * g_documentPath;

@property(nonatomic, readonly, class) NSString * g_tempPath;

@property(nonatomic, readonly) NSString * g_urlEncoded;

@property(nonatomic, readonly) id g_jsonObject;

@property (nonatomic, class, readonly) NSString * codeUpce;

@property (nonatomic, class, readonly) NSString * code39;

@property (nonatomic, class, readonly) NSString * code39Mod43;

@property (nonatomic, class, readonly) NSString * codeEan13;

@property (nonatomic, class, readonly) NSString * codeEan8;

@property (nonatomic, class, readonly) NSString * code93;

@property (nonatomic, class, readonly) NSString * code128;

@property (nonatomic, class, readonly) NSString * codePDF417;

@property (nonatomic, class, readonly) NSString * codeQR;

@property (nonatomic, class, readonly) NSString * codeAztec;

@property (nonatomic, class, readonly) NSString * codeInterleaved2of5;

@property (nonatomic, class, readonly) NSString * codeITF14;

@property (nonatomic, class, readonly) NSString * codeDataMatrix;


@property (nonatomic, class, readonly) NSString * aspect;

@property (nonatomic, class, readonly) NSString * aspectFill;

@property (nonatomic, class, readonly) NSString * normal;

- (NSDate *) g_toDateWithFormat: (NSString *)format;

@end

