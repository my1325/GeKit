//
//  Defines.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

#define G_Property(nonatomic, strong, readwrite) @property(nonatomic, strong, readwrite)
#define G_WeakProperty @property (nonatomic, weak)
#define G_StrongProperty @property (nonatomic, strong)
#define G_AssignProperty @property (nonatomic, assign)
#define G_ReadonlyProperty(SEC) @property (nonatomic, readonly, SEC)

#define G_ClassProperty @property (nonatomic, class)
#define G_ClassReadonlyProperty @property (nonatomic, class, readonly)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef void (^G_EmptyAction)(void);
#endif /* Defines_h */
