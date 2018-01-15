//
//  UIButton+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GeCountDelegate<NSObject>

- (void) g_button: (UIButton *)button didCount: (NSInteger) count;
@end

@interface UIButton (Ge)

- (void) g_startCount;

- (void) g_stopCount;

- (void) g_addCountDelegate: (id<GeCountDelegate>) countDelegate;

- (void) g_resetCount;
@end
