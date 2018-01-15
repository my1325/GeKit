//
//  UIViewController+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "UIViewController+Ge.h"

@implementation UIViewController (Ge)

- (void)g_hideShadow {
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)g_showShadow {
    
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)g_enablePopGestureRecognizer {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)g_disablePopGestureRecognizer {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}
@end
