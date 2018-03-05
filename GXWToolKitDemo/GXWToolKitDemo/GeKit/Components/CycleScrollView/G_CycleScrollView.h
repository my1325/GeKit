//
//  G_CycleScrollView.h
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/2.
//  Copyright © 2018年 My. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GeCycleScrollView;
@protocol GeCycleScrollViewDelegate <NSObject>

/**
 滚动到index

 @param cycleScrollView GeCycleScrollView
 @param index index
 */
- (void) g_cycleScrollView: (GeCycleScrollView *)cycleScrollView didScrollToIndex: (NSInteger)index;

/**
 选择index

 @param cycleScrollView GeCycleScrollView
 @param index index
 */
- (void) g_cycleScrollView:(GeCycleScrollView *)cycleScrollView didSelectedIndex:(NSInteger)index;
@end

typedef NS_ENUM(NSInteger, GeCycleScrollViewScrollDirection) {
    GeCycleScrollViewScrollDirectionHorizontal,
    GeCycleScrollViewScrollDirectionVertical
};

@interface GeCycleScrollView : UIView

/**
 delegate
 */
@property (nonatomic, weak) id<GeCycleScrollViewDelegate> delegate;

/**
 image url
 */
@property (nonatomic, copy) NSArray<NSString *> * imageUrls;

/**
 images
 */
@property (nonatomic, copy) NSArray<UIImage *> * images;

/**
 视差系数
 */
@property (nonatomic, assign) CGFloat parallax;

/**
 滚动方向
 */
@property (nonatomic, assign) GeCycleScrollViewScrollDirection scrollDirection;

/**
 滚动间隔
 */
@property (nonatomic, assign) NSTimeInterval scrollTimeInterval;

/**
 只有一个的时候隐藏pageControl
 */
@property (nonatomic, assign) BOOL hidePageControlWhenOnlyOne;

/**
 reload data
 */
- (void) reloadData;
@end
