//
//  G_Queue.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/2.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeQueue : NSObject
/**
 main queue
 */
@property (nonatomic, readonly, class) GeQueue * main;

/**
 globe queu
 */
@property (nonatomic, readonly, class) GeQueue * globe;

/**
 queue
 */
@property (nonatomic, readonly, strong) dispatch_queue_t queue;

/**
 init serial queu with label

 @param label label
 @return GeQueue
 */
+ (instancetype) serialQueueWithLabel: (NSString *)label;

/**
  init concurrent queue with label

 @param label label
 @return GeQueue
 */
+ (instancetype) concurrentQueueWithLabel: (NSString *)label;

/**
 init serial queu with label

 @param label label
 @return GeQueue
 */
- (instancetype) initSerialQueueWithLabel: (NSString *)label;

/**
 init concurrent queue with label

 @param label label
 @return GeQueue
 */
- (instancetype) initConcurrentQueueWithLabel: (NSString *)label;

/**
 async execute

 @param block block
 */
- (void) async: (void(^)(void))block;

/**
 async after delay

 @param delay delay
 @param block block
 */
- (void) asyncAfterWithDelay: (NSTimeInterval)delay execute: (void(^)(void))block;

/**
 sync execute

 @param block block
 */
- (void) sync: (void(^)(void))block;
@end
