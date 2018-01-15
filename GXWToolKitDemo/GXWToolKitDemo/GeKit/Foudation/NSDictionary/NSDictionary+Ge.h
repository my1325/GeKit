//
//  NSDictionary+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@interface NSDictionary (Ge)

G_ReadonlyProperty(strong) NSString * g_jsonString;

G_ReadonlyProperty(strong) NSData * g_jsonData;

@end
