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

/**
 cancel

 @param title cancel title
 @param actionHanlder handler
 @return self
 */
- (instancetype) g_cancelWithTitle: (NSString *) title action: (G_EmptyAction) actionHanlder;

/**
 destructive

 @param title destructive title
 @param actionHandler handler
 @return self
 */
- (instancetype) g_destructiveWithTitle: (NSString *) title action: (G_EmptyAction) actionHandler;

/**
 normal

 @param titles normalTitles
 @param actionHanlder handler
 @return self
 */
- (instancetype) g_others: (NSArray<NSString *> *) titles action: (G_AlertAction) actionHanlder;

/**
 show in UIViewController

 @param viewController custom UIViewController
 */
- (void) g_showInViewController: (UIViewController *)viewController;

/**
 show in GeAlertWindow
 */
- (void) g_show;
@end
