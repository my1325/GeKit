//
//  G_Semphore.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/2.
//  Copyright © 2018年 My. All rights reserved.
//

#import "G_Semphore.h"

@implementation GeSemphore 

+ (instancetype)semphore {
    return [GeSemphore semphoreWithTotal:0];
}

+ (instancetype)semphoreWithTotal:(NSInteger)total {
    return [[self alloc] initWithTotal:total];
}

- (instancetype)initWithTotal:(NSInteger)total {
    self = [super init];
    if (!self) return nil;
    
    _total = total;
    _semaphore = dispatch_semaphore_create(total);
    return self;
}

- (void)signal {
    dispatch_semaphore_signal(_semaphore);
}

- (void)wait {
    [self waitUntilDate:[NSDate distantFuture]];
}

- (void)waitUntilDate:(NSDate *)date {
    [self waitSeconds:[date timeIntervalSinceNow]];
}

- (void)waitSeconds:(NSTimeInterval)seconds {
    dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC));
}
@end

@implementation GeSemphore (Ge_Lock)

- (void)lock:(void (^)(void))block {
    if (!block) return;
    [self wait];
    block();
    [self signal];
}

+ (void)locakCode:(void (^)(void))block {
    static GeSemphore * _defaultSemphore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultSemphore = [GeSemphore semphoreWithTotal:1];
    });
    
    [_defaultSemphore lock:block];
}
@end
