//
//  UITextField+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/2/6.
//  Copyright © 2018年 My. All rights reserved.
//

#import "UITextField+Ge.h"
#import "G_UIControlEventAction.h"

@implementation UITextField (Ge)

static int textDidChange;
- (void)g_editingDidChange:(void (^)(UITextField *, NSString *))changeHandler {
    [GeUIControlEventAction addAction:^(UITextField * sender, UIControlEvents event) {
        if (changeHandler) changeHandler(sender, sender.text);
    } forEvent:UIControlEventEditingChanged];
}

- (void)g_editingDidBegin:(GeTextFiledActionHandler)beingHandler {
    [GeUIControlEventAction addAction:^(UITextField * sender, UIControlEvents event) {
        if (beingHandler) beingHandler(sender, sender.text);
    } forEvent:UIControlEventEditingDidBegin];
}

- (void)g_editingDidEnd:(GeTextFiledActionHandler)endHandler {
    [GeUIControlEventAction addAction:^(UITextField * sender, UIControlEvents event) {
        if (endHandler) endHandler(sender, sender.text);
    } forEvent:UIControlEventEditingDidEnd];
}

- (void)g_editingDidEndOnExit:(GeTextFiledActionHandler)endOnExitHandler {
    [GeUIControlEventAction addAction:^(UITextField * sender, UIControlEvents event) {
        if (endOnExitHandler) endOnExitHandler(sender, sender.text);
    } forEvent:UIControlEventEditingDidEndOnExit];
}
@end
