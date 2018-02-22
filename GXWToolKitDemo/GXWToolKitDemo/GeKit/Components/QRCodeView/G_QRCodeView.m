//
//  QRCodeView.m
//  YiYou
//
//  Created by m y on 2018/2/2.
//  Copyright © 2018年 m y. All rights reserved.
//

#import "G_QRCodeView.h"
#import "G_WeakProxy.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+Ge.h"

@implementation GeQRCodeInterestRect
@end

@interface GeQRCodeView()<AVCaptureMetadataOutputObjectsDelegate>
@end

@implementation GeQRCodeView {
    
    AVCaptureDevice * _device;
    AVCaptureDeviceInput * _input;
    AVCaptureMetadataOutput * _output;
    AVCaptureSession * _session;
    AVCaptureVideoPreviewLayer * _previewLayer;
    
    BOOL _prepared;
    dispatch_queue_t _outpuHandleQueue;
    
    // UI
    UIImageView * _backgroundImageView;
    UIImageView * _animateImageView;
    UIView * _scanView;
    UIView * _animateView;
    CAShapeLayer * _cropLayer;
    
    // animate
    NSTimer * _timer;
    NSInteger _num;
    BOOL _upOrDown;
}

- (instancetype)initWithInterestRect:(GeQRCodeInterestRect *)interestRect {
    
    GeQRCodeView * codeView = [self initWithFrame:CGRectZero];
    codeView.interestRect = interestRect;
    return codeView;
}

- (void)startCapture {
    
    if (!_videoGravity) {
        _videoGravity = [QRCodeVideoGravity g_aspectFill];
    }
    if (_metadataObjectTypes.count == 0) {
        _metadataObjectTypes = [NSSet setWithObject:[QRCodeType g_codeQR]];
    }
    
    if (!_prepared) {
        [self p_prepareAnimateView];
        [self p_prepareCropRect];
        [self p_prepareDevice];
        [self p_prepareAnimateTimer];
        
        _prepared = YES;
    }
    
    [self p_configAnimate];
    [self p_configCropLayer];
    [self p_configInterestRect];
    
    
    [_session startRunning];
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)endCapture {
    [_session stopRunning];
    [_timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - private
#pragma mark - prepare

- (void)p_prepareCropRect {
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, [self p_scanRect]);
    CGPathAddRect(path, NULL, self.bounds);
    
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.path = path;
    layer.fillColor = [UIColor blackColor].CGColor;
    layer.opacity = 0.6;
    [layer setNeedsLayout];

    [self.layer addSublayer:layer];
    
    _cropLayer = layer;
}

- (void)p_prepareDevice {
    
    _outpuHandleQueue = dispatch_queue_create("com.my.qr.handle", DISPATCH_QUEUE_CONCURRENT);
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:_outpuHandleQueue];
    
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    
    if ([_session canAddInput:_input]) [_session addInput:_input];
    if ([_session canAddOutput:_output]) [_session addOutput:_output];
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.frame = self.layer.bounds;
    [self.layer insertSublayer:_previewLayer atIndex:0];
}

- (void)p_prepareAnimateView {
    
    _scanView = [[UIView alloc] initWithFrame:[self p_scanRect]];
    _scanView.backgroundColor = [UIColor clearColor];
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, [self p_scanRect].size.width, [self p_scanRect].size.height}];
    
    _animateView = [[UIView alloc] initWithFrame:(CGRect){0, [self p_scanRect].size.height / 2 - 1, [self p_scanRect].size.width, 2}];
    
    _animateImageView = [[UIImageView alloc] initWithFrame:(CGRect){0, [self p_scanRect].size.height / 2 - 1, [self p_scanRect].size.width, 2}];
    
    [_scanView addSubview:_backgroundImageView];
    [_scanView addSubview:_animateView];
    [_scanView addSubview:_animateImageView];
    
    [self addSubview:_scanView];
}

- (void)p_prepareAnimateTimer {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:[GeWeakProxy g_proxyWithTarget:self] selector:@selector((p_handlerTimer)) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)p_handlerTimer {
    
    if (_upOrDown == false)
    {
        _num += 1;
        if (_interestRect.animateLineImage) {
            _animateImageView.frame = (CGRect){0, 2 * _num, _animateImageView.bounds.size.width, _animateImageView.bounds.size.height};
            
            if (2*_num >= ([self p_scanRect].size.height - _animateImageView.bounds.size.height )) {
                _upOrDown = true;
            }
        }
        else {
            _animateView.frame = (CGRect){0, 2 * _num, _animateView.bounds.size.width, _animateView.bounds.size.height};
            
            if (2*_num >= ([self p_scanRect].size.height - _animateView.bounds.size.height )) {
                _upOrDown = true;
            }
        }
    }
    else {
        _num -= 1;
        if (_interestRect.animateLineImage) {
            _animateImageView.frame = (CGRect){0, 2 * _num, _animateImageView.bounds.size.width, _animateImageView.bounds.size.height};
        }
        else {
            _animateView.frame = (CGRect){0, 2 * _num, _animateView.bounds.size.width, _animateView.bounds.size.height};
        }
        if (_num == 0) {
            _upOrDown = false;
        }
    }
}

#pragma mark - config
- (void)p_configCropLayer {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, [self p_scanRect]);
    CGPathAddRect(path, NULL, self.bounds);
    
    _cropLayer.fillRule = kCAFillRuleEvenOdd;
    _cropLayer.path = path;
    _cropLayer.fillColor = [UIColor blackColor].CGColor;
    _cropLayer.opacity = 0.6;
    [_cropLayer setNeedsLayout];
}

- (void)p_configInterestRect {
    
    _output.metadataObjectTypes = [_metadataObjectTypes allObjects];
    
    CGRect cropRect = [self p_scanRect];
    
    CGSize size = self.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    
    //ref:http://www.cocoachina.com/ios/20141225/10763.html
    if (p1 < p2) {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        _output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                  cropRect.origin.x/size.width,
                                                  cropRect.size.height/fixHeight,
                                                  cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        _output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                                  (cropRect.origin.x + fixPadding)/fixWidth,
                                                  cropRect.size.height/size.height,
                                                  cropRect.size.width/fixWidth);
    }
    
    _previewLayer.videoGravity = _videoGravity;
}

- (void)p_configAnimate {
    
    if (_interestRect.backgroundImage) {
        _backgroundImageView.hidden = NO;
        _backgroundImageView.image = _interestRect.backgroundImage;
        _scanView.layer.borderColor = nil;
        _scanView.layer.borderWidth = 0;
        _scanView.layer.cornerRadius = 0;
    }else {
        _backgroundImageView.hidden = YES;
        _backgroundImageView.image = nil;
        _scanView.layer.borderColor = _interestRect.borderColor.CGColor;
        _scanView.layer.borderWidth = _interestRect.borderWidth;
        _scanView.layer.cornerRadius = _interestRect.cornerRadius;
        
    }
    
    if (_interestRect.animateLineImage) {
        _animateImageView.image = _interestRect.animateLineImage;
        _animateImageView.hidden = NO;
        _animateImageView.center = (CGPoint){_scanView.bounds.size.width / 2, _scanView.bounds.size.height / 2};
        _animateImageView.bounds = (CGRect){0, 0, _interestRect.frame.size.width, _interestRect.animateLineImage.size.height};
        _animateView.backgroundColor = nil;
        _animateView.hidden = YES;
    }
    else {
        _animateImageView.image = nil;
        _animateImageView.hidden = YES;
        _animateImageView.center = (CGPoint){_scanView.bounds.size.width / 2, _scanView.bounds.size.height / 2};
        _animateImageView.bounds = (CGRect){0, 0, _scanView.bounds.size.width, _interestRect.animateLineHeight};
        _animateView.backgroundColor = _interestRect.animteLineColor;
        _animateView.hidden = NO;
    }
}

#pragma mark - rect
- (CGRect)p_scanRect {
    return !_interestRect ? self.bounds : _interestRect.frame;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    [_session stopRunning];
    NSMutableArray * results = @[].mutableCopy;
    for (AVMetadataObject * object in metadataObjects) {
        if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            
            NSString * text = [(AVMetadataMachineReadableCodeObject *)object stringValue];
            
            if (!text) continue;
            
            [results addObject:text];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_delegate respondsToSelector:@selector(qrCodeView:didCaptureResults:)]) {
            [_delegate qrCodeView:self didCaptureResults:results];
        }
    });
}
@end
