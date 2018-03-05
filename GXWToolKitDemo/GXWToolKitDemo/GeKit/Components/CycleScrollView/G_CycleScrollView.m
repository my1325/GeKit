//
//  G_CycleScrollView.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/2.
//  Copyright © 2018年 My. All rights reserved.
//

#import "G_CycleScrollView.h"
#import "G_WeakProxy.h"
#import <YYImage/YYImage.h>
#import <YYWebImage/YYWebImage.h>

static CGFloat g_calculateConstant(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2) {
    
    if (x2 == x1) {
        
        return 0;
    }
    
    return (y1*(x2 - x1) - x1*(y2 - y1)) / (x2 - x1);
}

@interface GeCycleScrollViewItemCell: UICollectionViewCell

/**
 imageView
 */
@property (nonatomic, strong) YYAnimatedImageView * imageView;

/**
 set Image

 @param image image
 */
- (void) setImage: (UIImage *)image;

/**
 set image url

 @param imageUrl image url
 */
- (void) setImageUrl: (NSString *)imageUrl;

/**
 根据Parallax 来调整横向视差

 @param Parallax CGFloat
 */
- (void) offsetHorizontalWithParallax:(CGFloat)Parallax;

/**
 根据Offset 来调整竖向视差

 @param Offset CGFloat
 */
- (void) offsetVerticalWithOffset: (CGFloat)Offset;
@end

@implementation GeCycleScrollViewItemCell {
    
    CGFloat _offset;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _offset = g_calculateConstant(0, self.bounds.size.width / 2.f, -self.bounds.size.width, self.bounds.size.width / 2.f + self.bounds.size.width * 0.9);
    self.contentView.layer.masksToBounds = YES;
    return self;
}

- (YYAnimatedImageView *)imageView {
    if (_imageView) return _imageView;
    
    _imageView = [[YYAnimatedImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_imageView];
    return _imageView;
}

- (void)setImage:(UIImage *)image {
    
    self.imageView.image = image;
}

- (void)setImageUrl:(NSString *)imageUrl {
    
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:imageUrl]
                       placeholder:nil
                           options:YYWebImageOptionSetImageWithFadeAnimation
                        completion:nil];
}

- (void)offsetHorizontalWithParallax:(CGFloat)Parallax {
    
    CGPoint point = [self convertPoint:CGPointZero toView:self.window];
    CGPoint center = self.imageView.center;
    center.x = -fabs(Parallax) * point.x + _offset;
    self.imageView.center = center;
}

- (void)offsetVerticalWithOffset:(CGFloat)Offset {
    
    CGRect frame = self.imageView.frame;
    frame.origin.y = Offset;
    self.imageView.frame = frame;
}
@end

@interface GeCycleScrollView() <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@end

@implementation GeCycleScrollView {
    
    UICollectionView * _collectionView;
    UICollectionViewFlowLayout * _flowLayout;
    NSTimer * _timer;
    BOOL _isDragging;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self p_g_commonInit];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self p_g_commonInit];
}

- (void)p_g_commonInit {
    
    _isDragging = NO;
    
    _scrollTimeInterval = 5;
    
    _scrollDirection = GeCycleScrollViewScrollDirectionHorizontal;
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[GeCycleScrollViewItemCell class] forCellWithReuseIdentifier:@"GeCycleScrollViewItemCell"];
    
    [self addSubview:_collectionView];
}

- (void)p_g_invalidateTimer {
    
    [_timer invalidate];
    _timer = nil;
}

- (void)p_g_startTimer {
    
    [self p_g_invalidateTimer];
    
    _timer = [NSTimer timerWithTimeInterval:_scrollTimeInterval target:[GeWeakProxy g_proxyWithTarget:self] selector:@selector(p_g_timerAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)p_g_timerAction {
    
    NSIndexPath *currentIndexPath = [[_collectionView indexPathsForVisibleItems] lastObject];
    
    NSInteger count = _imageUrls.count > 0 ? _imageUrls.count : _images.count;
    
    NSInteger newRow = currentIndexPath.item + 1;
    
    if (newRow >= count * 300) {
        newRow = (newRow % count) * 300;
    }
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    
    [_collectionView scrollToItemAtIndexPath:newIndexPath
                                atScrollPosition:(_scrollDirection == GeCycleScrollViewScrollDirectionHorizontal ?
                                                  UICollectionViewScrollPositionLeft :
                                                  UICollectionViewScrollPositionTop)
                                        animated:YES];
}

- (void)reloadData {
    
    _flowLayout.scrollDirection = (_scrollDirection == GeCycleScrollViewScrollDirectionHorizontal ?
                                   UICollectionViewScrollDirectionHorizontal :
                                   UICollectionViewScrollDirectionVertical);
    
    [_collectionView reloadData];
    
    NSInteger count = _imageUrls.count > 0 ? _imageUrls.count : _images.count;
    
    if (count > 0) {
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:count * 10 inSection:0]
                                atScrollPosition:(_scrollDirection == GeCycleScrollViewScrollDirectionHorizontal ?
                                                  UICollectionViewScrollPositionLeft :
                                                  UICollectionViewScrollPositionTop)
                                        animated:NO];
    }
    
    [self p_g_startTimer];
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(GeCycleScrollViewItemCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    _scrollDirection == GeCycleScrollViewScrollDirectionHorizontal ?
    [cell offsetHorizontalWithParallax:_parallax] :
    [cell offsetVerticalWithOffset:[cell convertPoint:cell.bounds.origin fromView:self].y * fabs(_parallax)];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(g_cycleScrollView:didSelectedIndex:)]) {
        [_delegate g_cycleScrollView:self didSelectedIndex:indexPath.item];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat parallax = _parallax;
    GeCycleScrollViewScrollDirection scrollDirection = _scrollDirection;
    [_collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof GeCycleScrollViewItemCell *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        scrollDirection == GeCycleScrollViewScrollDirectionHorizontal ?
        [obj offsetHorizontalWithParallax:parallax] :
        [obj offsetVerticalWithOffset:[obj convertPoint:obj.bounds.origin fromView:self].y * fabs(parallax)];
    }];
    
    NSInteger index = (_scrollDirection == GeCycleScrollViewScrollDirectionHorizontal ?
                       scrollView.contentOffset.x :
                       scrollView.contentOffset.y) / (_scrollDirection == GeCycleScrollViewScrollDirectionHorizontal ?
                                                      scrollView.bounds.size.width :
                                                      scrollView.bounds.size.height) + 0.5;
    
    if ([_delegate respondsToSelector:@selector(g_cycleScrollView:didScrollToIndex:)]) {
        [_delegate g_cycleScrollView:self didScrollToIndex:index];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self p_g_invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self p_g_startTimer];
}

#pragma mark -- UICollectionvViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = _imageUrls.count > 0 ? _imageUrls.count : _images.count;
    return count * 300;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GeCycleScrollViewItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GeCycleScrollViewItemCell" forIndexPath:indexPath];
    _imageUrls.count == 0 ?
    [cell setImage:_images[indexPath.item % _images.count]] :
    [cell  setImageUrl:_imageUrls[indexPath.item % _imageUrls.count]];
    return cell;
}
@end
