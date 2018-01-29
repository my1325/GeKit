//
//  AnimateView.h
//  YiYou
//
//  Created by m y on 2018/1/18.
//  Copyright © 2018年 m y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface GeAnimateView : UIView

G_ReadonlyProperty(strong) CAShapeLayer * animateLayer;

G_ReadonlyProperty(assign) BOOL isAnimating;

G_AssignProperty BOOL removeFromSuperViewWhenStopped;

G_AssignProperty CGSize animateSize;

G_AssignProperty CGFloat indicatoryWidth;

G_StrongProperty UIColor * animateBackgroundColor;

G_StrongProperty UIColor * indicatorColor;

- (void) startInView: (UIView *)superView;

- (void) stop;

@end
