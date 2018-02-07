//
//  UITextField+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/2/6.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GeTextFiledActionHandler)(UITextField * textFiled, NSString * text);
@interface UITextField (Ge)
/**
 editingDidChange:

 @param changeHandler GeTextFiledActionHandler
 */
- (void)g_editingDidChange: (GeTextFiledActionHandler) changeHandler;
/**
 editingDidBegin:
 
 @param beingHandler GeTextFiledActionHandler
 */
- (void)g_editingDidBegin: (GeTextFiledActionHandler) beingHandler;
/**
 editingDidEnd

 @param endHandler GeTextFiledActionHandler
 */
- (void)g_editingDidEnd: (GeTextFiledActionHandler) endHandler;
/**
 DidEndOnExit
 
 @param endOnExitHandler GeTextFiledActionHandler
 */
- (void)g_editingDidEndOnExit: (GeTextFiledActionHandler) endOnExitHandler;
@end
