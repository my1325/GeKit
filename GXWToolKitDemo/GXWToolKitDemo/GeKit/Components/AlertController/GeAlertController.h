//
//  GeAlertController.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/29.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeAction: NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 action

 @param title 富文本
 @param handler handler
 @return GeAction
 */
+ (instancetype)actionWithTitle: (NSAttributedString *)title handler: (void(^)(void))handler;

@end

@interface GeAlertController : UIViewController

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/**
 alertControllerWithTitle

 @param title 富文本
 @param message 富文本
 @param preferredStyle UIAlertControllerStyle
 @return GeAlertController
 */
+ (instancetype)alertControllerWithTitle: (NSAttributedString *)title
                                 message:(NSAttributedString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle;

/**
 alertControllerWithCustomView,  此方法不会需要添加action，
 需要自己手动处理该CustomView的事件

 @param customView UIView
 @param preferredStyle UIAlertControllerStyle
 @return GeAlertController
 */
+ (instancetype)alertControllerWithCustomView: (UIView *)customView
                               preferredStyle:(UIAlertControllerStyle)preferredStyle;

#pragma mark -- 以下方法在用+alertControllerWithCustomView:preferredStyle:初始化时无效
/**
 该方法不支持UIAlertControllerStyleActionSheet,为UIAlertControllerStyleActionSheet时无效

 @param configurationHandler UITextField
 */
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

/**
 添加action

 @param action GeAction
 */
- (void)addAction: (GeAction *)action;

/**
 添加actions

 @param actions GeAction
 */
- (void)addActions: (NSArray<GeAction *> *)actions;

/**
 移除所有action
 */
- (void)removeAllActions;
@end
