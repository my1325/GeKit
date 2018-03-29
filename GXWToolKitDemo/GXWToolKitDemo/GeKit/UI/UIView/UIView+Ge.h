//
//  UIView+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Ge)
/**
 view的最左边
 */
@property(nonatomic, assign, readonly) CGFloat g_left;
/**
 view的最右边
 */
@property(nonatomic, assign, readonly) CGFloat g_right;
/**
 view的最上边
 */
@property(nonatomic, assign, readonly) CGFloat g_top;
/**
 view的最下边
 */
@property(nonatomic, assign, readonly) CGFloat g_bottom;
/**
 宽度
 */
@property(nonatomic, assign, readonly) CGFloat g_width;
/**
 高度
 */
@property(nonatomic, assign, readonly) CGFloat g_height;
/**
 截图
 @return UIImage
 */
- (UIImage *)g_takeSnapShot;
/**
 截图

 @param update 是否更新当前视图
 @return UIImage
 */
- (UIImage *)g_snapshotAfterScreenUpdates: (BOOL)update;
/**
 添加约束

 @param LayoutAttribute NSLayoutAttribute
 @param Constant Constant
 */
- (void)g_addConstraintInSuper:(NSLayoutAttribute)LayoutAttribute Constant:(CGFloat)Constant;
/**
 添加约束
 
 @param Width 宽度
 */
- (void)g_addConstraintForWidth:(CGFloat)Width;
/**
 添加约束
 
 @param Height 高度
 */
- (void)g_addConstraintForHeight:(CGFloat)Height;
/**
 更新约束

 @param LayoutAttribute NSLayoutAttribute
 @param Constant Constant
 */
- (void)g_updateConstraintInSuper:(NSLayoutAttribute)LayoutAttribute Constant:(CGFloat)Constant;
/**
 更新约束
 
 @param Width 宽度
 */
- (void)g_updateConstraintForWidth:(CGFloat)Width;
/**
 更新约束
 
 @param Height 高度
 */
- (void)g_updateConstraintForHeight:(CGFloat)Height;

/**
 frame动画

 @param targetFrame targetFrame
 @param duration 动画时间
 */
- (void)g_animateWithFrame: (CGRect)targetFrame withDuration: (NSTimeInterval)duration;
/**
 bounds动画
 
 @param targetBounds targetBounds
 @param duration 动画时间
 */
- (void)g_animateWithBounds: (CGRect)targetBounds withDuration: (NSTimeInterval)duration;
/**
 transofrm动画

 @param transform CGAffineTransform
 @param duration 动画时间
 */
- (void)g_animateWithTransform: (CGAffineTransform)transform withDuration: (NSTimeInterval)duration;
/**
 alpa动画

 @param alpha CGFloat
 @param duration 动画时间
 */
- (void)g_animateWithAlpha: (CGFloat)alpha withDuration: (NSTimeInterval)duration;
/**
 UIVisualEffect 动画，当UIView 为UIVisualEffectView时有效

 @param effect UIVisualEffect
 @param druration 动画时间
 */
- (void)g_animateWithVisualEffect: (UIVisualEffect *)effect withDuration: (NSTimeInterval)druration;

/**
 移除所有子视图
 */
- (void)g_removeAllSubviews;
@end
