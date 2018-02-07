//
//  G_DelegateProxy.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/2/6.
//  Copyright © 2018年 My. All rights reserved.
//

#import "G_ProtocolProxy.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface GeProtocolProperty: NSObject

@property (nonatomic, assign, readonly) BOOL  isRequired;

@property (nonatomic, assign, readonly) BOOL isInstance;

@property (nonatomic, strong, readonly) NSString * name;

- (instancetype)initWithProperty: (objc_property_t)property  isRequired: (BOOL)isRequired isInstance: (BOOL)isInstance;
@end

@implementation GeProtocolProperty
- (instancetype)initWithProperty:(objc_property_t)property isRequired:(BOOL)isRequired isInstance:(BOOL)isInstance {
    
    NSAssert(property != NULL, @"property can not be null");
    
    self = [super init];
    if (!self) return nil;
    [self importProperty:property];
    return self;
}

- (void)importProperty: (objc_property_t)property {
    
    _name = [NSString stringWithUTF8String:property_getName(property)];
    
    unsigned int outCount = 0;
    objc_property_attribute_t * attributes = property_copyAttributeList(property, &outCount);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        objc_property_attribute_t attribute = attributes[index];
        
        NSLog(@"attribute {\n Name = %s, \n Value = %s}", attribute.name, attribute.value);
    }
}
@end

@interface GeProtocol: NSObject

@property (nonatomic, strong, readonly) Protocol * protocol;

@property (nonatomic, strong, readonly) NSString * name;

+ (instancetype)protocolWithProtocol: (Protocol *)protocol;

- (instancetype)initWithProtocol: (Protocol *)protocol;

@end

@implementation GeProtocol

+ (instancetype)protocolWithProtocol:(Protocol *)protocol {
    
    static NSMutableDictionary * _cachedProtocols = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cachedProtocols = @{}.mutableCopy;
    });
    
    const char * name = protocol_getName(protocol);
    if (strlen(name) == 0) return nil;
    
    NSString * key = [NSString stringWithUTF8String:name];
    
    GeProtocol * retProtocol = _cachedProtocols[key];
    
    if (!retProtocol) {
        retProtocol = [[GeProtocol alloc] initWithProtocol:protocol];
        _cachedProtocols[key] = retProtocol;
    }
    
    return retProtocol;
}

- (instancetype)initWithProtocol:(Protocol *)protocol {
    
    NSAssert(protocol != NULL, @"protocol can not be null");
    
    self = [super init];
    if (!self) return nil;
    
    _protocol = protocol;
    [self p_importProtocol:protocol];
    return self;
}

- (void)p_importProtocol: (Protocol *)protocol {
    
    _name = [NSString stringWithUTF8String:protocol_getName(protocol)];
    
}

- (void)p_importInstanceProperty: (Protocol *)protocol {
 
    unsigned int outCount = 0;
    objc_property_t * propertyList = protocol_copyPropertyList2(protocol, &outCount, YES, YES);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        objc_property_t property = propertyList[index];
        
//        property
    }
}
@end

@implementation GeProtocolProxy {
    NSMutableDictionary<NSString *, GeProtocolProxyHandler> * _actions;
    dispatch_semaphore_t _lock;
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
}

- (void)setProtocol:(Protocol *)protocol {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [_actions removeAllObjects];
    dispatch_semaphore_signal(_lock);
}

- (void)addAction:(GeProtocolProxyHandler)action replaceSelector:(SEL)selector {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [_actions setValue:action forKey:NSStringFromSelector(selector)];
    dispatch_semaphore_signal(_lock);
}

- (void)associateToObject:(id)objcect forKey:(void *)key {
    objc_setAssociatedObject(objcect, key, self, OBJC_ASSOCIATION_RETAIN);
}

@end
