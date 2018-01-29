//
//  GroupImageView.h
//  YiYou
//
//  Created by m y on 2018/1/19.
//  Copyright © 2018年 m y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"


@interface GeGroupImageViewTransitionStyle: NSObject

G_ClassReadonlyProperty GeGroupImageViewTransitionStyle * blurStyle;

G_ClassReadonlyProperty GeGroupImageViewTransitionStyle * defaultStyle;

G_ReadonlyProperty(assign) NSInteger rawValue;
@end

@interface GeGroupImageView : UIView

G_StrongProperty NSArray<UIImage *> * sourceImages;

G_StrongProperty NSArray<NSString *> * sourceUrls;

G_StrongProperty GeGroupImageViewTransitionStyle * transitionStyle; /// default

- (void) presentGroupImages: (NSArray<UIView *> *)groupImages toContainerView: (UIView *)containerView curIndex: (NSInteger)curIndex;
@end
