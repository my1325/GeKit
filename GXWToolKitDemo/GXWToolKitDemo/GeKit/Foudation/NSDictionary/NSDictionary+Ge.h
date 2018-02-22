//
//  NSDictionary+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Ge)

/**
 json string
 */
@property(nonatomic, readonly) NSString * g_jsonString;

/**
 json Data
 */
@property(nonatomic, readonly) NSData * g_jsonData;

@end
