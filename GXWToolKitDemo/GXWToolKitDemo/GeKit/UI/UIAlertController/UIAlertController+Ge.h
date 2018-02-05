//
//  UIAlertController+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^G_AlertAction)(NSInteger);
typedef void(^G_EmptyAction)(void);

@interface UIAlertController (Ge)

- (instancetype) g_cancelWithTitle: (NSString *) title action: (G_EmptyAction) actionHanlder;

- (instancetype) g_destructiveWithTitle: (NSString *) title action: (G_EmptyAction) actionHandler;

- (instancetype) g_others: (NSArray<NSString *> *) titles action: (G_AlertAction) actionHanlder;

- (void) g_showInViewController: (UIViewController *)viewController;

- (void) g_show;
@end
