//
//  GeAlertWindow.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "GeAlertWindow.h"

@implementation GeAlertWindow {
}

+ (GeAlertWindow *)sharedWindow {
    
    static GeAlertWindow * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[GeAlertWindow alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    self = [super init];
    if (!self) return nil ;
    
    self.windowLevel = UIWindowLevelAlert;
    self.rootViewController = [[UIViewController alloc] init];
    return self;
}

@end
