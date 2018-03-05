//
//  NSMutableAttributedString+Ge.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/2.
//  Copyright © 2018年 My. All rights reserved.
//

#import "NSMutableAttributedString+Ge.h"

@implementation NSMutableAttributedString (Ge)

- (void)g_addAttributeForBaseLineWithOffset:(CGFloat)offset {
    [self g_addAttributeForBaseLineWithOffset:offset inRange:NSMakeRange(0, self.length)];
}

- (void)g_addAttributeForFontWithFontSize:(CGFloat)fontSize {
    [self g_addAttributeForFontWithFontSize:fontSize inRange:NSMakeRange(0, self.length)];
}

- (void)g_addAttributeForUnderlineWithStyle:(NSUnderlineStyle)style color:(UIColor *)color {
    [self g_addAttributeForUnderlineWithStyle:style color:color inRange:NSMakeRange(0, self.length)];
}

- (void)g_addAttributeForForegroundColorWithColor:(UIColor *)color {
    [self g_addAttributeForForegroundColorWithColor:color inRange:NSMakeRange(0, self.length)];
}

- (void)g_addAttributeForBackgroundColor:(UIColor *)color {
    [self g_addAttributeForBackgroundColor:color inRange:NSMakeRange(0, self.length)];
}

- (void)g_addAttributeForStrikethroughStyleWithStyle:(NSUnderlineStyle)style color:(UIColor *)color {
    [self g_addAttributeForStrikethroughStyle:style color:color inRange:NSMakeRange(0, self.length)];
}

- (void)g_addAttributeForStrokeColorWithColorr:(UIColor *)color width:(CGFloat)width {
    [self g_addAttributeForStrokeColorWithColorr:color witdth:width inRange:NSMakeRange(0, self.length)];
}

- (void)g_addAttributeForBackgroundColorWithColor:(UIColor *)color {
    [self g_addAttributeForBackgroundColor:color inRange:NSMakeRange(0, self.length)];
}

- (void)g_addAttributeForParagraphWithConstructor:(void (^)(NSParagraphStyle *))constructor {
    [self g_addAttributeForParagraphWithConstructor:constructor inRange:NSMakeRange(0, self.length)];
}

- (void)g_insertImage:(UIImage *)image atLocation:(NSInteger)location {
    [self g_insertImage:image withSize:image.size atLocation:location];
}

- (void)g_insertImage:(UIImage *)image withSize:(CGSize)size atLocation:(NSInteger)location {
    NSTextAttachment * imgAttachment = [[NSTextAttachment alloc] init];
    imgAttachment.image = image;
    imgAttachment.bounds = (CGRect){0, 0, size.width, size.height};
    
    NSAttributedString * imgAttachmentString = [NSAttributedString attributedStringWithAttachment:imgAttachment];
    if (location >= self.length) {
        [self appendAttributedString:imgAttachmentString];
    }
    else {
        [self insertAttributedString:imgAttachmentString atIndex:location];
    }    
}
@end

@implementation NSMutableAttributedString (Ge_Range)
- (void)g_addAttributeForBaseLineWithOffset:(CGFloat)offset inRange:(NSRange)range {
    [self addAttribute:NSBaselineOffsetAttributeName value:@(offset) range:range];
}

- (void)g_addAttributeForForegroundColorWithColor:(UIColor *)color inRange:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)g_addAttributeForUnderlineWithStyle:(NSUnderlineStyle)style color:(UIColor *)color inRange:(NSRange)range {
    [self addAttribute:NSUnderlineColorAttributeName value:color range:range];
    [self addAttribute:NSUnderlineStyleAttributeName value:@(style) range:range];
}

- (void)g_addAttributeForFontWithFontSize:(CGFloat)fontSize inRange:(NSRange)range {
    [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
}

- (void)g_addAttributeForBackgroundColor:(UIColor *)color inRange:(NSRange)range {
    [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
}

- (void)g_addAttributeForStrokeColorWithColorr:(UIColor *)color witdth:(CGFloat)width inRange:(NSRange)range {
    [self addAttribute:NSStrokeColorAttributeName value:color range:range];
    [self addAttribute:NSStrokeWidthAttributeName value:@(width) range:range];
}

- (void)g_addAttributeForStrikethroughStyle:(NSUnderlineStyle)style color:(UIColor *)color inRange:(NSRange)range {
    [self addAttribute:NSStrikethroughColorAttributeName value:color range:range];
    [self addAttribute:NSStrikethroughStyleAttributeName value:@(style) range:range];
}

- (void)g_addAttributeForParagraphWithConstructor:(void (^)(NSParagraphStyle *))constructor inRange:(NSRange)range {
    
    NSParagraphStyle * style = [NSParagraphStyle defaultParagraphStyle];
    if (constructor) {
        constructor(style);
    }
    [self addAttribute:NSParagraphStyleAttributeName value:style range:range];
}
@end
