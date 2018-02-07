//
//  G_UIControlEventAction.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/2/6.
//  Copyright © 2018年 My. All rights reserved.
//

#import "G_UIControlEventAction.h"
#import <objc/runtime.h>

@implementation GeUIControlEventAction {
    GeUIControlEventActionHandler _handler;
    UIControlEvents _event;
}

+ (instancetype)addAction:(GeUIControlEventActionHandler)handler forEvent:(UIControlEvents)event {
    return [[self alloc] initWithAction: handler forEvent:event];
}

- (instancetype)initWithAction: (GeUIControlEventActionHandler)handler forEvent: (UIControlEvents)event {
    
    self = [super init];
    if (!self) return nil;
    
    _handler = [handler copy];
    _event = event;
    return self;
}

- (void)associateToControl:(UIControl *)control forKey: (void *)key {
    
    [control addTarget:self action:@selector(p_handleControlEvent:) forControlEvents:_event];
    objc_setAssociatedObject(control, key, self, OBJC_ASSOCIATION_RETAIN);
}

- (void)p_handleControlEvent: (id)sender {
    if (_handler) _handler(sender, _event);
}
@end
