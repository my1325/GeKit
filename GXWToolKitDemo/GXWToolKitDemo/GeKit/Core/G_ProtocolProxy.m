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

/* porperty 属性声明(默认属性，atomic，readwrite，assign)，如果是block类型会自动变成copy
 description    Name   Value
 type          T
 nonatomic    N
 readonly      R
 copy           C
 strong/retain    &
 weak           W
 
 type 说明(^代表指针，如果是基本数据类型，有多少个^代表几级指针，如果是@，则代表^+1级指针)
 比如^^i, 代表int的二级指针, ^@ 代表某类型的二级指针
 @ ---- id
 @"type" --- type(oc 类型)
 # --- class
 @? --- void(^)() ----block
 v? --- void(*)() --- 函数指针
 ? --- selector
 {name=types} --- struct
 [countType] --- 数组
 (name=type) --- 联合
 ^tyoe --- type *
 * --- char *
 i --- int (int32_t)
 I --- unsigned int
 q --- NSInteger (long, long long)
 Q --- NSUInteger (unsigned long, unsigned long long)
 f --- float
 d --- double (CGFloat)
 c --- int8_t (char)
 C --- unsigned char
 s --- int16_t (short)
 S --- unsigned short
 B --- BOOL
 ? --- unkonw
 */

typedef int16_t GePropertyTypeSize;

@interface GePropertyType: NSObject

@property (nonatomic, readonly, class) GePropertyType * g_unkonw;

@property (nonatomic, readonly, strong) NSString * stringValue;

@property (nonatomic, readonly, strong) NSString * encodeValue;

@property (nonatomic, readonly, assign) GePropertyTypeSize size;

- (instancetype)initWithEncodeValue: (const char *)encodeValue;
@end

@implementation GePropertyType
+ (GePropertyType *)g_unkonw {
    static GePropertyType * _unkonw = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _unkonw = [[GePropertyType alloc] initWithEncodeValue:"?"];
    });
    return _unkonw;
}

- (instancetype)initWithEncodeValue:(const char *)encodeValue {
    
    if (strlen(encodeValue) == 0) {
        return GePropertyType.g_unkonw;
    }
    else {
        self = [super init];
        if (!self) return nil;
        
        _encodeValue = [NSString stringWithUTF8String:encodeValue];
        return self;
    }
}

- (BOOL)isEqualToType: (GePropertyType *)type {
    return [_encodeValue isEqualToString:type.encodeValue];
}
@end


@interface GeCBasicValueType: GePropertyType

@property (nonatomic, readonly, class) GeCBasicValueType * g_char;

@property (nonatomic, readonly, class) GeCBasicValueType * g_unsigned_char;

@property (nonatomic, readonly, class) GeCBasicValueType * g_int;

@property (nonatomic, readonly, class) GeCBasicValueType * g_unsigned_int;

@property (nonatomic, readonly, class) GeCBasicValueType * g_short;

@property (nonatomic, readonly, class) GeCBasicValueType * g_unsigned_short;

@property (nonatomic, readonly, class) GeCBasicValueType * g_integer; /// long, long long

@property (nonatomic, readonly, class) GeCBasicValueType * g_unsigned_integer; // unsigned long, unsigned long long

@property (nonatomic, readonly, class) GeCBasicValueType * g_float;

@property (nonatomic, readonly, class) GeCBasicValueType * g_double;

@property (nonatomic, readonly, class) GeCBasicValueType * g_bool;

+ (instancetype)basicValueTypeForEncodeValue: (const char *)encodeValue;
@end

@implementation GeCBasicValueType {
    
    GePropertyTypeSize _typeSize;
    NSString * _stringValue;
}

+ (instancetype)basicValueTypeForEncodeValue:(const char *)encodeValue {
    if (strcmp(encodeValue, @encode(int)) == 0) return self.g_int;
    else if (strcmp(encodeValue, @encode(char)) == 0) return self.g_char;
    else if (strcmp(encodeValue, @encode(short)) == 0) return self.g_short;
    else if (strcmp(encodeValue, @encode(NSInteger)) == 0) return self.g_integer;
    else if (strcmp(encodeValue, @encode(NSUInteger)) == 0) return self.g_unsigned_integer;
    else if (strcmp(encodeValue, @encode(unsigned int)) == 0) return self.g_unsigned_int;
    else if (strcmp(encodeValue, @encode(float)) == 0) return self.g_float;
    else if (strcmp(encodeValue, @encode(double)) == 0) return self.g_double;
    else if (strcmp(encodeValue, @encode(unsigned char)) == 0) return self.g_unsigned_char;
    else if (strcmp(encodeValue, @encode(BOOL)) == 0) return self.g_bool;
    else return nil;
}

+ (GeCBasicValueType *)g_int {
    static GeCBasicValueType * _int = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _int = [[GeCBasicValueType alloc] initWithEncodeValue:"i"];
    });
    return _int;
}

+ (GeCBasicValueType *)g_short {
    static GeCBasicValueType * _short = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _short = [[GeCBasicValueType alloc] initWithEncodeValue:"s"];
    });
    return _short;
}

+ (GeCBasicValueType *)g_integer {
    static GeCBasicValueType * _integer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _integer = [[GeCBasicValueType alloc] initWithEncodeValue:"q"];
    });
    return _integer;
}

+ (GeCBasicValueType *)g_char {
    static GeCBasicValueType * _char = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _char = [[GeCBasicValueType alloc] initWithEncodeValue:"c"];
    });
    return _char;
}

+ (GeCBasicValueType *)g_unsigned_int {
    static GeCBasicValueType * _unsigned_int = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _unsigned_int = [[GeCBasicValueType alloc] initWithEncodeValue:"I"];
    });
    return _unsigned_int;
}

+ (GeCBasicValueType *)g_unsigned_short {
    static GeCBasicValueType * _unsigned_short = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _unsigned_short = [[GeCBasicValueType alloc] initWithEncodeValue:"S"];
    });
    return _unsigned_short;
}

+ (GeCBasicValueType *)g_unsigned_char {
    static GeCBasicValueType * _unsigned_char = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _unsigned_char = [[GeCBasicValueType alloc] initWithEncodeValue:"C"];
    });
    return _unsigned_char;
}

+ (GeCBasicValueType *)g_unsigned_integer {
    static GeCBasicValueType * _unsigned_integer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _unsigned_integer = [[GeCBasicValueType alloc] initWithEncodeValue:"Q"];
    });
    return _unsigned_integer;
}

+ (GeCBasicValueType *)g_float {
    static GeCBasicValueType * _float = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _float = [[GeCBasicValueType alloc] initWithEncodeValue:"f"];
    });
    return _float;
}

+ (GeCBasicValueType *)g_double {
    static GeCBasicValueType * _double = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _double = [[GeCBasicValueType alloc] initWithEncodeValue:"d"];
    });
    return _double;
}

+ (GeCBasicValueType *)g_bool {
    static GeCBasicValueType * _bool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bool = [[GeCBasicValueType alloc] initWithEncodeValue:"B"];
    });
    return _bool;
}

- (GePropertyTypeSize)size {
    if (_typeSize == 0) {
        [self p_decodeType];
    }
    return _typeSize;
}

- (NSString *)stringValue {
    if (_stringValue.length == 0) {
        [self p_decodeType];
    }
    return _stringValue;
}

- (void)p_decodeType {
    
    if ([self.encodeValue isEqualToString:@"i"]) {
        _typeSize = sizeof(int);
        _stringValue = @"int";
    }
    else if ([self.encodeValue isEqualToString:@"c"]) {
        _typeSize = sizeof(char);
        _stringValue = @"char";
    }
    else if ([self.encodeValue isEqualToString:@"s"]) {
        _typeSize = sizeof(short);
        _stringValue = @"short";
    }
    else if ([self.encodeValue isEqualToString:@"q"]) {
        _typeSize = sizeof(NSInteger);
        _stringValue = @"NSInteger";
    }
    else if ([self.encodeValue isEqualToString:@"I"]) {
        _typeSize = sizeof(unsigned int);
        _stringValue = @"unsigned int";
    }
    else if ([self.encodeValue isEqualToString:@"Q"]) {
        _typeSize = sizeof(NSUInteger);
        _stringValue = @"NSUInteger";
    }
    else if ([self.encodeValue isEqualToString:@"f"]) {
        _typeSize = sizeof(float);
        _stringValue = @"float";
    }
    else if ([self.encodeValue isEqualToString:@"d"]) {
        _typeSize = sizeof(double);
        _stringValue = @"double";
    }
    else if ([self.encodeValue isEqualToString:@"C"]) {
        _typeSize = sizeof(unsigned char);
        _stringValue = @"unsigned char";
    }
    else if ([self.encodeValue isEqualToString:@"S"]) {
        _typeSize = sizeof(unsigned short);
        _stringValue = @"unsigned short";
    }
    else if ([self.encodeValue isEqualToString:@"B"]) {
        _typeSize = sizeof(BOOL);
        _stringValue = @"BOOL";
    }
}
@end

@interface GePropertyAttribute: NSObject

@property (nonatomic, readonly, class) GePropertyAttribute * atomic;

@property (nonatomic, readonly, class) GePropertyAttribute * nonatomic;

@property (nonatomic, readonly, class) GePropertyAttribute * strongOrRetain;

@property (nonatomic, readonly, class) GePropertyAttribute * weak;

@property (nonatomic, readonly, class) GePropertyAttribute * assign;

@property (nonatomic, readonly, class) GePropertyAttribute * readonly;

@property (nonatomic, readonly, class) GePropertyAttribute * readWrite;

@property (nonatomic, readonly, class) GePropertyAttribute * g_copy;

@property (nonatomic, assign, readonly) NSInteger rawValue;
@end

@interface GeCComplexValueType: GePropertyType

@property (nonatomic, strong, readonly) NSSet<GeCBasicValueType *> * g_types;

@end

@implementation GeCComplexValueType {
    NSString * _typeName;
    GePropertyTypeSize _typeSize;
}

- (instancetype)initWithEncodeValue:(const char *)encodeValue {
    if (strlen(encodeValue) == 0) return nil;
    
    self = [super initWithEncodeValue:encodeValue];
    if (!self) return nil;
    [self p_decode];
    return self;
}

- (void)p_decode {
    
    NSString * encodeString = self.encodeValue;

    NSScanner * scanner = [NSScanner scannerWithString:encodeString];

    NSString * scanResult = nil;
    if ([scanner scanString:@"=" intoString:&scanResult]) {
        _typeName = scanResult.copy;
    }
    if ([scanner scanString:@"}" intoString:&scanResult]) {
        /// 结构体
        _typeName = [NSString stringWithFormat:@"struct %@", _typeName];
    }
}
@end


@implementation GePropertyAttribute

- (instancetype)initWithRawValue: (NSInteger)rawValue {
    
    self = [super init];
    if (!self) return nil;
    
    _rawValue = rawValue;
    return self;
}

+ (GePropertyAttribute *)atomic {
    static GePropertyAttribute * _atomic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _atomic = [[GePropertyAttribute alloc] initWithRawValue:0];
    });
    return _atomic;
}

+ (GePropertyAttribute *)nonatomic {
    static GePropertyAttribute * _nonatomic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nonatomic = [[GePropertyAttribute alloc] initWithRawValue:1];
    });
    return _nonatomic;
}

+ (GePropertyAttribute *)strongOrRetain {
    static GePropertyAttribute * _strongOrRetain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _strongOrRetain = [[GePropertyAttribute alloc] initWithRawValue:2];
    });
    return _strongOrRetain;
}

+ (GePropertyAttribute *)weak {
    static GePropertyAttribute * _weak = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _weak = [[GePropertyAttribute alloc] initWithRawValue:3];
    });
    return _weak;
}

+ (GePropertyAttribute *)assign {
    static GePropertyAttribute * _assign = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _assign = [[GePropertyAttribute alloc] initWithRawValue:4];
    });
    return _assign;
}

+ (GePropertyAttribute *)readonly {
    static GePropertyAttribute * _readonly = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _readonly = [[GePropertyAttribute alloc] initWithRawValue:5];
    });
    return _readonly;
}

+ (GePropertyAttribute *)readWrite {
    static GePropertyAttribute * _readWrite = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _readWrite = [[GePropertyAttribute alloc] initWithRawValue:6];
    });
    return _readWrite;
}

+ (GePropertyAttribute *)g_copy {
    static GePropertyAttribute * _copy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _copy = [[GePropertyAttribute alloc] initWithRawValue:7];
    });
    return _copy;
}
@end

@interface GeProperty: NSObject

@property (nonatomic, assign, readonly) BOOL  isRequired;

@property (nonatomic, assign, readonly) BOOL isInstance;

@property (nonatomic, strong, readonly) NSString * name;

- (instancetype)initWithProperty: (objc_property_t)property  isRequired: (BOOL)isRequired isInstance: (BOOL)isInstance;
@end

@implementation GeProperty
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
