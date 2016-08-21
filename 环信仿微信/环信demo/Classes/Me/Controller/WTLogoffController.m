//
//  WTLogoffController.m
//  环信demo
//
//  Created by GRIM on 16/8/6.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTLogoffController.h"
#import "WTLoginRegisterController.h"

@interface WTLogoffController ()

@end

@implementation WTLogoffController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (IBAction)logoff:(UIButton *)sender {
    
    /**
     *  异步退出
     *
     *  @param BOOL 主动退出传YES，被动退出（在其他设备上登录、被服务器移除）传NO；
     *
     *  @return <#return value description#>
     */
    
    // 退出，传入YES，会解除device token绑定，不再收到群消息；传NO，不解除device token
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        
        if (!error) {
            
            //1.保存用户名（为了在用户重新登录的时候显示用户名）
            [[NSUserDefaults standardUserDefaults]setObject:[[EaseMob sharedInstance].chatManager loginInfo][@"username"] forKey:@"username"];
            
            //2.返回到'我'控制器
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [WTLoginRegisterController wt_loginRegister];
            
            NSLog(@"退出登录成功");
        }
        
    } onQueue:nil];
}

@end
