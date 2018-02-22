//
//  G_Property.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/2/22.
//  Copyright © 2018年 My. All rights reserved.
//

#import "G_Property.h"

@implementation GePropertyType
+ (instancetype)propertyTypeWithEncodeValue:(const char *)encodeValue {
    
    //    static CFMutableDictionaryRef _propertyDict;
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        _propertyDict = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    //    });
    //
    GePropertyType * _propertyType = nil;
    if (!_propertyType) {
        _propertyType = [GeCBasicValueType basicValueTypeForEncodeValue:encodeValue];
    }
    if (!_propertyType) {
        _propertyType = [GeOCPropertyValueType objectiveCValueWithEncode:encodeValue];
    }
    if (!_propertyType) {
        _propertyType = GePropertyType.g_unkonw;
    }
    
    //    if (_propertyType) {
    //        CFDictionaryAddValue(_propertyDict, encodeValue, (__bridge const void *)(_propertyType));
    //    }
    
    return _propertyType;
}

+ (GePropertyType *)g_unkonw {
    static GePropertyType * _unkonw = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _unkonw = [[GePropertyType alloc] initWithEncodeValue:"??????"];
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

@implementation GeOCPropertyValueType {
    
    GePropertyTypeSize _typeSize;
    NSString * _stringValue;
}

+ (instancetype)objectiveCValueWithEncode:(const char *)endcodeValue {
    
    if (strcmp(endcodeValue, "@?") == 0) return GeOCPropertyValueType.block;
    else return [[GeOCPropertyValueType alloc] initWithEncodeValue:endcodeValue];
}

+ (GeOCPropertyValueType *)block {
    static GeOCPropertyValueType * _block = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _block = [[GeOCPropertyValueType alloc] initWithEncodeValue:"@?"];
    });
    return _block;
}

- (instancetype)initWithEncodeValue:(const char *)encodeValue {
    
    self = [super initWithEncodeValue:encodeValue];
    if (!self) return nil;
    
    if (![self p_decode]) return nil;
    return self;
}

- (NSString *)stringValue {
    return _stringValue;
}

- (GePropertyTypeSize)size {
    return _typeSize;
}

- (BOOL)p_decode {
    
    NSString * typeEncoding = self.encodeValue;
    
    if ([typeEncoding isEqualToString:@"@?"]) {
        _typeSize = 8;
        _stringValue = @"block";
        return YES;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:typeEncoding];
    if (![scanner scanString:@"@\"" intoString:NULL]) return NO;
    
    NSString *clsName = nil;
    if ([scanner scanUpToCharactersFromSet: [NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&clsName]) {
        if (clsName.length) {
            _stringValue = clsName.copy;
            _typeSize = class_getInstanceSize(NSClassFromString(clsName));
        }
    }
    
    NSMutableSet *protocols = nil;
    while ([scanner scanString:@"<" intoString:NULL]) {
        NSString* protocol = nil;
        if ([scanner scanUpToString:@">" intoString: &protocol]) {
            if (protocol.length) {
                if (!protocols) protocols = [NSMutableSet new];
                [protocols addObject:protocol];
            }
        }
        [scanner scanString:@">" intoString:NULL];
    }
    _protocols = protocols.copy;
    return YES;
}

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

@implementation GeProperty
- (instancetype)initWithProperty:(objc_property_t)property isRequired:(BOOL)isRequired isInstance:(BOOL)isInstance {
    
    NSAssert(property != NULL, @"property can not be null");
    
    self = [super init];
    if (!self) return nil;
    _isRequired = isRequired;
    _isInstance = isInstance;
    [self importProperty:property];
    return self;
}

- (void)importProperty: (objc_property_t)property {
    
    _name = [NSString stringWithUTF8String:property_getName(property)];
    
    NSMutableSet * _attributesSet = [[NSMutableSet alloc] init];
    
    GePropertyAttribute * _isAtomic = GePropertyAttribute.atomic;
    GePropertyAttribute * _isReadWrite = GePropertyAttribute.readWrite;
    GePropertyAttribute * _isAssign = GePropertyAttribute.assign;
    unsigned int outCount = 0;
    objc_property_attribute_t * attributes = property_copyAttributeList(property, &outCount);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        objc_property_attribute_t attribute = attributes[index];
        //        type          T
        //        nonatomic    N
        //        readonly      R
        //        copy           C
        //        strong/retain    &
        //        weak           W
        switch (attribute.name[0]) {
            case 'T':
                _type = [GePropertyType propertyTypeWithEncodeValue:attribute.value];
                break;
            case 'N':
                _isAtomic = GePropertyAttribute.nonatomic;
            case 'R':
                _isReadWrite = GePropertyAttribute.readonly;
            case 'C':
                _isAssign = GePropertyAttribute.g_copy;
            case '&':
                _isAssign = GePropertyAttribute.strongOrRetain;
            case 'W':
                _isAssign = GePropertyAttribute.weak;
            default:
                break;
        }
    }
    [_attributesSet addObject:_isAssign];
    [_attributesSet addObject:_isReadWrite];
    [_attributesSet addObject:_isAtomic];
    
    _attributes = _attributesSet.copy;
}
@end
