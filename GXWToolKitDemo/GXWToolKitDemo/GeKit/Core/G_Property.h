//
//  G_Property.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/2/22.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

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

/**
 unkonw property type
 */
@property (nonatomic, readonly, class) GePropertyType * g_unkonw;

/**
 property type value
 */
@property (nonatomic, readonly, strong) NSString * stringValue;

/**
 property encode value
 */
@property (nonatomic, readonly, strong) NSString * encodeValue;

/**
 property type size
 */
@property (nonatomic, readonly, assign) GePropertyTypeSize size;

/**
 factory init method

 @param encodeValue encodeValue
 @return GeOCPropertyValueType or GeCBasicValueType
 */
+ (instancetype)propertyTypeWithEncodeValue: (const char *)encodeValue;

/**
 init method, child class rewrite it

 @param encodeValue encodeValue
 @return GePropertyType
 */
- (instancetype)initWithEncodeValue: (const char *)encodeValue;
@end

@interface GeOCPropertyValueType: GePropertyType

/**
 comfirm protocols
 */
@property (nonatomic, strong, readonly) NSSet * protocols;

/**
 block type
 */
@property (nonatomic, readonly, class) GeOCPropertyValueType * block;

/**
 init method, if can not transform to objective-C object, it will return nil

 @param endcodeValue GeOCPropertyValueType
 */
+ (instancetype)objectiveCValueWithEncode: (const char *)endcodeValue;
@end

@interface GeCBasicValueType: GePropertyType

/**
 char
 */
@property (nonatomic, readonly, class) GeCBasicValueType * g_char;
/**
 unsigned char
 */
@property (nonatomic, readonly, class) GeCBasicValueType * g_unsigned_char;

/**
 int
 */
@property (nonatomic, readonly, class) GeCBasicValueType * g_int;

/**
 unsigned int
 */
@property (nonatomic, readonly, class) GeCBasicValueType * g_unsigned_int;

/**
 short
 */
@property (nonatomic, readonly, class) GeCBasicValueType * g_short;

/**
 unsigned short
 */
@property (nonatomic, readonly, class) GeCBasicValueType * g_unsigned_short;

/**
 long or long long
 */
@property (nonatomic, readonly, class) GeCBasicValueType * g_integer; /// long, long long

/**
 unsigned long or unsigned long long
 */
@property (nonatomic, readonly, class) GeCBasicValueType * g_unsigned_integer; // unsigned long, unsigned long long

/**
 float
 */
@property (nonatomic, readonly, class) GeCBasicValueType * g_float;

/**
 double
 */
@property (nonatomic, readonly, class) GeCBasicValueType * g_double;

/**
 bool
 */
@property (nonatomic, readonly, class) GeCBasicValueType * g_bool;

/**
 start init method

 @param encodeValue encodeValue
 @return GeCBasicValueType
 */
+ (instancetype)basicValueTypeForEncodeValue: (const char *)encodeValue;
@end

@interface GePropertyAttribute: NSObject

/**
 atomic
 */
@property (nonatomic, readonly, class) GePropertyAttribute * atomic;

/**
 nonatomic
 */
@property (nonatomic, readonly, class) GePropertyAttribute * nonatomic;

/**
 strongOrRetain
 */
@property (nonatomic, readonly, class) GePropertyAttribute * strongOrRetain;

/**
 weak
 */
@property (nonatomic, readonly, class) GePropertyAttribute * weak;

/**
 assign
 */
@property (nonatomic, readonly, class) GePropertyAttribute * assign;

/**
 readonly
 */
@property (nonatomic, readonly, class) GePropertyAttribute * readonly;

/**
 readWrite
 */
@property (nonatomic, readonly, class) GePropertyAttribute * readWrite;

/**
 copy
 */
@property (nonatomic, readonly, class) GePropertyAttribute * g_copy;

/**
 unique value
 */
@property (nonatomic, assign, readonly) NSInteger rawValue;
@end

@interface GeProperty: NSObject

/**
 isRequired
 */
@property (nonatomic, assign, readonly) BOOL  isRequired;

/**
 isInstance
 */
@property (nonatomic, assign, readonly) BOOL isInstance;

/**
 property name
 */
@property (nonatomic, strong, readonly) NSString * name;

/**
 attributes ---- GePropertyAttribute
 */
@property (nonatomic, strong, readonly) NSSet<GePropertyAttribute *> * attributes;

/**
 type ---- GePropertyType
 */
@property (nonatomic, strong, readonly) GePropertyType * type;

/**
 init method

 @param property objc_property_t
 @param isRequired isRequired
 @param isInstance isInstance
 @return GeProperty
 */
- (instancetype)initWithProperty: (objc_property_t)property
                      isRequired: (BOOL)isRequired
                      isInstance: (BOOL)isInstance;
@end
