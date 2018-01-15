//
//  NSObject+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Ge)

- (void)g_observeKeyPath:(NSString *)keyPath useBlock:(void(^)(id oldValue, id newValue))block;

- (void)g_removeAllObserve;

- (void)g_removeObserveForKeyPath:(NSString *)keyPath;

- (instancetype)g_initWithConfiguration: (void(^)(id)) configuration;
@end
