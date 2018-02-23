//
//  G_DelegateProxy.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/2/6.
//  Copyright © 2018年 My. All rights reserved.
//

#import "G_ProtocolProxy.h"
#import "G_Protocol.h"
#import "G_Property.h"


@implementation GeProtocolProxy {
    NSMutableDictionary<NSString *, GeProtocolProxyHandler> * _actions;
    dispatch_semaphore_t _lock;
    GeProtocol * _geProtocol;
}

+ (instancetype)delegateProxyWithProtocol:(Protocol *)protocol {
    return [[self alloc] initWithProxy:protocol];
}

- (instancetype)initWithProxy: (Protocol *)protocol {
    self = [super init];
    if (!self) return nil;
    
    _lock = dispatch_semaphore_create(1);
    _protocol = protocol;
    _actions = @{}.mutableCopy;
    [self p_confirmProtocol:protocol];
    return self;
}

- (void)p_confirmProtocol: (Protocol *)protocol {
    class_addProtocol([self class], protocol);
    _geProtocol = [GeProtocol protocolWithProtocol:protocol];
}

- (void)p_replaceSelector: (SEL)selector withAction: (GeProtocolProxyHandler)action {
    
    [_actions setValue:action forKey:NSStringFromSelector(selector)];

    GeMethodDescription * description = [_geProtocol descriptionForSelector:selector];
    
    NSAssert(description != nil, @"获取对应的协议(%@)方法(%@)失败，请检查参数", NSStringFromProtocol(_protocol), NSStringFromSelector(selector));
    
    IMP methodImp = imp_implementationWithBlock(action);

    class_addMethod([self class], selector, methodImp, description.types.UTF8String);
}

- (void)setProtocol:(Protocol *)protocol {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [_actions removeAllObjects];
    dispatch_semaphore_signal(_lock);
}

- (void)addAction:(GeProtocolProxyHandler)action replaceSelector:(SEL)selector {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [self p_replaceSelector:selector withAction:action];
    dispatch_semaphore_signal(_lock);
}

- (void)associateToObject:(id)objcect forKey:(void *)key {
    objc_setAssociatedObject(objcect, key, self, OBJC_ASSOCIATION_RETAIN);
}

@end
