//
//  G_Group.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/2.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "G_Queue.h"

@interface GeGroup : NSObject

/**
 group
 */
@property (nonatomic, readonly, strong) dispatch_group_t group;
/**
 init

 @return GeGroup
 */
+ (instancetype) group;

/**
 enter
 */
- (void) enter;

/**
 leave
 */
- (void) leave;

/**
 wait forever
 */
- (void) wait;

/**
 wait until to date

 @param date date
 */
- (void) waitUntilDate: (NSDate *)date;

/**
 wait seconds

 @param seconds seconds
 */
- (void) waitSeconds: (NSTimeInterval)seconds;
@end

@interface GeQueue (Ge_Group)

/**
 queue execute in group

 @param group group
 @param block block
 */
- (void) asyncInGroup: (GeGroup *)group execute: (void(^)(void))block;

/**
 notify

 @param group GeGroup
 @param block block
 */
- (void) notifyWithGroup: (GeGroup *)group execute: (void(^)(void))block;
@end
