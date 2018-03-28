//
//  SecondViewController.m
//  GXWToolKitDemo
//
//  Created by m y on 2018/3/27.
//  Copyright © 2018年 My. All rights reserved.
//

#import "SecondViewController.h"
#import "G_WeakProxy.h"
#import "UIButton+Ge.h"

@interface SecondViewController ()<GeCountDelegate>
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) UIButton * button;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(p_customBack)];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = (CGRect){100, 100, 100, 40};
    [self.view addSubview:_button];
    [_button g_addCountDelegate:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.button g_startCount];
    });
}

- (void)g_button:(UIButton *)button didCount:(NSInteger)count {
    [button setTitle:[NSString stringWithFormat:@"%ld", (long)count] forState:UIControlStateNormal];
}

- (void)p_customBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)p_handleTimer {
    static NSInteger count = 0;
    
    NSLog(@"%ld", (long)count);
    
    count ++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [_timer invalidate];
    [_button g_resetCount];
    NSLog(@"dealloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
