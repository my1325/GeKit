//
//  AnimateView.h
//  YiYou
//
//  Created by m y on 2018/1/18.
//  Copyright © 2018年 m y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeAnimateView : UIView

@property(nonatomic, readonly, strong) CAShapeLayer * animateLayer;

@property(nonatomic, readonly, assign) BOOL isAnimating;

@property(nonatomic, assign) BOOL removeFromSuperViewWhenStopped;

@property(nonatomic, assign) CGSize animateSize;

@property(nonatomic, assign) CGFloat indicatoryWidth;

@property(nonatomic, strong) UIColor * animateBackgroundColor;

@property(nonatomic, strong) UIColor * indicatorColor;

- (void) startInView: (UIView *)superView;

- (void) stop;

@end
