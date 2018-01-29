//
//  SwiftEnum.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/29.
//  Copyright © 2018年 My. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@interface SwiftEnum : NSObject<NSFastEnumeration>

G_ReadonlyProperty(strong) id rawValue;

- (instancetype)initWithRawValue: (id)rawValue;
@end
