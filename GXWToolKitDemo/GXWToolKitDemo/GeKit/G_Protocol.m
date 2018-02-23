//
//  G_Protocol.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/2/22.
//  Copyright © 2018年 My. All rights reserved.
//

#import "G_Protocol.h"


@implementation GeMethodDescription

- (instancetype)initWithMethodDescription:(struct objc_method_description)descrition isRequired:(BOOL)isRequired isInstance:(BOOL)isInstance {
    
    self = [super init];
    if (!self) return nil;
    
    _types = [NSString stringWithUTF8String:descrition.types];
    _name = [NSString stringWithUTF8String:sel_getName(descrition.name)];
    _isInstance = isInstance;
    _isRequired = isRequired;
    return self;
}

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

- (GeMethodDescription *)descriptionForSelector: (SEL)selector {
    
    for (GeMethodDescription * description in _methodDescriptions)
        if (strcmp(description.name.UTF8String, sel_getName(selector)) == 0)
            return description;
    
    return nil;
}

- (void)p_importProtocol: (Protocol *)protocol {
    
    _name = [NSString stringWithUTF8String:protocol_getName(protocol)];
    
    [self p_importProperty:protocol];
    [self p_importSelector:protocol];
}

- (void)p_importSelector: (Protocol *)protocol {
    
    NSMutableArray * _descriptions = [[NSMutableArray alloc] init];
    
    unsigned int outCount = 0;
    struct objc_method_description * methodList = protocol_copyMethodDescriptionList(protocol, YES, YES, &outCount);
    
    for (NSInteger index = 0; index < outCount; index++) {
        
        GeMethodDescription * description = [[GeMethodDescription alloc] initWithMethodDescription:methodList[index] isRequired:YES isInstance:YES];
        [_descriptions addObject:description];
    }
    free(methodList);
    
    outCount = 0;
    methodList = protocol_copyMethodDescriptionList(protocol, YES, NO, &outCount);
    
    for (NSInteger index = 0; index < outCount; index++) {
        
        GeMethodDescription * description = [[GeMethodDescription alloc] initWithMethodDescription:methodList[index] isRequired:YES isInstance:NO];
        [_descriptions addObject:description];
    }
    free(methodList);
    
    outCount = 0;
    methodList = protocol_copyMethodDescriptionList(protocol, NO, YES, &outCount);
    
    for (NSInteger index = 0; index < outCount; index++) {
        
        GeMethodDescription * description = [[GeMethodDescription alloc] initWithMethodDescription:methodList[index] isRequired:NO isInstance:YES];
        [_descriptions addObject:description];
    }
    free(methodList);
    
    outCount = 0;
    methodList = protocol_copyMethodDescriptionList(protocol, NO, NO, &outCount);
    
    for (NSInteger index = 0; index < outCount; index++) {
        
        GeMethodDescription * description = [[GeMethodDescription alloc] initWithMethodDescription:methodList[index] isRequired:NO isInstance:NO];
        [_descriptions addObject:description];
    }
    free(methodList);
    
    _methodDescriptions = _descriptions.copy;
}

- (void)p_importProperty: (Protocol *)protocol {
    
    NSMutableArray * __properties = @[].mutableCopy;
    
    unsigned int outCount = 0;
    objc_property_t * propertyList = protocol_copyPropertyList2(protocol, &outCount, YES, YES);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        objc_property_t property = propertyList[index];
        
        GeProperty * _property = [[GeProperty alloc] initWithProperty:property isRequired:YES isInstance:YES];
        [__properties addObject:_property];
    }
    free(propertyList);
    
    outCount = 0;
    propertyList = protocol_copyPropertyList2(protocol, &outCount, YES, NO);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        objc_property_t property = propertyList[index];
        
        GeProperty * _property = [[GeProperty alloc] initWithProperty:property isRequired:YES isInstance:NO];
        [__properties addObject:_property];
    }
    free(propertyList);
    
    outCount = 0;
    propertyList = protocol_copyPropertyList2(protocol, &outCount, NO, YES);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        objc_property_t property = propertyList[index];
        
        GeProperty * _property = [[GeProperty alloc] initWithProperty:property isRequired:NO isInstance:YES];
        [__properties addObject:_property];
    }
    free(propertyList);
    
    outCount = 0;
    propertyList = protocol_copyPropertyList2(protocol, &outCount, NO, NO);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        objc_property_t property = propertyList[index];
        
        GeProperty * _property = [[GeProperty alloc] initWithProperty:property isRequired:NO isInstance:NO];
        [__properties addObject:_property];
    }
    free(propertyList);
    
    _properties = __properties.copy;
}
@end
