//
//  ViewController.m
//  GXWToolKitDemo
//
//  Created by ym on 2017/6/28.
//  Copyright © 2017年 My. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

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
    
//    @encode(<#type-name#>)
    unsigned int outCount = 0;
//    objc_property_t * propertyList = protocol_copyPropertyList(@protocol(TestProtocol), &outCount);
    objc_property_t * propertyList = protocol_copyPropertyList2(@protocol(TestProtocol), &outCount, YES, YES);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        [self importProperty:propertyList[index]];
    }
    
    int ints[] = {};
    NSLog(@"%s", @encode(typeof(ints)));
    NSLog(@"%s", @encode(typeof(int**)));
    NSLog(@"%s", @encode(typeof(NSString **)));
    
    static int const i = 0;
    NSLog(@"%s", @encode(typeof(i)));
}

- (void)importProperty: (objc_property_t)property {
    
//    _name = [NSString stringWithUTF8String:property_getName(property)];
    
    unsigned int outCount = 0;
    objc_property_attribute_t * attributes = property_copyAttributeList(property, &outCount);
    
    for (unsigned int index = 0; index < outCount; index ++) {
        
        objc_property_attribute_t attribute = attributes[index];
        
        NSLog(@"%s attribute {\n Name = %s, \n Value = %s}", property_getName(property), attribute.name, attribute.value);
    }
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
