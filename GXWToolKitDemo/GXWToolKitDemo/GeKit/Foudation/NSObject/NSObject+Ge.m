//
//  NSObject+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "NSObject+Ge.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>

@implementation NSObject (Ge)
static int executeBlock;

- (NSMutableDictionary<NSString *, NSMutableArray<id> *> *)ge_executeBlockDict {
    NSMutableDictionary * executeDict = objc_getAssociatedObject(self, &executeBlock);
    if (!executeDict) {
        executeDict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &executeBlock, executeDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return executeDict;
}

- (void)g_observeKeyPath:(NSString *)keyPath useBlock:(void (^)(id, id))block {
    NSMutableArray * blockArray = [[self ge_executeBlockDict] valueForKey:keyPath];
    if (!blockArray) {
        blockArray = [NSMutableArray array];
        [[self ge_executeBlockDict] setValue:blockArray forKey:keyPath];
        
        [self addObserver:self
               forKeyPath:keyPath
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
    }
    [blockArray addObject:block];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    id oldValue = [change valueForKey:NSKeyValueChangeOldKey];
    id newValue = [change valueForKey:NSKeyValueChangeNewKey];
    
    //executeBlock
    NSArray * blockArray = [[self ge_executeBlockDict] valueForKey:keyPath];
    
    [blockArray enumerateObjectsUsingBlock:^(void(^block)(id, id), NSUInteger idx, BOOL * _Nonnull stop)
     {
         block(oldValue, newValue);
     }];
}

- (void)g_removeObserveForKeyPath:(NSString *)keyPath {
    
    //removeBlock
    NSMutableArray * blockArray = [[self ge_executeBlockDict] valueForKey:keyPath];
    [blockArray removeAllObjects];
    [self removeObserver:self forKeyPath:keyPath];
}

- (void)g_removeAllObserve {
    
    [[self ge_executeBlockDict] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray<id> * _Nonnull obj, BOOL * _Nonnull stop)
     {
         [self removeObserver:self forKeyPath:key];
     }];
    
    [[self ge_executeBlockDict] removeAllObjects];
}

- (instancetype)g_initWithConfiguration:(void (^)(id))configuration {
    
    id object = [self init];
    if (configuration) configuration(object);
    
    return object;
}
@end
