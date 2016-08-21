//
//  WTDetaiUserInfoController.m
//  环信demo
//
//  Created by GRIM on 16/8/11.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTDetaiUserInfoController.h"
#import "WTChatRoomController.h"
#import "WTTabBarController.h"

@interface WTDetaiUserInfoController ()
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation WTDetaiUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationItem.title = @"微信";
    self.username.text = self.buddy.username;
    [self addBtn];
}

//发消息按钮
- (void)addBtn{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    self.tableView.tableFooterView = footerView;
    
    UIButton *sendMsg = [[UIButton alloc]init];
    sendMsg.backgroundColor = [UIColor greenColor];
    sendMsg.frame = CGRectMake(30, 0, [UIScreen mainScreen].bounds.size.width - 60, 44);
    [sendMsg setTitle:@"发消息" forState:UIControlStateNormal];
    [sendMsg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMsg addTarget:self action:@selector(sendMsgbAction) forControlEvents:UIControlEventTouchUpInside];
    [sendMsg.layer setCornerRadius:5];
    sendMsg.layer.masksToBounds = YES;
    
    [footerView addSubview:sendMsg];
    
}

//发消息按钮响应事件
- (void)sendMsgbAction{
    
    //先回到通讯录
    [self.navigationController popViewControllerAnimated:NO];
    
    WTTabBarController *tabBarVc = (WTTabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    //跳转到'微信'界面,然后再push
    tabBarVc.selectedViewController = tabBarVc.viewControllers[0];
    
    WTChatRoomController *chatVc = [[WTChatRoomController alloc]init];
    chatVc.username = self.buddy.username;
    [(UINavigationController *)tabBarVc.viewControllers[0] pushViewController:chatVc animated:YES];
    
}
@end
