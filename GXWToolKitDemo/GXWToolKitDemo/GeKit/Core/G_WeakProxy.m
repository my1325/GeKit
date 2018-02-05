//
//  WeakProxy.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "G_WeakProxy.h"

@implementation GeWeakProxy {
    
    __weak id target;
}

+ (instancetype)g_proxyWithTarget:(id)target {
    
    GeWeakProxy * proxy = [self alloc];
    proxy->target = target;
    
    return proxy;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    return [target respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    
    return [target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    void * null = NULL;
    [invocation setReturnValue:&null];
}

- (id)forwardingTargetForSelector:(SEL)sel {
    return target;
}

@end
