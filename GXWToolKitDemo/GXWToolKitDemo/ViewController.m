//
//  ViewController.m
//  GXWToolKitDemo
//
//  Created by ym on 2017/6/28.
//  Copyright © 2017年 My. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Ge.h"
#import <objc/runtime.h>
#import "G_ProtocolProxy.h"
#import "G_CycleScrollView.h"
#import "SecondViewController.h"
#import "GeAlertController.h"

typedef void(^testBlock)(id, NSInteger);

struct TestStruct0 {
    
    NSInteger a;
    unsigned int b;
};
typedef struct TestStruct {
    NSInteger struct1;
    float struct2;
    unsigned int struct3;
    struct TestStruct0 struct4;
}TestStruct;

@protocol TestProtocol<NSObject>
@property unsigned int unsignedInt;
@property unsigned char unsignedShort;
@property (strong) testBlock block;
@property  TestStruct * structTest;
@property BOOL testBool;
@property Class testClass;
@property char * testChar;
@property SEL selector;
@property NSArray<NSString *> * testInts;
@property id(*voidxing)() ;
@property int* ints;
@end


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITextField * textField;
@property (nonatomic, weak) IBOutlet UITableView * tableView;

@property (nonatomic, weak) IBOutlet GeCycleScrollView * cycleScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
//    @encode(<#type-name#>)
    _tableView.tableFooterView = [UIView new];
    GeProtocolProxy * proxy = [GeProtocolProxy delegateProxyWithProtocol:@protocol(UITableViewDataSource)];
    static int datasource;
    [proxy associateToObject:self forKey:&datasource];
    [proxy addAction:^id(id sender, SEL sel, ...) {
        
        return @(10);
    } replaceSelector:@selector(tableView:numberOfRowsInSection:)];
//    [proxy addAction:^id(id sender, SEL sel, ...) {
//        return @(10);
//    } replaceSelector:@selector(tableView:heightForRowAtIndexPath:)];
    [proxy addAction:^id(id sender, SEL sel, ...) {
        
        UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        return cell;
    } replaceSelector:@selector(tableView:cellForRowAtIndexPath:)];
    
    _tableView.dataSource = proxy;
    
    unsigned int outCount = 0;
//    objc_property_t * propertyList = protocol_copyPropertyList(@protocol(TestProtocol), &outCount);
    objc_property_t * propertyList = protocol_copyPropertyList2(@protocol(TestProtocol), &outCount, YES, YES);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        [self importProperty:propertyList[index]];
    }

//    void(^size)(id) = ^(id a){};
//    NSLog(@"%lu", class_getInstanceSize([size class]));
//    int ints[] = {};
//    NSLog(@"%s", @encode(typeof(ints)));
//    NSLog(@"%s", @encode(typeof(int**)));
//    NSLog(@"%s", @encode(typeof(NSString **)));
//
//    static int const i = 0;
//    NSLog(@"%s", @encode(typeof(i)));
    
    struct objc_method_description * methodList = protocol_copyMethodDescriptionList(@protocol(UITableViewDataSource), YES, YES, &outCount);
    
    for (NSInteger index = 0; index < outCount; index ++) {
        
        NSLog(@"selector = %s, types = %s", sel_getName(methodList[index].name), methodList[index].types);
    }
    
    _cycleScrollView.imageUrls = @[@"http://img.wdjimg.com/image/video/d999011124c9ed55c2dd74e0ccee36ea_0_0.jpeg",
                                   @"http://img.wdjimg.com/image/video/2ddcad6dcc38c5ca88614b7c5543199a_0_0.jpeg",
                                   @"http://img.wdjimg.com/image/video/6d6ccfd79ee1deac2585150f40915c09_0_0.jpeg",
                                   @"http://img.wdjimg.com/image/video/2111a863ea34825012b0c5c9dec71843_0_0.jpeg",
                                   @"http://img.wdjimg.com/image/video/b4085a983cedd8a8b1e83ba2bd8ecdd8_0_0.jpeg",
                                   @"http://img.wdjimg.com/image/video/2d59165e816151350a2b683b656a270a_0_0.jpeg",
                                   @"http://img.wdjimg.com/image/video/dc2009ee59998039f795fbc7ac2f831f_0_0.jpeg"];
    _cycleScrollView.parallax = 0.5;
    _cycleScrollView.scrollDirection = GeCycleScrollViewScrollDirectionVertical;
    [_cycleScrollView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        SecondViewController * viewController = [[SecondViewController alloc] init];
//        viewController.hidesBottomBarWhenPushed = YES;
//        [self presentViewController:viewController animated:YES completion:nil];
    });
}

- (void)importProperty: (objc_property_t)property {
    
//    _name = [NSString stringWithUTF8String:property_getName(property)];
    
    unsigned int outCount = 0;
    objc_property_attribute_t * attributes = property_copyAttributeList(property, &outCount);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        objc_property_attribute_t attribute = attributes[index];
        
//        NSLog(@"%s attribute {\n Name = %s, \n Value = %s}", property_getName(property), attribute.name, attribute.value);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
}

- (void)p_handleTimer {
    
}

- (void)p_decode: (NSString *)encodeValue {
    
//    NSString * encodeString = encodeValue;
    
    NSMutableString * typeName = @"".mutableCopy;
    NSMutableString * typeValue = @"".mutableCopy;
    [encodeValue g_enumerateWithHandler:^(NSString *charator) {
      
        if ([charator isEqualToString:@"="]) {
            NSLog(@"typeName = %@", typeName);
        }
        
        if (![typeName containsString:@"="]) {
            [typeName appendString:charator];
        }
        else if ([charator isEqualToString:@"{"]) {
            /// 结构体开始
            [typeValue appendString:charator];
        }
        else if ([charator isEqualToString:@"}"]) {
            /// 结构体结束
            [typeValue appendString:charator];
            NSLog(@"struct = %@", typeValue);
        }
        else if ([charator isEqualToString:@"("]) {
            /// 联合开始
            [typeValue appendString:charator];
        }
        else if ([charator isEqualToString:@")"]) {
            /// 联合结束
            [typeValue appendString:charator];
            NSLog(@"union = %@", typeValue);
        }
        else if ([charator isEqualToString:@"["]) {
            /// 数组开始
            [typeValue appendString:charator];
        }
    }];
}

- (IBAction)touchButton:(id)sender {
    [self.textField resignFirstResponder];
    
    GeAlertController * controller = [GeAlertController alertControllerWithTitle:[[NSAttributedString alloc] initWithString:@"title"] message:[[NSAttributedString alloc] initWithString:@"message"] preferredStyle:UIAlertControllerStyleActionSheet];
    
    GeAction * action0 = [GeAction actionWithTitle:[[NSAttributedString alloc] initWithString:@"action0"] handler:^{
        NSLog(@"touch action0");
    }];
    
    GeAction * action1 = [GeAction actionWithTitle:[[NSAttributedString alloc] initWithString:@"action1"] handler:^{
        NSLog(@"touch action1");
    }];
    
    GeAction * action2 = [GeAction actionWithTitle:[[NSAttributedString alloc] initWithString:@"action2"] handler:^{
        NSLog(@"touch action2");
    }];
    
    [controller addActions:@[action0, action1, action2]];
    
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    return cell;
}

@end
