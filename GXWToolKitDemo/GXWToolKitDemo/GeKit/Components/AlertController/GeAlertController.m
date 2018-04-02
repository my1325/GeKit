//
//  GeAlertController.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/29.
//  Copyright © 2018年 My. All rights reserved.
//

#import "GeAlertController.h"
#import "UIView+Ge.h"
#import "UIColor+Ge.h"

@interface GeAction ()
@property (nonatomic, strong) NSAttributedString * title;
@property (nonatomic, strong) void(^handler)(void);
@end

@implementation GeAction

+ (instancetype)actionWithTitle:(NSAttributedString *)title handler:(void (^)(void))handler {
    return [[self alloc] initWithTitle:title handler:handler];
}

- (instancetype)initWithTitle: (NSAttributedString *)title handler: (void(^)(void))handler {
    self = [super init];
    if (!self) return nil;
    _title = title.copy;
    _handler = [handler copy];
    return self;
}

@end



@interface GeAlertView : UIView

- (void)addTextFiled: (UITextField *)textFiled;

- (void)addActions: (NSArray<GeAction *> *)actions;

- (void)addTitle: (NSAttributedString *)title;

- (void)addMessage: (NSAttributedString *)message;

- (CGFloat)caculateHeight;

- (void)addCustomView: (UIView *)customView;
@end

@implementation GeAlertView {
    UILabel * _titleLabel;
    UILabel * _messageLabel;
    NSAttributedString * _title;
    NSAttributedString * _message;
    NSMutableArray<GeAction *> * _actions;
    NSMutableArray<UIButton *> * _buttons;
    NSMutableArray<UITextField *> * _textFileds;
    NSMutableArray<UIView *> * _buttonSep;
    UIView * _bottomSep;
    UIView * _customView;
}

- (void)addTitle:(NSAttributedString *)title {
    if (_customView) return;
    _title = title.copy;
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor g_colorWithHex:0x333333];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
    }
    _titleLabel.frame = (CGRect){0, 0, self.g_width, _title.length > 0 ? 60 : 0};
    _titleLabel.attributedText = title.copy;
}

- (void)addMessage:(NSAttributedString *)message {
    if (_customView) return;
    _message = message.copy;
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:13];
        _messageLabel.textColor = [UIColor g_colorWithHex:0x666666];
        _messageLabel.numberOfLines = 2;
        _messageLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_messageLabel];
    }
    _messageLabel.frame = (CGRect){0, 0, self.g_width, _message.length > 0 ? 50 : 0};
    _messageLabel.attributedText = message.copy;
}

- (void)addActions:(NSArray<GeAction *> *)actions {
    if (_customView) return;

    if (!_buttons) {
        _buttons = @[].mutableCopy;
        _actions = @[].mutableCopy;
        _buttonSep = @[].mutableCopy;
    }
    [_actions addObjectsFromArray:actions];
    for (GeAction * action in actions) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        /// index 必须是在_actions 中,创建是从actions新创建的，否则会引起tag重复
        button.tag = [_actions indexOfObject:action] + 10000;
        [button setAttributedTitle:action.title.copy forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p_handleButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttons addObject:button];
        
        if (_actions.count == actions.count && [actions indexOfObject:action] > 0) {
            UIView * sep = [[UIView alloc] init];
            sep.backgroundColor = [UIColor g_colorWithHex:0xe8e8e8];
            [_buttonSep addObject:sep];
            [self addSubview:sep];
        }
        else if (_actions.count > actions.count) {
            UIView * sep = [[UIView alloc] init];
            sep.backgroundColor = [UIColor g_colorWithHex:0xe8e8e8];
            [_buttonSep addObject:sep];
            [self addSubview:sep];
        }
    }
    
    _bottomSep = [[UIView alloc] init];
    _bottomSep.backgroundColor = [UIColor g_colorWithHex:0xe8e8e8];
    [self addSubview:_bottomSep];
}

- (void)addTextFiled:(UITextField *)textFiled {
    if (_customView) return;
    if (!_textFileds) {
        _textFileds = @[].mutableCopy;
    }
    [_textFileds addObject:textFiled];
    [self addSubview:textFiled];
}

- (void)addCustomView:(UIView *)customView {
    _customView = customView;
    _title = nil;
    _message = nil;
    _titleLabel = nil;
    _messageLabel = nil;
    [_textFileds removeAllObjects];
    [_buttons removeAllObjects];
    [_actions removeAllObjects];
    [self g_removeAllSubviews];
    [self addCustomView:_customView];
}

- (CGFloat)caculateHeight {
    CGFloat _height = 0;
    if (_customView) {
        _height = _customView.g_height;
        return _height;
    }
    
    if (_title.length > 0) _height += 60;
    if (_message.length > 0) _height += 50;
    if (_buttons.count > 0) _height += 50 + 1.0 / [UIScreen mainScreen].scale;
    if (_textFileds.count > 0) _height += _textFileds.count * 60;
    
    return _height + 10;
}

#pragma mark - action
- (void)p_handleButtonTouch: (UIButton *)button {
    NSInteger index = button.tag - 10000;
    GeAction * action = _actions[index];
    if (action.handler) action.handler();
}

#pragma mark - layout
- (void)layoutSubviews {
    
    if (_customView) {
        _customView.frame = self.bounds;
        return;
    }
    
    CGFloat heightOffset = 0;
    _titleLabel.frame = (CGRect){0, heightOffset, self.g_width, _titleLabel.g_height};
    heightOffset += _titleLabel.g_height;
    _messageLabel.frame = (CGRect){0, heightOffset, self.g_width, _messageLabel.g_height};
    heightOffset += _messageLabel.g_height;
    
    for (UITextField * textField in _textFileds) {
        textField.frame = (CGRect){20, heightOffset + 10, self.g_width -40, 40};
        heightOffset += 60;
    }
    
    _bottomSep.frame = (CGRect){0, heightOffset + 10, self.g_width, 1.0 / [UIScreen mainScreen].scale};
    heightOffset += _bottomSep.g_height + 10;

    CGFloat buttonWidth = self.g_width * 1.0 / _buttons.count;
    for (UIButton * button in _buttons) {
        NSInteger index = [_buttons indexOfObject:button];

        button.frame = (CGRect){buttonWidth * index, heightOffset, buttonWidth, 50};
        
        if (index < _buttons.count - 1) {
            UIView * sep = _buttonSep[index];
            sep.frame = (CGRect){buttonWidth * (index + 1), heightOffset, 1.0 / [UIScreen mainScreen].scale, 50};
        }
    }
}
@end

@interface GeActionSheetTitleCell: UITableViewCell
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * messageLabel;
@end

@implementation GeActionSheetTitleCell
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor g_colorWithHex:0x333333];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:13];
        _messageLabel.textColor = [UIColor g_colorWithHex:0x666666];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (void)layoutSubviews {
    CGFloat heightOffset = 0;
    _titleLabel.frame = (CGRect){0, 0, self.g_width, 60};
    heightOffset += _titleLabel.g_height;
    _messageLabel.frame = (CGRect){0, heightOffset, self.g_width, 50};
}
@end

@interface GeActionSheetCell: UITableViewCell
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation GeActionSheetCell {
    UIView * _lineView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor g_colorWithHex:0xe8e8e8];
        [self.contentView addSubview:_lineView];
    }
    return _titleLabel;
}

- (void)layoutSubviews {
    _titleLabel.frame = self.bounds;
    _lineView.frame = (CGRect){0, 1.0 / [UIScreen mainScreen].scale, self.g_width, 1 / [UIScreen mainScreen].scale};
}
@end

@interface GeActionSheetView: UIView<UITableViewDelegate, UITableViewDataSource>

- (void)addTitle: (NSAttributedString * )title;

- (void)addMessage: (NSAttributedString *)message;

- (void)addActions: (NSArray<GeAction *> *)actions;

- (void)addCustomView: (UIView *)customView;

- (CGFloat)caculateHeight;

- (void)reloadData;
@end

@implementation GeActionSheetView {
    NSMutableArray<GeAction *> * _actions;
    UIView * _customView;
    NSAttributedString * _title;
    NSAttributedString * _message;
    UITableView * _tableView;
}

- (void)reloadData {
    [_tableView reloadData];
}

- (void)addActions:(NSArray<GeAction *> *)actions {
    if (_customView) return;
    
    if (!_actions) {
        _actions = @[].mutableCopy;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.layoutMargins = (UIEdgeInsets){0, 0, 0, 0};
        [_tableView registerClass:[GeActionSheetCell class] forCellReuseIdentifier:@"GeActionSheetCell"];
        [_tableView registerClass:[GeActionSheetTitleCell class] forCellReuseIdentifier:@"GeActionSheetTitleCell"];
        [self addSubview:_tableView];
    }
    
    [_actions addObjectsFromArray:actions];
}

- (void)addCustomView:(UIView *)customView {
    _customView = customView;
    _title = nil;
    _message = nil;
    [_actions removeAllObjects];
    [self g_removeAllSubviews];
    [self addSubview:_customView];
}

- (void)addTitle:(NSAttributedString *)title {
    if (_customView) return;
    _title = title.copy;
}

- (void)addMessage:(NSAttributedString *)message {
    if (_customView) return;
    _message = message.copy;
}

- (void)layoutSubviews {
    if (_customView) {
        _customView.frame = self.bounds;
        return;
    }
    _tableView.frame = self.bounds;
}

- (CGFloat)caculateHeight {
    if (_customView) return _customView.g_height;
    
    CGFloat _height = 0;
    if (_title.length > 0) _height += 60;
    if (_message.length > 0) _height += 50;
    if (_actions.count > 0) _height += _actions.count * 44;
    return _height;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) { return; }
    GeAction * action = _actions[indexPath.row - 1];
    if (action.handler) action.handler();
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        CGFloat _height = 0.000001;
        if (_title.length > 0) _height += 60;
        if (_message.length > 0) _height += 50;
        return _height;
    }
    else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _actions.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        GeActionSheetTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GeActionSheetTitleCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_title.length > 0) {
            cell.titleLabel.attributedText = _title.copy;
        }
        if (_message.length > 0) {
            cell.messageLabel.attributedText = _message.copy;
        }
        return cell;
    }
    else {
        GeActionSheetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GeActionSheetCell"];
        cell.titleLabel.attributedText = _actions[indexPath.row - 1].title.copy;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
@end

@interface GeAlertController ()
/// total
@property (nonatomic, assign) UIAlertControllerStyle style;
@property (nonatomic, strong) UIView * contentView;
/// 普通样式
@property (nonatomic, strong) NSAttributedString * alertTitle;
@property (nonatomic, strong) NSAttributedString * message;
@property (nonatomic, strong) NSMutableArray<GeAction *> * actions;
/// textField
@property (nonatomic, strong) NSMutableArray<UITextField *> * textFields;
/// customView
@property (nonatomic, strong) UIView * customView;
/// alertView
@property (nonatomic, strong) GeAlertView * alertView;
/// actionSheet
@property (nonatomic, strong) GeActionSheetView * actionSheetView;
@end

@implementation GeAlertController
#pragma mark - initialize
+ (instancetype)alertControllerWithCustomView:(UIView *)customView
                               preferredStyle:(UIAlertControllerStyle)preferredStyle {
    return [[self alloc] initWithCustomView:customView preferredStyle:preferredStyle];
}

+ (instancetype)alertControllerWithTitle:(NSAttributedString *)title
                                 message:(NSAttributedString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle {
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (instancetype)initWithCustomView: (UIView *)customView
                                       preferredStyle:(UIAlertControllerStyle)preferredStyle {
    self = [super init];
    if (!self) return nil;
    
    _customView = customView;
    _style = preferredStyle;
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationCustom;
    if (preferredStyle == UIAlertControllerStyleAlert) {
        _alertView = [[GeAlertView alloc] init];
        _alertView.layer.cornerRadius = 8;
        _alertView.clipsToBounds = YES;
    }
    else {
        _actionSheetView = [[GeActionSheetView alloc] init];
    }
    return self;
}

- (instancetype)initWithTitle: (NSAttributedString *)title
                      message: (NSAttributedString *)message
               preferredStyle:(UIAlertControllerStyle)preferredStyle {
    self = [super init];
    if (!self) return nil;
    
    _alertTitle = title.copy;
    _message = message.copy;
    _style = preferredStyle;
    _actions = @[].mutableCopy;
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationCustom;
    if (preferredStyle == UIAlertControllerStyleAlert) {
        _textFields = @[].mutableCopy;
        _alertView = [[GeAlertView alloc] init];
    }
    else {
        _actionSheetView = [[GeActionSheetView alloc] init];
    }
    
    return self;
}

- (void)addAction:(GeAction *)action {
    [_actions addObject:action];
}

- (void)addActions:(NSArray<GeAction *> *)actions {
    [_actions addObjectsFromArray:actions];
}

- (void)removeAllActions {
    [_actions removeAllObjects];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *))configurationHandler {
    if (_style == UIAlertControllerStyleAlert) {
        UITextField * textFiled = [[UITextField alloc] init];
        textFiled.borderStyle = UITextBorderStyleNone;
        textFiled.layer.borderColor = [UIColor g_colorWithHex:0xe8e8e8].CGColor;
        textFiled.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        textFiled.layer.cornerRadius = 4;
        
        UIView * leftView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 5, 10}];
        leftView.backgroundColor = [UIColor clearColor];
        textFiled.leftView = leftView;
        textFiled.leftViewMode = UITextFieldViewModeAlways;
        
        [_textFields addObject:textFiled];
        [_alertView addTextFiled:textFiled];
        if (configurationHandler) configurationHandler(textFiled);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    [self.view addSubview:_contentView];
    if (_style == UIAlertControllerStyleAlert) {
        _alertView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_alertView];
        if (_customView) {
            [_alertView addCustomView:_customView];
        }
        else {
            _alertView.backgroundColor = [UIColor whiteColor];
            [_alertView addTitle:_alertTitle];
            [_alertView addMessage:_message];
            [_alertView addActions:_actions];
            _alertView.layer.cornerRadius = 4;
            _alertView.layer.masksToBounds = YES;
            _contentView.layer.shadowOffset = (CGSize){2, 2};
            _contentView.layer.shadowColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.25].CGColor;
            _contentView.layer.shadowOpacity = 0.35;
        }
    }
    else {
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_actionSheetView];
        if (_customView) {
            [_actionSheetView addCustomView:_customView];
        }
        else {
            [_actionSheetView addTitle:_alertTitle];
            [_actionSheetView addMessage:_message];
            [_actionSheetView addActions:_actions];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_style == UIAlertControllerStyleAlert) {
        CGFloat height = [_alertView caculateHeight];
        _contentView.bounds = (CGRect){0, 0, self.view.g_width - 30, height};
        _contentView.center = (CGPoint){CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)};
        _alertView.frame = _contentView.bounds;
        [self p_showAlert];
    }
    else {
        CGFloat height = [_actionSheetView caculateHeight];
        _contentView.frame = (CGRect){0, self.view.g_height - height, self.view.g_width, height};
        _actionSheetView.frame = _contentView.bounds;
        [self p_showActionSheet];
    }
}

- (void)p_showAlert {
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1), @(0.7), @(0.9), @(1.3), @(1.1), @(1.0)];
    animation.keyTimes = @[@(0.0), @(0.3), @(0.5), @(0.7), @(0.9), @(1.0)];
    animation.duration = 0.15;
    
    [_contentView.layer addAnimation:animation forKey:nil];
}

- (void)p_showActionSheet {
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, _contentView.g_height, 0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
    animation.duration = 0.15;
    
    [_contentView.layer addAnimation:animation forKey:nil];
}
@end
