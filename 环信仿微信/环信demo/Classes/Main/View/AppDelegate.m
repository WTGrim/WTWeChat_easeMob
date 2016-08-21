//
//  AppDelegate.m
//  环信demo
//
//  Created by GRIM on 16/8/5.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "AppDelegate.h"
#import "WTTabBarController.h"
#import "WTLoginRegisterController.h"

#define EaseMobAppKey @"forkingdog#myeasemob"

@interface AppDelegate ()<EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //这段时间显示启动图
    sleep(2);
    
    //1.注册AppKey
    [[EaseMob sharedInstance] registerSDKWithAppKey:EaseMobAppKey
                                       apnsCertName:nil
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:@NO}];
    //2.跟踪生命周期
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //3.添加监听代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //4.判断是否是自动登录，如果是自动登录的，那么直接切换到根控制器
    if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        //现在正在自动登录
        [SVProgressHUD showWithStatus:@"正在自动登录中..."];

    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[EaseMob sharedInstance]applicationWillResignActive:application];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EaseMob sharedInstance]applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  
    [[EaseMob sharedInstance]applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[EaseMob sharedInstance]applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance]applicationWillTerminate:application];
    //移除代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    
}

#pragma mark - 自动登录是否成功
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    
    [SVProgressHUD dismiss];
    if (!error) {
        
        //切换根控制器
        WTTabBarController *tabBarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:NSStringFromClass([WTTabBarController class])];
        self.window.rootViewController = tabBarVC;
        
    }else{
        
        [JDStatusBarNotification showWithStatus:error.description dismissAfter:2.0];
    }
    
}




#pragma mark - 自动重连
//环信在断开连接之后会自动重连

//将要发起重连
- (void)willAutoReconnect{
    
    NSLog(@"将要自动重连");
}
- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    
    if(!error){
        
        NSLog(@"自动重连成功");
    }
    
}


#pragma mark - 被动退出的回调
- (void)didLoginFromOtherDevice{
    
    [self passivedLogoff];
    
}

- (void)didRemovedFromServer{
    
    [self passivedLogoff];
    
}

- (void)passivedLogoff{
    
    // 退出，传入YES，会解除device token绑定，不再收到群消息；传NO，不解除device token
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        
        if (!error) {
            
            //切换根控制器
            self.window.rootViewController = [WTLoginRegisterController wt_loginRegister];
            NSLog(@"被动退出登录");
        }else{
            
            NSLog(@"被动退出失败");
        }
        
    } onQueue:nil];
}
@end
