//
//  G_Semphore.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/2.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeSemphore : NSObject

/**
 semaphore
 */
@property (nonatomic, readonly, strong) dispatch_semaphore_t semaphore;

/**
 total
 */
@property (nonatomic, assign, readonly) NSInteger total;

/**
 total = 0

 @return GeSemphore
 */
+ (instancetype) semphore;

/**
 init with total

 @param total total
 @return GeSemphore
 */
+ (instancetype) semphoreWithTotal: (NSInteger)total;

/**
 init with total

 @param total total
 @return GeSemphore
 */
- (instancetype) initWithTotal: (NSInteger)total;

/**
 signal
 */
- (void) signal;

/**
 wait forever
 */
- (void) wait;

/**
 wait until date

 @param date date
 */
- (void) waitUntilDate: (NSDate *)date;

/**
 wait seconds

 @param seconds seconds
 */
- (void) waitSeconds: (NSTimeInterval)seconds;
@end

@interface GeSemphore (Ge_Lock)

/**
 lock the code in block

 @param block block
 */
- (void) lock: (void(^)(void))block;

/**
 lock the code use default semphore

 @param block block
 */
+ (void) locakCode: (void(^)(void))block;
@end
