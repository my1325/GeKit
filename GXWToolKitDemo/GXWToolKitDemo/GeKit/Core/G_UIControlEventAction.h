//
//  G_UIControlEventAction.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/2/6.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GeUIControlEventActionHandler)(id, UIControlEvents event);
/**
 UIControl 的回调托管target
 */
@interface GeUIControlEventAction : NSObject

/**
 添加一个block事件

 @param handler GeUIControlEventActionHandler
 @param event UIControlEvents
 @return GeUIControlEventAction
 */
+ (instancetype)addAction:(GeUIControlEventActionHandler)handler forEvent: (UIControlEvents)event;

/**
 绑定control

 @param control UIControl
 @param key 关联的key对象
 */
- (void)associateToControl:(UIControl *)control forKey: (void *)key;
@end
