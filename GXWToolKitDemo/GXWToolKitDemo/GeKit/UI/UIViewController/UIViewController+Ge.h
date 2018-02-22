//
//  UIViewController+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Ge)<UIGestureRecognizerDelegate>

/**
 hide Navigation Bar Bottom Line
 */
- (void)g_hideShadow;

/**
 show Navigation Bar Bottom Line
 */
- (void)g_showShadow;

/**
 enable NavigationController dismiss GestureRecognizer
 */
- (void)g_enablePopGestureRecognizer;

/**
 disable NavigationController dismiss GestureRecognizer
 */
- (void)g_disablePopGestureRecognizer;

/**
 弹出相册

 @param completion (void(^)(UIImage *))
 */
- (void)g_presentPhotoLibraryEditable: (BOOL)editable completion: (void(^)(UIImage *))completion;

/**
 弹出相机

 @param completion (void(^)(UIImage *))
 */
- (void)g_presentCameraForImageEditable: (BOOL)editable completion: (void(^)(UIImage *))completion;

/**
 视频录制

 @param completion (void(^)(NSURL * mediaURL))
 */
- (void)g_presentCameraForVideoWithCompletion: (void(^)(NSURL * mediaURL))completion;
@end
