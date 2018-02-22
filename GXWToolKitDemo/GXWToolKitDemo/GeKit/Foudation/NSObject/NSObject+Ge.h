//
//  NSObject+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Ge)

/**
 kvo

 @param keyPath keyPath
 @param block handler
 */
- (void)g_observeKeyPath:(NSString *)keyPath useBlock:(void(^)(id oldValue, id newValue))block;

/**
 kvo removeObserver
 */
- (void)g_removeAllObserve;

/**
 kvo remove keyPath observer

 @param keyPath keyPath
 */
- (void)g_removeObserveForKeyPath:(NSString *)keyPath;

/**
 init and give user a handler to init property

 @param configuration handler
 @return instacetype
 */
- (instancetype)g_initWithConfiguration: (void(^)(id)) configuration;
@end
