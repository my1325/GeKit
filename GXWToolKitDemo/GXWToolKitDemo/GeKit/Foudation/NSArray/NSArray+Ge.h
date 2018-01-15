//
//  NSArray+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@interface NSArray (Ge)

G_ReadonlyProperty(strong) NSString * g_jsonString;

G_ReadonlyProperty(strong) NSData * g_jsonData;

G_ReadonlyProperty(strong) NSArray * g_reverse;

- (NSArray *)g_map: (id(^)(id)) handler;

- (NSArray *)g_filter: (BOOL(^)(id)) handler;
@end
