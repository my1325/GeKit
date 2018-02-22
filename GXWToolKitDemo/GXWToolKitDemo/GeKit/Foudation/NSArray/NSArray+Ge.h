//
//  NSArray+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Ge)

/**
 json String
 */
@property(nonatomic, readonly) NSString * g_jsonString;

/**
 json Data
 */
@property(nonatomic, readonly) NSData * g_jsonData;

/**
 reverse
 */
@property(nonatomic, readonly) NSArray * g_reverse;

/**
 map

 @param handler handler
 @return NSArray
 */
- (NSArray *)g_map: (id(^)(id)) handler;

/**
 filter

 @param handler handler
 @return NSArray
 */
- (NSArray *)g_filter: (BOOL(^)(id)) handler;
@end
