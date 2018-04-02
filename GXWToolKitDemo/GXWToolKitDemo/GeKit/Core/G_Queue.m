//
//  G_Queue.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/2.
//  Copyright © 2018年 My. All rights reserved.
//

#import "G_Queue.h"

@implementation GeQueue 

+ (GeQueue *)main {
    static GeQueue * _main;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _main = [[GeQueue alloc] initWithQueue:dispatch_get_main_queue()];
    });
    return _main;
}

+ (GeQueue *)globe {
    static GeQueue * _globe;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _globe = [[GeQueue alloc] initWithQueue:dispatch_get_global_queue(0, 0)];
    });
    return _globe;
}

+ (instancetype)serialQueueWithLabel:(NSString *)label {
    return [[self alloc] initSerialQueueWithLabel:label];
}

+ (instancetype)concurrentQueueWithLabel:(NSString *)label {
    return [[self alloc] initConcurrentQueueWithLabel:label];
}

- (instancetype) initWithQueue: (dispatch_queue_t)queue {
    self = [super init];
    if (!self) return nil;
    
    _queue = queue;
    return self;
}

- (instancetype)initSerialQueueWithLabel:(NSString *)label {
    dispatch_queue_t queue = dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_SERIAL);
    return [self initWithQueue:queue];
}

- (instancetype)initConcurrentQueueWithLabel:(NSString *)label {
    dispatch_queue_t queue = dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_CONCURRENT);
    return [self initWithQueue:queue];
}

- (instancetype)init {
    return nil;
}

- (void)async:(void (^)(void))block {
    dispatch_async(_queue, block);
}

- (void)sync:(void (^)(void))block {
    NSAssert(_queue != dispatch_get_main_queue(), @"can not sync in main queue");
    dispatch_sync(_queue, block);
}

- (void)asyncAfterWithDelay:(NSTimeInterval)delay execute:(void (^)(void))block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), _queue, block);
}

@end
