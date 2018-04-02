//
//  G_Group.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/2.
//  Copyright © 2018年 My. All rights reserved.
//

#import "G_Group.h"

@implementation GeGroup

+ (instancetype)group {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _group = dispatch_group_create();
    return self;
}

- (void)enter {
    dispatch_group_enter(_group);
}

- (void)leave {
    dispatch_group_leave(_group);
}

- (void)wait {
    [self waitUntilDate:[NSDate distantFuture]];
}

- (void)waitUntilDate:(NSDate *)date {
    [self waitSeconds:[date timeIntervalSinceNow]];
}

- (void)waitSeconds:(NSTimeInterval)seconds {
    dispatch_group_wait(_group, dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC));
}
@end

@implementation GeQueue (Ge_Group)

- (void)asyncInGroup:(GeGroup *)group execute:(void (^)(void))block {
    dispatch_group_async(group.group, self.queue, block);
}

- (void)notifyWithGroup:(GeGroup *)group execute:(void (^)(void))block {
    dispatch_group_notify(group.group, self.queue, block);
}
@end
