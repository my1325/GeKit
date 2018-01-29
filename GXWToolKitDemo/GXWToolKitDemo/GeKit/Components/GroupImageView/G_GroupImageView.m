//
//  GroupImageView.m
//  YiYou
//
//  Created by m y on 2018/1/19.
//  Copyright © 2018年 m y. All rights reserved.
//

#import "G_GroupImageView.h"
#import "G_ProgressAnimateView.h"
#import "UIView+Ge.h"
#import <YYWebImage.h>
#import <YYImage.h>

@implementation GeGroupImageViewTransitionStyle

- (instancetype)init { return nil; }

- (instancetype) initWithRawValue: (NSInteger)rawValue {
    
    self = [super init];
    if (!self) return nil;
    
    _rawValue = rawValue;
    return self;
}

+ (GeGroupImageViewTransitionStyle *)defaultStyle {
    
    static GeGroupImageViewTransitionStyle * _defaultStyle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultStyle = [[GeGroupImageViewTransitionStyle alloc] initWithRawValue:0];
    });
    return _defaultStyle;
}

+ (GeGroupImageViewTransitionStyle *)blurStyle {
    
    static GeGroupImageViewTransitionStyle * _blurStyle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _blurStyle = [[GeGroupImageViewTransitionStyle alloc] initWithRawValue:1];
    });
    return _blurStyle;
}
@end

@class GeGroupImageViewCell;
@protocol GeGroupImageViewCellDelegate<NSObject>

-  (void) cell: (GeGroupImageViewCell *)cell didTouchImage: (UIImage *)image url: (NSString *)url;
@end

@interface GeGroupImageViewCell: UICollectionViewCell<UIScrollViewDelegate> {
    
    UIView * _imageViewContainerView;
    YYAnimatedImageView * _imageView;
    UIScrollView * _scrollView;
    GeProgressAnimateView * _progressView;
    
    UIImage * _image;
    NSString * _imageUrlString;
    
    __weak id<GeGroupImageViewCellDelegate> _delegate;
}

- (void) updateImage: (UIImage *)image withDelegate: (id<GeGroupImageViewCellDelegate>) delegate;

- (void) updateImageWithUrl: (NSString *)urlString withDelegate: (id<GeGroupImageViewCellDelegate>) delegate;
@end

@implementation GeGroupImageViewCell

- (instancetype)init { return [self initWithFrame:CGRectZero]; }

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0, 0, frame.size.width, frame.size.height}];
    _scrollView.delegate = self;
    _scrollView.bouncesZoom = YES;
    _scrollView.maximumZoomScale = 3;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.contentView addSubview:_scrollView];

    _imageViewContainerView = [[UIView alloc] initWithFrame:(CGRect){0, 0, frame.size.width, frame.size.height}];
    _imageViewContainerView.clipsToBounds = YES;
    [_scrollView addSubview:_imageViewContainerView];

    _imageView = [[YYAnimatedImageView alloc] initWithFrame:(CGRect){0, 0, frame.size.width, frame.size.height}];
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    _imageView.userInteractionEnabled = YES;
    [_imageViewContainerView addSubview:_imageView];
    
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_handleTapImageView)];
    [_imageView addGestureRecognizer:tapGR];
    
    _progressView = [[GeProgressAnimateView alloc] init];
    
    [self.contentView addSubview:_progressView];
    return self;
}

- (void) p_handleTapImageView {
    
    if ([_delegate respondsToSelector:@selector(cell:didTouchImage:url:)]) {
        
        [_delegate cell:self didTouchImage:_image url:_imageUrlString];
    }
}

- (void)layoutSubviews {
    
    _scrollView.frame = self.bounds;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imageViewContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    UIView *subView = _imageViewContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)p_resizeSubviewSize {
    
    _imageViewContainerView.frame = (CGRect){0, 0, self.contentView.g_width, 0};
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.contentView.g_height / self.contentView.g_width) {
        CGRect imageViewContainerViewFrame = _imageViewContainerView.frame;
        imageViewContainerViewFrame.size.height = floor(image.size.height / (image.size.width / self.contentView.g_height));
        _imageViewContainerView.frame = imageViewContainerViewFrame;
    } else {
        CGFloat height = image.size.height / image.size.width * self.contentView.g_width;
        if (height < 1 || isnan(height)) height = self.contentView.g_height;
        height = floor(height);
        CGRect imageViewContainerViewFrame = _imageViewContainerView.frame;
        imageViewContainerViewFrame.size.height = height;
        _imageViewContainerView.frame = imageViewContainerViewFrame;
        _imageViewContainerView.center = CGPointMake(_imageViewContainerView.center.x, self.contentView.g_height / 2);
    }
    if (_imageViewContainerView.frame.size.height > self.contentView.g_height && _imageViewContainerView.frame.size.height - self.contentView.g_height <= 1) {
        CGRect imageViewContainerViewFrame = _imageViewContainerView.frame;
        imageViewContainerViewFrame.size.height = self.contentView.g_height;
        _imageViewContainerView.frame = imageViewContainerViewFrame;
    }
    _scrollView.contentSize = CGSizeMake(self.contentView.g_width, MAX(_imageViewContainerView.bounds.size.height, self.contentView.g_height));
    [_scrollView scrollRectToVisible:self.contentView.bounds animated:NO];
    
    if (_imageViewContainerView.g_height <= self.contentView.g_height) {
        _scrollView.alwaysBounceVertical = NO;
    } else {
        _scrollView.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageViewContainerView.bounds;
    [CATransaction commit];
}

- (void)updateImage:(UIImage *)image withDelegate:(id<GeGroupImageViewCellDelegate>)delegate{
    
    _delegate = delegate;
    if ([image isEqual:_image]) return;
    
    _image = image;
    _imageView.image = image;
    [self p_resizeSubviewSize];
}

- (void)updateImageWithUrl:(NSString *)urlString withDelegate:(id<GeGroupImageViewCellDelegate>)delegate {
    
    _delegate = delegate;
    if ([urlString isEqualToString:_imageUrlString]) return;
    
    _imageUrlString = [urlString copy];
    
    [_progressView startInView:self.contentView];

//    @weakify(self);
    __weak typeof(self) wself = self;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:urlString] placeholder:nil options:kNilOptions manager:nil progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        __strong typeof(wself) sself = wself;
        if (!sself) return;
        
        CGFloat progress = receivedSize / (float)expectedSize;
        progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
        if (isnan(progress)) progress = 0;
        sself->_progressView.progress = progress;
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        __strong typeof(wself) sself = wself;

        if (!sself) return;
        sself->_progressView.progress = 1;
        [sself->_progressView stop];
        if (stage == YYWebImageStageFinished) {
            
            sself->_scrollView.maximumZoomScale = 3;
            if (image) {
                
                [sself p_resizeSubviewSize];
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.1;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                transition.type = kCATransitionFade;
                [sself->_imageView.layer addAnimation:transition forKey:@"yy.fade"];
            }
        }
    }];
    [self p_resizeSubviewSize];
}

- (void)dealloc {
    
    [_imageView yy_cancelCurrentImageRequest];
}
@end

@interface GeGroupImageView()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, GeGroupImageViewCellDelegate>

@end

@implementation GeGroupImageView {
    
    UICollectionView * _collectionView;
    UIPageControl * _pageControl;
    UILabel * _pageLabel;
    UIImageView * _background;
    UIImageView * _blurBackground;
    UIView * _backgroundView;
    UIVisualEffectView * _effectView;
    
    __weak UIView * fromView;
    __weak UIView * toContainerView;
    
    NSArray<UIView *> * _groupImages;
}

- (instancetype)init { return [self initWithFrame:CGRectZero]; }

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    _transitionStyle = GeGroupImageViewTransitionStyle.defaultStyle;
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.0;
    
    _background = UIImageView.new;
    _background.frame = self.bounds;
    _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _blurBackground = UIImageView.new;
    _blurBackground.frame = self.bounds;
    _blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollsToTop = NO;
    _collectionView.pagingEnabled = YES;
//    _collectionView.alwaysBounceHorizontal = groupItems.count > 1;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.delaysContentTouches = NO;
    _collectionView.canCancelContentTouches = YES;
    
    [_collectionView registerClass:[GeGroupImageViewCell class] forCellWithReuseIdentifier:@"GroupImageViewCell"];
    
    _pageLabel = [[UILabel alloc] init];
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.frame = (CGRect){0, 0, self.g_width, 40};
    _pageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _pageLabel.font = [UIFont systemFontOfSize:14];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.bounds = (CGRect){0, 0, self.g_width, 10};
    _pageControl.center = CGPointMake(self.g_width / 2, self.g_height - 18);
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    _effectView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
    _effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:_background];
    [self addSubview:_blurBackground];
    [self addSubview:_effectView];
    [self addSubview:_backgroundView];
    [self addSubview:_collectionView];
    [self addSubview:_pageControl];
    [self addSubview:_pageLabel];
    return self;
}

#pragma UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return (CGSize){self.g_width, self.g_height};
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return (UIEdgeInsets){0, 0, 0, 0};
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger page = scrollView.contentOffset.x / scrollView.g_width + 0.5;
    
    _pageControl.currentPage = page;
    _pageLabel.text = _sourceImages.count == 0 ? [NSString stringWithFormat:@"%ld/%ld", (long)page, (unsigned long)_sourceUrls.count] : [NSString stringWithFormat:@"%ld/%ld", (long)page, (unsigned long)_sourceImages.count];
}

#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _sourceImages.count == 0 ? _sourceUrls.count : _sourceImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GeGroupImageViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupImageViewCell" forIndexPath:indexPath];
    if (_sourceImages.count > 0) [cell updateImage:_sourceImages[indexPath.item] withDelegate:self];
    else [cell updateImageWithUrl:_sourceUrls[indexPath.item] withDelegate:self];
    
    return cell;
}

- (CGRect) p_preferredAnimateRect {
    
    NSInteger index = _pageControl.currentPage;
    UIImage * img = _sourceImages[index];
    if (!img) {
        
        img = [[YYImageCache sharedCache] getImageForKey:_sourceUrls[index]];
    }
    
    if (!img) return self.bounds;
    
    CGRect rect = (CGRect){0, 0, self.g_width, self.g_height};
    
    if (img.size.height / img.size.width > self.g_height / self.g_width) {
        rect.size.height = floor(img.size.height / (img.size.width / self.g_height));
    } else {
        CGFloat height = img.size.height / img.size.width * self.g_width;
        if (height < 1 || isnan(height)) height = self.g_height;
        height = floor(height);
        rect.size.height = height;
        rect.origin.y = self.g_height / 2 - height / 2;
    }
    if (rect.size.height > self.g_height && rect.size.height - self.g_height <= 1) {
        
        rect.size.height = self.g_height;
    }
    
    return rect;
}

- (void)cell:(GeGroupImageViewCell *)cell didTouchImage:(UIImage *)image url:(NSString *)url{
    
    [self dismiss];
}

- (void) presentGroupImages: (NSArray<UIView *> *)groupImages toContainerView: (UIView *)containerView curIndex: (NSInteger)curIndex {
    
    if (_sourceUrls.count == 0 && _sourceImages.count == 0) return;
    
//    UIVisualEffectView
//    UIBlurEffect
    self.userInteractionEnabled = NO;
    _collectionView.hidden = YES;
    [containerView addSubview:self];
    
    self.frame = containerView.bounds;
    _pageControl.numberOfPages = _sourceImages.count == 0 ? _sourceUrls.count : _sourceImages.count;
    _pageControl.currentPage = curIndex;
    _pageLabel.text = _sourceImages.count == 0 ? [NSString stringWithFormat:@"%ld/%ld", (long)curIndex, (unsigned long)_sourceUrls.count] : [NSString stringWithFormat:@"%ld/%ld", (long)curIndex, (unsigned long)_sourceImages.count];
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:curIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    _groupImages = groupImages;
    
    UIView * currentImage = groupImages[curIndex];
    
    UIImage * snapshotImage = [containerView g_snapshotAfterScreenUpdates:NO];
    
    _background.image = snapshotImage;
    
    _blurBackground.image = snapshotImage;
    
    CGRect frame = currentImage.frame;
    CGRect convertFrame = [currentImage.superview convertRect:frame toView:containerView];
    
    UIImageView * tempImageView = [[UIImageView alloc] initWithFrame:convertFrame];
    tempImageView.image = [currentImage g_takeSnapShot];
    
    [self addSubview:tempImageView];
    
    [tempImageView g_animateWithFrame:[self p_preferredAnimateRect] withDuration:0.35];
    
    if (_transitionStyle == GeGroupImageViewTransitionStyle.defaultStyle) {
        [_backgroundView g_animateWithAlpha:1.0 withDuration:0.35];
    }
    else if (_transitionStyle == GeGroupImageViewTransitionStyle.blurStyle) {
        [_effectView g_animateWithVisualEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark] withDuration:0.35];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self->_blurBackground.hidden = YES;
        self->_collectionView.hidden = NO;
        [tempImageView removeFromSuperview];
        self.userInteractionEnabled = YES;
    });
}

- (void) dismiss {
    
    self.userInteractionEnabled = NO;
    NSInteger curIndex = _pageControl.currentPage;
    
    UIView * curImage = _groupImages[curIndex];
    
    UIImage * snapshot = [curImage g_takeSnapShot];
    
    _blurBackground.hidden = NO;
    _collectionView.hidden = YES;
    
    UIImageView * tempImageView = [[UIImageView alloc] initWithFrame:[self p_preferredAnimateRect]];
    tempImageView.image = snapshot;
    
    [self addSubview:tempImageView];
    
    CGRect converFrame = [curImage.superview convertRect:curImage.frame toView:toContainerView];
    [tempImageView g_animateWithFrame:converFrame withDuration:0.35];

    if (_transitionStyle == GeGroupImageViewTransitionStyle.defaultStyle) {
        [_backgroundView g_animateWithAlpha:0.0 withDuration:0.35];
    }
    else if (_transitionStyle == GeGroupImageViewTransitionStyle.blurStyle) {
        [_effectView g_animateWithVisualEffect:nil withDuration:0.35];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [tempImageView removeFromSuperview];
        [self removeFromSuperview];
        self.userInteractionEnabled = YES;
        self->_collectionView.hidden = NO;
    });
}
@end

