//
//  UIButton+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GeCountDelegate<NSObject>
/**
 计时回调

 @param button button
 @param count 时间(单位秒)
 */
- (void) g_button: (UIButton *)button didCount: (NSInteger) count;
@end

@interface UIButton (Ge)
/**
 开始计时
 */
- (void) g_startCount;
/**
 暂停计时
 */
- (void) g_stopCount;
/**
 添加代理
 @param countDelegate GeCountDelegate
 */
- (void) g_addCountDelegate: (id<GeCountDelegate>) countDelegate;
/**
 重置
 */
- (void) g_resetCount;

/**
 block for touchUpInsideEvent

 @param handler GeUIControlEventActionHandler
 */
- (void) g_touchUpInsideAction: (void(^)(UIButton * button))handler;
@end
