//
//  WTTabBarController.m
//  环信demo
//
//  Created by GRIM on 16/8/6.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTTabBarController.h"
#import "WTContactController.h"

@interface WTTabBarController ()<EMChatManagerDelegate>

@end

@implementation WTTabBarController

+ (void)initialize{
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    UIColor *selectColor = [UIColor colorWithRed:0 green:190 / 255.0 blue:12 / 255.0 alpha:1];
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:selectColor} forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //添加代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

//接受到好友请求,改变badgeValue
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    
    //改变badgeValue
    [self changBadgeValue];
    
    //弹窗提示
    [self addFriendsTip:username message:message];
    

}

- (void)changBadgeValue{
    
    //拿到contactVc
    WTContactController *contactVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:NSStringFromClass([WTContactController class])];
    
    NSInteger badgeValue = contactVc.navigationController.tabBarItem.badgeValue.integerValue;
    badgeValue = badgeValue + 1;
    contactVc.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd", badgeValue];
    
}

//弹窗提示是否添加好友
- (void)addFriendsTip:(NSString *)username message:(NSString *)message{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"好友申请" message:[NSString stringWithFormat:@"%@想加您为好友  申请备注:%@", username, message] preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self)weakSelf = self;
    [alertVc addAction:[UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //接受好友请求
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
        if (!error) {
            //跳转到通讯录控制器
            weakSelf.selectedViewController = self.viewControllers[1];
            
            //刷新通讯录
            
        }
        
    }]];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //告诉环信拒绝请求
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"不认识" error:&error];
        if (!error) {
            
            NSLog(@"拒绝成功");
        }
    }]];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

@end
