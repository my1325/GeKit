//
//  WeakProxy.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeWeakProxy : NSProxy

/**
 弱代理，针对NSTimer和CADisplayLink

 @param target target
 @return GeWeakProxy
 */
+ (instancetype) g_proxyWithTarget: (id)target;

@end
