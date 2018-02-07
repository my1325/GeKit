//
//  G_DelegateProxy.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/2/6.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^GeProtocolProxyHandler)(id sender, SEL sel, ...);

/**
 使用block替换代理
 */
@interface GeProtocolProxy : NSObject
/**
 协议
 */
@property(nonatomic, strong) Protocol * protocol;
/**
 使用block替换代理

 @param protocol Protocol
 @return GeDelegateProxy
 */
+ (instancetype)delegateProxyWithProtocol: (Protocol *)protocol;

/*
使用block替换代理

@param action GeDelegateProxyHandler
@param selector SEL
@param protocol Protocol
@return GeDelegateProxy
*/
- (void)addAction: (GeProtocolProxyHandler)action replaceSelector: (SEL)selector;

/**
 关联到对象，使此对象不被释放掉

 @param objcect objcect
 @param key 关联的key对象
 */
- (void)associateToObject: (id)objcect forKey: (void *)key;
@end
