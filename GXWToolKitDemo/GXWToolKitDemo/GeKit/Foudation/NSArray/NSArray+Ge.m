//
//  NSArray+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "NSArray+Ge.h"

@implementation NSArray (Ge)

- (NSData *)g_jsonData {
    
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)g_jsonString {
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSArray *)g_map:(id (^)(id))handler {
    
    NSMutableArray * result = @[].mutableCopy;
    
    for (id obj in self) [result addObject:handler(obj)];
    
    return result.copy;
}

- (NSArray *)g_filter:(BOOL (^)(id))handler {
    
    NSMutableArray * result = @[].mutableCopy;
    
    for (id obj in self) if (handler(obj)) [result addObject:obj];

    return result.copy;
}

- (NSArray *)g_reverse {
    
    NSMutableArray * array = self.mutableCopy;
    
    NSUInteger midIndex = floor(array.count / 2.0);
    for (NSInteger index = 0; index < midIndex; index ++) {
        [array exchangeObjectAtIndex:index withObjectAtIndex:array.count - index - 1];
    }
    
    return array;
}
@end
