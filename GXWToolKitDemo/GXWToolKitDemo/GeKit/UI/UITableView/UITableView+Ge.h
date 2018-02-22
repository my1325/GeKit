//
//  UITableView+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Ge)
/**
 setFooterNil
 */
- (void) g_setFooterNil;

/**
 produce tableView Cell Height at IndexPath

 @param indexPath IndexPath
 @return height
 */
- (CGFloat)g_heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 remove tableView Cell Height at IndexPath

 @param indexPath indexPath
 */
- (void)g_removeHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 remove all cache heights
 */
- (void)g_removeAllHeights;

@end
