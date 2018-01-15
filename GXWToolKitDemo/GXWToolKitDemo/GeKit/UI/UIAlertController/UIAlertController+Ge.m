//
//  UIAlertController+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/1/15.
//  Copyright © 2018年 My. All rights reserved.
//

#import "UIAlertController+Ge.h"
#import "GeAlertWindow.h"

@implementation UIAlertController (Ge)

- (instancetype)g_cancelWithTitle:(NSString *)title action:(G_EmptyAction)actionHanlder {
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      
        if (actionHanlder) actionHanlder();
        
        if (GeAlertWindow.sharedWindow.keyWindow) {
            
            [[UIApplication.sharedApplication delegate].window makeKeyAndVisible];
        }
    }];
    
    [self addAction:cancelAction];
    return self;
}

- (instancetype)g_destructiveWithTitle:(NSString *)title action:(G_EmptyAction)actionHandler {
    
    UIAlertAction * destructiveAction  = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (actionHandler) actionHandler();
        
        if (GeAlertWindow.sharedWindow.keyWindow) {
            
            [[UIApplication.sharedApplication delegate].window makeKeyAndVisible];
        }
    }];
    
    [self addAction:destructiveAction];
    return self;
}

- (instancetype)g_others:(NSArray<NSString *> *)titles action:(G_AlertAction)actionHanlder {
    
    for (NSInteger index = 0; index < titles.count; index ++) {
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:titles[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            if (actionHanlder) actionHanlder(index);
            
            if (GeAlertWindow.sharedWindow.keyWindow) {
                
                [[UIApplication.sharedApplication delegate].window makeKeyAndVisible];
            }
        }];
        
        [self addAction:action];
    }
    
    return self;
}

- (void)g_showInViewController:(UIViewController *)viewController {
    
    [viewController presentViewController:self animated:YES completion:nil];
}

- (void)g_show {
    
    [GeAlertWindow.sharedWindow.rootViewController presentViewController:self animated:YES completion:nil];
    [GeAlertWindow.sharedWindow makeKeyAndVisible];
}
@end
