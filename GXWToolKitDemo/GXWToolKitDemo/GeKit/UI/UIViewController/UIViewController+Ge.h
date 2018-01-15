//
//  UIViewController+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Ge)<UIGestureRecognizerDelegate>

- (void)g_hideShadow;

- (void)g_showShadow;

- (void)g_enablePopGestureRecognizer;

- (void)g_disablePopGestureRecognizer;

@end
