//
//  SegmentListControl.h
//  YiYou
//
//  Created by m y on 2018/1/30.
//  Copyright © 2018年 m y. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GeSegmentListControl;

@protocol GeSegmentListControlDelegate<NSObject>

@optional
- (void) g_segmentListControl: (GeSegmentListControl *)control didSelectedAtIndex: (NSInteger)index;

- (CGSize) g_segmentListControl: (GeSegmentListControl *)control bottomIndicatorSizeAtIndex: (NSInteger)index;

- (CGFloat) g_segmentListControl: (GeSegmentListControl *)control widthForSegmentAtIndex: (NSInteger)index;
@end

@protocol GeSegmentListControlDataSource<NSObject>

- (NSInteger) g_numOfItemsInSegmentListControl: (GeSegmentListControl *)control;

- (NSString *) g_segmentListControl: (GeSegmentListControl *)control titleAtIndex: (NSInteger)index;
@end

@interface GeSegmentListControl : UIControl

@property (nonatomic, weak) id<GeSegmentListControlDelegate> delegate;

@property (nonatomic, weak) id<GeSegmentListControlDataSource> dataSource;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) UIEdgeInsets margin;

@property (nonatomic, assign) CGFloat itemMinimumSpacing;

- (void) reloadData;

- (void) setSelectedIndex: (NSInteger) index animated: (BOOL) animated;

- (void) setFont: (UIFont *)font forState: (UIControlState)state;

- (void) setTextColor: (UIColor *)color forState: (UIControlState)state;

/**
 设置title的文字样式，会使
 - (void) setFont: (UIFont *)font forState: (UIControlState)state;
 
 - (void) setTextColor: (UIColor *)color forState: (UIControlState)state;
 无效
 @param attribute attribute
 @param state UIControlState
 */
- (void) setAttribute: (NSDictionary<NSAttributedStringKey, id> *)attribute forState: (UIControlState)state;

- (void) setBackgroundColor: (UIColor *)color forState: (UIControlState)state;

/**
 设置背景图片，会使
 - (void) setBackgroundColor: (UIColor *)color forState: (UIControlState)state;
无效

 @param image UIImage
 @param state UIControlState
 */
- (void) setBackgroundImage: (UIImage *)image forState: (UIControlState)state;
@end
