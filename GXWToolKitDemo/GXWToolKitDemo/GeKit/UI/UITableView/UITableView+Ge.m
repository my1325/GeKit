//
//  UITableView+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "UITableView+Ge.h"
#import <objc/runtime.h>

@implementation UITableView (Ge)
static int heightsDict;

- (NSMutableDictionary *)ge_heightsDict {
    
    NSMutableDictionary * dict = objc_getAssociatedObject(self, &heightsDict);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &heightsDict, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

- (void)g_removeAllHeights {
    
    [[self ge_heightsDict] removeAllObjects];
}

- (CGFloat)g_heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber * height = [[self ge_heightsDict] valueForKey:NSStringFromRange(NSMakeRange(indexPath.section, indexPath.row))];
    if (height) return [height floatValue];
    
    CGFloat retHeight = 44;
    
    if ([self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        
        UITableViewCell * cell = [self.dataSource tableView:self cellForRowAtIndexPath:indexPath];
        
        retHeight = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        if (self.separatorStyle != UITableViewCellSeparatorStyleNone) retHeight += 1;
    }
    
    [[self ge_heightsDict] setValue:@(retHeight) forKey:NSStringFromRange(NSMakeRange(indexPath.section, indexPath.row))];
    
    return retHeight;
}

- (void)g_removeHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[self ge_heightsDict] removeObjectForKey:NSStringFromRange(NSMakeRange(indexPath.section, indexPath.row))];
}

- (void)g_setFooterNil
{
    UIView * footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor clearColor];
    self.tableFooterView = footer;
}
@end
