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
@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, weak) IBOutlet UITextField * textField;
@property (nonatomic, weak) IBOutlet UITableView * tableView;
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
}

- (void)importProperty: (objc_property_t)property {
    
//    _name = [NSString stringWithUTF8String:property_getName(property)];
    
    unsigned int outCount = 0;
    objc_property_attribute_t * attributes = property_copyAttributeList(property, &outCount);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        objc_property_attribute_t attribute = attributes[index];
        
//        NSLog(@"%s attribute {\n Name = %s, \n Value = %s}", property_getName(property), attribute.name, attribute.value);
    }
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
