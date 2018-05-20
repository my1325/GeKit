//
//  SegmentListControl.m
//  YiYou
//
//  Created by m y on 2018/1/30.
//  Copyright © 2018年 m y. All rights reserved.
//

#import "G_SegmentListControl.h"

@interface GeSegmentListControlConfiguration: NSObject
@property (nonatomic, strong) NSMutableDictionary * stateBackgroundImages;
@property (nonatomic, strong) NSMutableDictionary * stateBackgroundColor;
@property (nonatomic, strong) NSMutableDictionary * stateTitleFont;
@property (nonatomic, strong) NSMutableDictionary * stateTitleColor;
@property (nonatomic, strong) NSMutableDictionary * stateAttributes;

- (void) setFont: (UIFont *)font forState: (UIControlState)state;

- (UIFont *) fontForState: (UIControlState)state;

- (void) setTextColor: (UIColor *)color forState: (UIControlState)state;

- (UIColor *) textColorForState: (UIControlState)state;

/**
 设置title的文字样式，会使
 - (void) setFont: (UIFont *)font forState: (UIControlState)state;
 
 - (void) setTextColor: (UIColor *)color forState: (UIControlState)state;
 无效
 @param attribute attribute
 @param state UIControlState
 */
- (void) setAttribute: (NSDictionary<NSAttributedStringKey, id> *)attribute forState: (UIControlState)state;

- (NSDictionary<NSAttributedStringKey, id> *) attributeForState: (UIControlState)state;

- (void) setBackgroundColor: (UIColor *)color forState: (UIControlState)state;

- (UIColor *) backgroundColorForState: (UIControlState)state;

/**
 设置背景图片，会使
 - (void) setBackgroundColor: (UIColor *)color forState: (UIControlState)state;
 无效
 
 @param image UIImage
 @param state UIControlState
 */
- (void) setBackgroundImage: (UIImage *)image forState: (UIControlState)state;

- (UIImage *) backgroundImageForState: (UIControlState)state;
@end

@implementation GeSegmentListControlConfiguration
- (instancetype)init {
    
    self = [super init];
    if (!self) return nil;
    
    _stateBackgroundImages = @{}.mutableCopy;
    _stateBackgroundColor = @{}.mutableCopy;
    _stateTitleFont = @{}.mutableCopy;
    _stateTitleColor = @{}.mutableCopy;
    _stateAttributes = @{}.mutableCopy;
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    _stateBackgroundColor[@(state)] = color;
}

- (UIColor *)backgroundColorForState:(UIControlState)state {
    return _stateBackgroundColor[@(state)];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    _stateBackgroundImages[@(state)] = image;
}

- (UIImage *)backgroundImageForState:(UIControlState)state {
    return _stateBackgroundImages[@(state)];
}

- (void)setFont:(UIFont *)font forState:(UIControlState)state {
    _stateTitleFont[@(state)] = font;
}

- (UIFont *)fontForState:(UIControlState)state {
    return _stateTitleFont[@(state)];
}

- (void)setTextColor:(UIColor *)color forState:(UIControlState)state {
    _stateTitleColor[@(state)] = color;
}

- (UIColor *)textColorForState:(UIControlState)state {
    return _stateTitleColor[@(state)];
}

- (void)setAttribute:(NSDictionary<NSAttributedStringKey,id> *)attribute forState:(UIControlState)state {
    _stateAttributes[@(state)] = attribute;
}

- (NSDictionary<NSAttributedStringKey,id> *)attributeForState:(UIControlState)state {
    return _stateAttributes[@(state)];
}
@end

@interface GeSegmentListControlCell: UICollectionViewCell

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * backgroundImageView;

@property (nonatomic, strong) UIView * containerView;

- (void) prepareForReloadWithTitle: (NSAttributedString *)title backgroundColor: (UIColor *)color backgroundImage: (UIImage *)image;

@end

@implementation GeSegmentListControlCell {
    
    NSString * _title;
}

- (UIView *)containerView {
    
    if (_containerView) return _containerView;
    
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:_containerView];
    return _containerView;
}

- (UILabel *)titleLabel {
    
    if (_titleLabel) return _titleLabel;
    
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:_titleLabel];
    
    return _titleLabel;
}

- (UIImageView *)backgroundImageView {
    
    if (_backgroundImageView) return _backgroundImageView;
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.containerView addSubview:_backgroundImageView];
    [self.containerView sendSubviewToBack:_backgroundImageView];
    return _backgroundImageView;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}

- (void)prepareForReloadWithTitle:(NSAttributedString *)title backgroundColor:(UIColor *)color backgroundImage:(UIImage *)image {
    
    _title = [title.string copy];
    self.titleLabel.attributedText = title;
    if (color) self.containerView.backgroundColor = color;
    if (image) self.backgroundImageView.image = image;
}
@end

@interface GeSegmentListControl()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@end

@implementation GeSegmentListControl {
    
    UIView * _contentView;
    UICollectionView * _collectionView;
    UICollectionView * _selectedCollectionView;
    UIView * _selectedContentView;
    UIView * _indicatorView;
    GeSegmentListControlConfiguration * _controlConfiguration;
    NSMutableDictionary * _cacheWidth;
}

- (instancetype)init { return [self initWithFrame:CGRectZero]; }

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self p_commonInit];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self p_commonInit];
}

- (void)p_commonInit {
    
    _controlConfiguration = [[GeSegmentListControlConfiguration alloc] init];
    
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _indicatorView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 20, 2}];
    _indicatorView.backgroundColor = [UIColor redColor];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout: layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.frame = self.bounds;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.bouncesZoom = NO;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[GeSegmentListControlCell class] forCellWithReuseIdentifier:@"GeSegmentListControlCell"];
    
    _selectedContentView = [[UIView alloc] initWithFrame:CGRectZero];
    _selectedContentView.clipsToBounds = YES;
    
    UICollectionViewFlowLayout * layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _selectedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout: layout1];
    _selectedCollectionView.delegate = self;
    _selectedCollectionView.dataSource = self;
    _selectedCollectionView.backgroundColor = [UIColor greenColor];
    _selectedCollectionView.backgroundColor = [UIColor clearColor];
    _selectedCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_selectedCollectionView registerClass:[GeSegmentListControlCell class] forCellWithReuseIdentifier:@"GeSegmentListControlCell"];
    
    [self addSubview:_contentView];
    [_contentView addSubview:_collectionView];
    [_collectionView addSubview:_selectedContentView];
    [_selectedContentView addSubview:_selectedCollectionView];
    [_selectedContentView addSubview:_indicatorView];
    
    _cacheWidth = @{}.mutableCopy;
    
    _selectedIndex = 0;
    _margin = (UIEdgeInsets){0, 0, 0, 0};
    _itemMinimumSpacing = 10;
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)reloadData {
    [_cacheWidth removeAllObjects];
    [self p_caculateItemWidth];
    [_selectedCollectionView reloadData];
    [_collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setSelectedIndex:_selectedIndex animated:NO];
        [self p_changeIndicatorToIndex:_selectedIndex animated:NO];
    });
}

- (void)p_caculateItemWidth {
    
    NSInteger count = 0;
    CGFloat totalWidth = 0;
    if ([_dataSource respondsToSelector:@selector(g_numOfItemsInSegmentListControl:)]) {
        count = [_dataSource g_numOfItemsInSegmentListControl:self];
    }
    
    for (NSInteger index = 0; index < count; index ++) {
        
        NSString * key = NSStringFromRange(NSMakeRange(0, index));

        CGFloat width = 0;
        if ([_delegate respondsToSelector:@selector(g_segmentListControl:widthForSegmentAtIndex:)]) {
            width = [_delegate g_segmentListControl:self widthForSegmentAtIndex:index];
        }
        else if ([_dataSource respondsToSelector:@selector(g_segmentListControl:titleAtIndex:)]) {
            
            NSString * title = [_dataSource g_segmentListControl:self titleAtIndex:index];
            CGRect rect = [title boundingRectWithSize: (CGSize){MAXFLOAT, self.bounds.size.height}
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:[self p_attributeForSelected]
                                              context:nil];
            width = rect.size.width;
        }
        if (index == 0 || index == count - 1) _cacheWidth[key] = @(roundf(width + _itemMinimumSpacing / 2));
        else _cacheWidth[key] = @(roundf(width + _itemMinimumSpacing));
        
        totalWidth += [_cacheWidth[key] floatValue];
    }
    
    [self p_checkWidthWithTotalWidth:totalWidth count:count];
}

- (void)p_checkWidthWithTotalWidth: (CGFloat)totalWidth count: (NSInteger)count {
    
    CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, self.bounds.size.width);
    /// 如果是用户自定义的宽度或者总宽度加起来已经超过self的宽度则不处理
    if ([_delegate respondsToSelector:@selector(g_segmentListControl:widthForSegmentAtIndex:)] || totalWidth > width) return;
    
    for (NSString * key in _cacheWidth.allKeys) {
        _cacheWidth[key] = @(width / count);
    }
}

- (NSDictionary<NSAttributedStringKey, id> *)p_attributeForNormal {
    
    NSMutableDictionary * attributes = @{}.mutableCopy;

    NSDictionary * normalAttributes = [_controlConfiguration attributeForState:UIControlStateNormal];
    
    if (normalAttributes.count == 0) {
        
        UIFont * font = [_controlConfiguration fontForState:UIControlStateNormal];
        UIColor * color = [_controlConfiguration textColorForState:UIControlStateNormal];
        
        if (font) { attributes[NSFontAttributeName] = font; }
        if (color) { attributes[NSForegroundColorAttributeName] = color; }
    }
    else {
        attributes = [NSMutableDictionary dictionaryWithDictionary:normalAttributes];
    }
    
    if (attributes.count == 0) attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17],
                                              NSForegroundColorAttributeName: [UIColor blackColor]}.mutableCopy;

    return attributes;
}

- (NSDictionary<NSAttributedStringKey, id> *)p_attributeForSelected {
    
    NSMutableDictionary * attributes = @{}.mutableCopy;

    NSDictionary * selectedAttributes = [_controlConfiguration attributeForState:UIControlStateSelected];
    if (selectedAttributes.count == 0) {
        
        UIFont * font = [_controlConfiguration fontForState:UIControlStateSelected];
        UIColor * color = [_controlConfiguration textColorForState:UIControlStateSelected];
        
        if (font) { attributes[NSFontAttributeName] = font; }
        if (color) { attributes[NSForegroundColorAttributeName] = color; }
    }
    else {
        attributes = [NSMutableDictionary dictionaryWithDictionary:selectedAttributes];
    }
    
    if (attributes.count == 0) attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17],
                                              NSForegroundColorAttributeName: [UIColor blackColor]}.mutableCopy;

    return attributes;
}

- (UIColor *)p_backgroundColorForNormal {
    return [_controlConfiguration backgroundColorForState:UIControlStateNormal];
}

- (UIColor *)p_backgroundColorForSeleceted {
    return [_controlConfiguration backgroundColorForState:UIControlStateSelected];
}

- (UIImage *)p_backgroundImageForNormal {
    return [_controlConfiguration backgroundImageForState:UIControlStateNormal];
}

- (UIImage *)p_backgroundImageForSelected {
    return [_controlConfiguration backgroundImageForState:UIControlStateSelected];
}

- (void)p_changeIndicatorToIndex: (NSInteger) index animated: (BOOL)animated {
    
    [_collectionView bringSubviewToFront:_contentView];
    
    CGSize size = (CGSize){[_cacheWidth[NSStringFromRange(NSMakeRange(0, index))] floatValue], _collectionView.bounds.size.height};
    
    UICollectionViewCell * cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    CGRect frame = cell.frame;
    
    CGRect _contentViewFrame = (CGRect){ frame.origin.x + (frame.size.width / 2 - size.width / 2), 0, size.width, size.height};
    
    CGSize _indicatorSize = (CGSize){[_cacheWidth[NSStringFromRange(NSMakeRange(0, index))] floatValue], 4};
    if ([_delegate respondsToSelector:@selector(g_segmentListControl:bottomIndicatorSizeAtIndex:)]) {
        _indicatorSize = [_delegate g_segmentListControl:self bottomIndicatorSizeAtIndex:index];
    }
    
    CGRect _indicatoryFrame = (CGRect){0, _contentViewFrame.size.height - _indicatorSize.height / 2, _indicatorSize.width, _indicatorSize.height};
    
    CGRect _selectedCollectionViewFrame = (CGRect){-frame.origin.x, 0, _collectionView.contentSize.width, _collectionView.contentSize.height};
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            _selectedContentView.frame = _contentViewFrame;
//            _selectedContentView.frame = self.bounds;
            _indicatorView.frame = _indicatoryFrame;
            _selectedCollectionView.frame = _selectedCollectionViewFrame;
        }];
    }
    else {
        _selectedContentView.frame = _contentViewFrame;
        _indicatorView.frame = _indicatoryFrame;
        _selectedCollectionView.frame = _selectedCollectionViewFrame;
    }
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    [_controlConfiguration setBackgroundColor:color forState:state];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [_controlConfiguration setBackgroundImage:image forState:state];
}

- (void)setFont:(UIFont *)font forState:(UIControlState)state {
    [_controlConfiguration setFont:font forState:state];
}

- (void)setTextColor:(UIColor *)color forState:(UIControlState)state {
    [_controlConfiguration setTextColor:color forState:state];
}

- (void)setAttribute:(NSDictionary<NSAttributedStringKey,id> *)attribute forState:(UIControlState)state {
    [_controlConfiguration setAttribute:attribute forState:state];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    
    _selectedIndex = index;
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:animated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self p_changeIndicatorToIndex:index animated:animated];
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([_cacheWidth[NSStringFromRange(NSMakeRange(indexPath.section, indexPath.item))] floatValue], self.bounds.size.height - _margin.top - _margin.bottom);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return (UIEdgeInsets){0, _margin.left, 0, _margin.right};
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_collectionView == collectionView) {
        if ([_delegate respondsToSelector:@selector(g_segmentListControl:didSelectedAtIndex:)]) {
            [_delegate g_segmentListControl:self didSelectedAtIndex:indexPath.item];
        }
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self p_changeIndicatorToIndex:indexPath.item animated:YES];
    }
}

#pragma mark - UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_dataSource respondsToSelector:@selector(g_numOfItemsInSegmentListControl:)]) {
        return [_dataSource g_numOfItemsInSegmentListControl:self];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == _collectionView) {
        GeSegmentListControlCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GeSegmentListControlCell" forIndexPath:indexPath];
        NSString * title = @"";
        if ([_dataSource respondsToSelector:@selector(g_segmentListControl:titleAtIndex:)]) {
            title = [_dataSource g_segmentListControl:self titleAtIndex:indexPath.item];
        }
        [cell prepareForReloadWithTitle:[[NSAttributedString alloc] initWithString:title attributes:[self p_attributeForNormal]]
                        backgroundColor:[self p_backgroundColorForNormal]
                        backgroundImage:[self p_backgroundImageForNormal]];
        return cell;
    }
    else {
        
        GeSegmentListControlCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GeSegmentListControlCell" forIndexPath:indexPath];
        NSString * title = @"";
        if ([_dataSource respondsToSelector:@selector(g_segmentListControl:titleAtIndex:)]) {
            title = [_dataSource g_segmentListControl:self titleAtIndex:indexPath.item];
        }
        [cell prepareForReloadWithTitle:[[NSAttributedString alloc] initWithString:title attributes:[self p_attributeForSelected]]
                        backgroundColor:[self p_backgroundColorForSeleceted]
                        backgroundImage:[self p_backgroundImageForSelected]];
        return cell;
    }
}
@end
