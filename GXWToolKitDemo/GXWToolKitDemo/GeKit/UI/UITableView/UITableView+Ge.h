//
//  UITableView+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Ge)

- (void) g_setFooterNil;

- (CGFloat)g_heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)g_removeHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)g_removeAllHeights;

@end
