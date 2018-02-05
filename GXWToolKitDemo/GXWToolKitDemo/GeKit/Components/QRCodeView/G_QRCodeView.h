//
//  QRCodeView.h
//  YiYou
//
//  Created by m y on 2018/2/2.
//  Copyright © 2018年 m y. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString QRCodeType;
typedef NSString QRCodeVideoGravity;

@class GeQRCodeView;
@protocol GeQRCodeViewDelegate<NSObject>

- (void)qrCodeView: (GeQRCodeView *)qrCodeView didCaptureResults: (NSArray<NSString *> *)results;
@end

@interface GeQRCodeInterestRect: NSObject

@property (nonatomic, assign) CGRect frame;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, strong) UIColor * borderColor;

@property (nonatomic, strong) UIImage * backgroundImage;

@property (nonatomic, strong) UIColor * animteLineColor;

@property (nonatomic, assign) CGFloat animateLineHeight;

@property (nonatomic, strong) UIImage * animateLineImage;
@end

@interface GeQRCodeView : UIView

@property (nonatomic, weak) id<GeQRCodeViewDelegate> delegate;

@property (nonatomic, strong) GeQRCodeInterestRect * interestRect;

@property (nonatomic, strong) NSSet<QRCodeType *> * metadataObjectTypes;

@property (nonatomic, strong ) QRCodeVideoGravity * videoGravity;

- (instancetype)initWithInterestRect: (GeQRCodeInterestRect *)interestRect;

- (void)startCapture;

- (void)endCapture;
@end
