//
//  NSString+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@interface NSString (Ge)

G_ClassReadonlyProperty NSString * g_libraryPath;

G_ClassReadonlyProperty NSString * g_cachePath;

G_ClassReadonlyProperty NSString * g_documentPath;

G_ClassReadonlyProperty NSString * g_tempPath;

G_ReadonlyProperty(strong) NSString * g_urlEncoded;

G_ReadonlyProperty(strong) id g_jsonObject;

- (NSDate *) g_toDateWithFormat: (NSString *)format;

@end

