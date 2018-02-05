//
//  UIView+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Ge)

@property(nonatomic, assign, readonly) CGFloat g_left;

@property(nonatomic, assign, readonly) CGFloat g_right;

@property(nonatomic, assign, readonly) CGFloat g_top;

@property(nonatomic, assign, readonly) CGFloat g_bottom;

@property(nonatomic, assign, readonly) CGFloat g_width;

@property(nonatomic, assign, readonly) CGFloat g_height;

- (UIImage *)g_takeSnapShot;

- (UIImage *)g_snapshotAfterScreenUpdates: (BOOL)update;

- (void)g_addConstraintInSuper:(NSLayoutAttribute)LayoutAttribute Constant:(CGFloat)Constant;

- (void)g_addConstraintForWidth:(CGFloat)Width;

- (void)g_addConstraintForHeight:(CGFloat)Height;

- (void)g_updateConstraintInSuper:(NSLayoutAttribute)LayoutAttribute Constant:(CGFloat)Constant;

- (void)g_updateConstraintForWidth:(CGFloat)Width;

- (void)g_updateConstraintForHeight:(CGFloat)Height;

- (void)g_animateWithFrame: (CGRect)targetFrame withDuration: (NSTimeInterval)duration;

- (void)g_animateWithBounds: (CGRect)targetBounds withDuration: (NSTimeInterval)duration;

- (void)g_animateWithTransform: (CGAffineTransform)transform withDuration: (NSTimeInterval)duration;

- (void)g_animateWithAlpha: (CGFloat)alpha withDuration: (NSTimeInterval)duration;

- (void)g_animateWithVisualEffect: (UIVisualEffect *)effect withDuration: (NSTimeInterval)druration;
@end