//
//  G_Protocol.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/2/22.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "G_Property.h"

@interface GeMethodDescription: NSObject

/**
 protocol methodDescription's selector name
 */
@property(nonatomic, strong, readonly) NSString * name;

/**
 protocol methodDescription's arguments types
 */
@property(nonatomic, strong, readonly) NSString * types;

/**
 isRequired
 */
@property(nonatomic, assign, readonly) BOOL isRequired;

/**
 isInstance
 */
@property(nonatomic, assign, readonly) BOOL isInstance;

/**
 init method

 @param descrition struct objc_method_description
 @param isRequired isRequired
 @param isInstance isInstance
 @return GeMethodDescription
 */
- (instancetype)initWithMethodDescription: (struct objc_method_description)descrition
                               isRequired: (BOOL)isRequired
                               isInstance: (BOOL)isInstance;
@end

@interface GeProtocol: NSObject

/**
 protocol
 */
@property (nonatomic, strong, readonly) Protocol * protocol;

/**
 protocol name
 */
@property (nonatomic, strong, readonly) NSString * name;

/**
 protocol contain properties
 */
@property (nonatomic, strong, readonly) NSArray<GeProperty *> * properties;

/**
 protocol contain methodDescription
 */
@property (nonatomic, strong, readonly) NSArray<GeMethodDescription *> * methodDescriptions;

/**
 convience init method, this method will cache it

 @param protocol protocol
 @return GeProtocol
 */
+ (instancetype)protocolWithProtocol: (Protocol *)protocol;

/**
 init method, this method do not cache it

 @param protocol protocol
 @return GeProtocol
 */
- (instancetype)initWithProtocol: (Protocol *)protocol;

/**
 get protocol methodDescription for selector

 @param selector selector
 @return GeMethodDescription
 */
- (GeMethodDescription *)descriptionForSelector: (SEL)selector;
@end

