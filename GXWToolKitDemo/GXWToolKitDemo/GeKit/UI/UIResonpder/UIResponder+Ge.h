//
//  UIResponder+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Ge)

/**
 路由事件

 @param actioName 事件名称
 @param userInfo 事件带的参数
 */
- (void) g_routerActionNamed: (NSString *)actioName userInfo: (id)userInfo;

@end
