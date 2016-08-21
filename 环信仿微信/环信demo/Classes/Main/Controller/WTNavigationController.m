//
//  WTNavigationController.m
//  环信demo
//
//  Created by GRIM on 16/8/6.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTNavigationController.h"
#import "UINavigationBar+Awesome.h"

@interface WTNavigationController ()

@end

@implementation WTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
}


- (void)createUI{
    
    [self.navigationBar lt_setBackgroundColor:[UIColor blackColor]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    //设置NavigationBar文字的颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

//ios9之后用这个方法分别设置控制器状态栏的类型
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

@end
