//
//  UIButton+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "UIButton+Ge.h"
#import "WeakProxy.h"
#import <objc/runtime.h>

@implementation UIButton (Ge)

static int timerCount;
static int timerR;
static int delegateR;

- (NSInteger) ge_timerCount {
    
    return [objc_getAssociatedObject(self, &timerCount) integerValue];
}

- (void) ge_setTimerCount: (NSInteger)geTimerCount {
    
    objc_setAssociatedObject(self, &timerCount, @(geTimerCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *) ge_timer {
    
    NSTimer * timer = objc_getAssociatedObject(self, &timerR);
    
    if (!timer) {
        
        timer = [NSTimer timerWithTimeInterval:1 target:[GeWeakProxy g_proxyWithTarget:self] selector:@selector(ge_handleTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        objc_setAssociatedObject(self, &timerR, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return timer;
}

- (void) ge_handleTimer: (NSTimer *) timer {
    
    NSInteger count = [self ge_timerCount];
    count ++;
    [self ge_setTimerCount:count];
    
    if ([[self ge_countDelegate] respondsToSelector:@selector(g_button:didCount:)]) {
        
        [[self ge_countDelegate] g_button:self didCount:count];
    }
}

- (void) g_addCountDelegate:(id<GeCountDelegate>)countDelegate {
    
    objc_setAssociatedObject(self, &delegateR, countDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<GeCountDelegate>) ge_countDelegate {
    
    return objc_getAssociatedObject(self, &delegateR);
}

- (void) g_startCount {
    
    [[self ge_timer] setFireDate:[NSDate distantPast]];
}

- (void) g_stopCount {
    
    [[self ge_timer] setFireDate:[NSDate distantFuture]];
}

- (void) g_resetCount {
    
    [self ge_setTimerCount:0];
    [[self ge_timer] invalidate];
    objc_setAssociatedObject(self, &delegateR, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
