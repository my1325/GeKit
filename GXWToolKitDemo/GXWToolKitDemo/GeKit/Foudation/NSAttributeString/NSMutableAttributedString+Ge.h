//
//  NSMutableAttributedString+Ge.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/2.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Ge)
/**
 BaseLine for NSMakeRange(0, self.length)

 @param offset Offset
 */
- (void) g_addAttributeForBaseLineWithOffset: (CGFloat)offset;

/**
 System Font size for NSMakeRange(0, self.length)

 @param fontSize fontSize
 */
- (void) g_addAttributeForFontWithFontSize: (CGFloat)fontSize;

/**
 ForegroundColor for NSMakeRange(0, self.length)

 @param color foregroundColor
 */
- (void) g_addAttributeForForegroundColorWithColor: (UIColor *)color;

/**
 underline style and color for NSMakeRange(0, self.length)

 @param style NSUnderlineStyle
 @param color UIColor
 */
- (void) g_addAttributeForUnderlineWithStyle: (NSUnderlineStyle)style
                                       color: (UIColor *)color;

/**
 background color for NSMakeRange(0, self.length)

 @param color UIColor
 */
- (void) g_addAttributeForBackgroundColorWithColor: (UIColor *)color;

/**
 Strikethrough Style and Strikethrough color for NSMakeRange(0, self.length)

 @param style NSUnderlineStyle
 @param color UIColor
 */
- (void) g_addAttributeForStrikethroughStyleWithStyle: (NSUnderlineStyle) style
                                                color: (UIColor *)color;

/**
 Stroke Color and stroke width for NSMakeRange(0, self.length)

 @param color UIColor
 @param width CGFloat
 */
- (void) g_addAttributeForStrokeColorWithColorr: (UIColor *)color
                                         width: (CGFloat)width;

/**
 construct a paragraph style for NSMakeRange(0, self.length)

 @param constructor constructor
 */
- (void) g_addAttributeForParagraphWithConstructor: (void(^)(NSParagraphStyle *paragraphStyle))constructor;

/**
 插入图片-用图片的大小

 @param image UIImage
 @param location NSInteger <= self.length
 */
- (void) g_insertImage: (UIImage *)image atLocation: (NSInteger)location;

/**
 插入图片-指定大小

 @param image UIImage
 @param size 指定大小
 @param location NSInteger
 */
- (void) g_insertImage: (UIImage *)image withSize: (CGSize)size atLocation: (NSInteger)location;
@end

@interface NSMutableAttributedString (Ge_Range)

/**
 Stroke Color and stroke width for range
*/
- (void) g_addAttributeForStrokeColorWithColorr: (UIColor *)color
                                         witdth: (CGFloat)width
                                        inRange: (NSRange)range;
/**
 Strikethrough Style and Strikethrough Color for range
*/
- (void) g_addAttributeForStrikethroughStyle:(NSUnderlineStyle)style
                                       color: (UIColor *)color
                                     inRange: (NSRange)range;
/**
 Baseline offset for range
 */
- (void) g_addAttributeForBaseLineWithOffset: (CGFloat)offset
                                     inRange: (NSRange)range;

/**
 system font size for range
 */
- (void) g_addAttributeForFontWithFontSize: (CGFloat)fontSize
                                   inRange: (NSRange)range;

/**
 foreground color for range
*/
- (void) g_addAttributeForForegroundColorWithColor: (UIColor *)color
                                           inRange: (NSRange)range;

/**
 underline style and underline color for range
 */
- (void) g_addAttributeForUnderlineWithStyle: (NSUnderlineStyle)style
                                       color: (UIColor *)color
                                     inRange: (NSRange)range;

/**
 background color for range
 */
- (void) g_addAttributeForBackgroundColor: (UIColor *)color
                                  inRange: (NSRange)range;

/**
 construct a paragraph style for range
 */
- (void) g_addAttributeForParagraphWithConstructor: (void(^)(NSParagraphStyle *))constructor
                                           inRange: (NSRange)range;
@end
