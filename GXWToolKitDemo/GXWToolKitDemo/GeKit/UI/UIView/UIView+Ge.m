//
//  UIView+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "UIView+Ge.h"

@implementation UIView (Ge)
- (UIImage *)g_takeSnapShot {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage * shotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return shotImage;
}

- (UIImage *)g_snapshotAfterScreenUpdates:(BOOL)update {
    
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self g_takeSnapShot];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:update];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (void)g_addConstraintForWidth:(CGFloat)Width
{
    NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:Width];
    [self addConstraint:constraint];
}

- (void)g_addConstraintForHeight:(CGFloat)Height
{
    NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:Height];
    [self addConstraint:constraint];
}

- (void)g_addConstraintInSuper:(NSLayoutAttribute)LayoutAttribute Constant:(CGFloat)Constant
{
    NSParameterAssert(self.superview);
    
    NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:self
                                                                   attribute:LayoutAttribute
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:LayoutAttribute
                                                                  multiplier:1.0
                                                                    constant:Constant];
    [self.superview addConstraint:constraint];
}

- (void)g_updateConstraintForWidth:(CGFloat)Width
{
    for (NSLayoutConstraint * constraint in self.constraints)
    {
        if (constraint.firstAttribute == NSLayoutAttributeWidth && constraint.firstItem == self)
        {
            constraint.constant = Width;
            break;
        }
    }
}

- (void)g_updateConstraintForHeight:(CGFloat)Height
{
    for (NSLayoutConstraint * constraint in self.constraints)
    {
        if (constraint.firstAttribute == NSLayoutAttributeHeight && constraint.firstItem == self)
        {
            constraint.constant = Height;
            break;
        }
    }
}

- (void)g_updateConstraintInSuper:(NSLayoutAttribute)LayoutAttribute Constant:(CGFloat)Constant
{
    for (NSLayoutConstraint * constraint in self.superview.constraints)
    {
        if ((constraint.firstAttribute == LayoutAttribute && constraint.firstItem == self) ||
            (constraint.firstAttribute == LayoutAttribute && constraint.secondItem == self))
        {
            constraint.constant = Constant;
            break;
        }
    }
}

- (void)g_animateWithAlpha:(CGFloat)alpha withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        self.alpha = alpha;
    }];
}

- (void)g_animateWithFrame:(CGRect)targetFrame withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        self.frame = targetFrame;
    }];
}

- (void)g_animateWithBounds:(CGRect)targetBounds withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        self.bounds = targetBounds;
    }];
}

- (void)g_animateWithTransform:(CGAffineTransform)transform withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        self.transform = transform;
    }];
}

- (void)g_animateWithVisualEffect:(UIVisualEffect *)effect withDuration:(NSTimeInterval)duration {
    
    if (![self isKindOfClass:[UIVisualEffectView class]]) return;
    
    [UIView animateWithDuration:duration animations:^{
      
        [(UIVisualEffectView *)self setEffect:effect];
    }];
}

- (CGFloat)g_left {
    
    return self.frame.origin.x;
}

- (CGFloat)g_right {
    
    return self.frame.origin.x + self.bounds.size.width;
}

- (CGFloat)g_top {
    
    return self.frame.origin.y;
}

- (CGFloat)g_bottom {
    
    return self.frame.origin.y + self.bounds.size.height;
}

- (CGFloat)g_height {
    
    return self.bounds.size.height;
}

- (CGFloat)g_width {
    
    return self.bounds.size.width;
}

- (void)g_removeAllSubviews {
    for (UIView * subview in self.subviews) [subview removeFromSuperview];
}
@end
