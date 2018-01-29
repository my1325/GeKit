//
//  ProgressAnimateView.m
//  YiYou
//
//  Created by m y on 2018/1/19.
//  Copyright © 2018年 m y. All rights reserved.
//

#import "G_ProgressAnimateView.h"

@implementation GeProgressAnimateView

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    
    self.animateLayer.strokeEnd = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
}

@end
