//
//  AnimateView.m
//  YiYou
//
//  Created by m y on 2018/1/18.
//  Copyright © 2018年 m y. All rights reserved.
//

#import "G_AnimateView.h"
#import "UIView+Ge.h"

@implementation GeAnimateView {
    
    CAShapeLayer * _shapeLayer;
}

- (instancetype)init { return [self initWithFrame:CGRectZero]; }

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _animateSize = (CGSize){40, 40};
    _indicatorColor = [UIColor whiteColor];
    _animateBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.15];
    _indicatoryWidth = 4;
    
    _shapeLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_shapeLayer];
    self.backgroundColor = [UIColor clearColor];

    return self;
}

- (CAShapeLayer *)animateLayer {
    
    return _shapeLayer;
}

- (void)stop {
    
    _isAnimating = NO;
    [self g_animateWithAlpha:0.0 withDuration:0.25];
    if (_removeFromSuperViewWhenStopped) [self removeFromSuperview];
}

- (void)startInView:(UIView *)superView {
    
    _isAnimating = YES;
    
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        
        self.bounds = (CGRect){0, 0, _animateSize.width, _animateSize.height};
        self.center = (CGPoint){superView.g_width / 2.0, superView.g_height / 2.0};
    }
    
    [self p_prepareToStart];

    if ([self.superview isEqual:superView]) {}
    else if (self.superview) {
        
        [self removeFromSuperview];
        [superView addSubview:self];
    }
    else [superView addSubview:self];
    
    self.alpha = 0.0;
    [self g_animateWithAlpha:1.0 withDuration:0.25];
}

- (void)layoutSubviews {
    
    CGRect frame = _shapeLayer.frame;
    frame.origin.x = self.g_width * 0.5 - frame.size.width * 0.5;
    frame.origin.y = self.g_height * 0.5 - frame.size.height * 0.5;
    _shapeLayer.frame = frame;
}

- (void)p_prepareToStart {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset((CGRect){0, 0, _animateSize.width, _animateSize.height}, 7, 7) cornerRadius:(MIN(_animateSize.width, _animateSize.height) / 2 - 7)];
    _shapeLayer.path = path.CGPath;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.backgroundColor = _animateBackgroundColor.CGColor;
    _shapeLayer.strokeColor = _indicatorColor.CGColor;
    _shapeLayer.lineWidth = _indicatoryWidth;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.strokeStart = 0;
    _shapeLayer.strokeEnd = 0;
    _shapeLayer.bounds = (CGRect){0, 0, _animateSize.width, _animateSize.height};
    _shapeLayer.cornerRadius = MIN(_animateSize.width, _animateSize.height) / 2.0;
}
@end
