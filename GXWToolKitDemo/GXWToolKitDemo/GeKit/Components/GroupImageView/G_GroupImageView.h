//
//  GroupImageView.h
//  YiYou
//
//  Created by m y on 2018/1/19.
//  Copyright © 2018年 m y. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GeGroupImageViewTransitionStyle: NSObject

@property(nonatomic, class, readonly) GeGroupImageViewTransitionStyle * blurStyle;

@property(nonatomic, class, readonly) GeGroupImageViewTransitionStyle * defaultStyle;

@property(nonatomic, assign, readonly) NSInteger rawValue;
@end

@interface GeGroupImageView : UIView

@property(nonatomic, strong) NSArray<UIImage *> * sourceImages;

@property(nonatomic, strong) NSArray<NSString *> * sourceUrls;

@property(nonatomic, strong) GeGroupImageViewTransitionStyle * transitionStyle; /// default

- (void) presentGroupImages: (NSArray<UIView *> *)groupImages toContainerView: (UIView *)containerView curIndex: (NSInteger)curIndex;
@end
