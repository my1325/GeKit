//
//  LoadingAnimateView.m
//  YiYou
//
//  Created by m y on 2018/1/19.
//  Copyright © 2018年 m y. All rights reserved.
//

#import "G_LoadingAnimateView.h"

@implementation GeLoadingAnimateView

- (void)startInView:(UIView *)superView {
    
    [super startInView:superView];
    
    [self p_addAnimationToStokeStart];
    [self p_addAnimationToStokeEnd];
}

- (void)stop {
    
    [super stop];
    [self.animateLayer removeAllAnimations];
}

- (void)p_addAnimationToStokeStart {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    animation.values = @[@(0.0), @(0.1), @(0.15), @(0.75), @(1.0)];
    animation.keyTimes = @[@(0.0), @(0.25), @(0.5), @(0.75), @(1.0)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 1.25;
    animation.repeatCount = MAXFLOAT;
    
    [self.animateLayer addAnimation:animation forKey:@"startAnimation"];
}

- (void)p_addAnimationToStokeEnd {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    animation.values = @[@(0.0), @(0.4), @(0.9), @(0.95), @(1.0)];
    animation.keyTimes = @[@(0.0), @(0.25), @(0.5), @(0.75), @(1.0)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 1.25;
    animation.repeatCount = MAXFLOAT;
    
    [self.animateLayer addAnimation:animation forKey:@"endAnimation"];
}
@end
