//
//  UIResponder+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "UIResponder+Ge.h"

@implementation UIResponder (Ge)

- (void)g_routerActionNamed:(NSString *)actioName userInfo:(id)userInfo {
    
    [self.nextResponder g_routerActionNamed:actioName userInfo:userInfo];
}

@end
