//
//  NSArray+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Ge)

@property(nonatomic, readonly) NSString * g_jsonString;

@property(nonatomic, readonly) NSData * g_jsonData;

@property(nonatomic, readonly) NSArray * g_reverse;

- (NSArray *)g_map: (id(^)(id)) handler;

- (NSArray *)g_filter: (BOOL(^)(id)) handler;
@end
