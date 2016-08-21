//
//  ViewController.m
//  环信demo
//
//  Created by GRIM on 16/8/5.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTLoginRegisterController.h"
#import "WTTabBarController.h"


@interface WTLoginRegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

@end

@implementation WTLoginRegisterController

+ (instancetype)wt_loginRegister{
    
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backgroundColor243;
    //退出登录时显示用户名，因为是异步登录可能没法正常显示
    self.userName.text = [[NSUserDefaults standardUserDefaults]valueForKeyPath:@"username"];
    
    
}


- (IBAction)register:(UIButton *)sender {
    
    [self test2];
    
    
}

////使用同步方法注册
//- (void)test1{
//    
//    EMError *error = nil;
//    [[EaseMob sharedInstance].chatManager registerNewAccount:self.userName.text password:self.pwd.text error:&error];
//    
//    if(!error){
//        
//        NSLog(@"注册成功");
//    }else{
//        
//        NSLog(@"注册失败%@", error);
//    }
//}

//使用block异步注册(推荐使用)
- (void)test2{
    
    [SVProgressHUD showWithStatus:@"注册中..."];
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.userName.text password:self.pwd.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            NSLog(@"注册成功");
            [JDStatusBarNotification showWithStatus:@"注册成功,请点击登录" dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
        }else{
            [SVProgressHUD dismiss];
            [JDStatusBarNotification showWithStatus:@"注册失败" dismissAfter:2.0 styleName:JDStatusBarStyleError];
        }

        
    } onQueue:nil];
}

////使用代理方法注册
//- (void)test3{
//    
//    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.userName.text password:self.pwd.text];
//    
//}

////移除代理
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//    
//}
//#pragma mark - 使用代理注册的回调
//- (void)didRegisterNewAccount:(NSString *)username password:(NSString *)password error:(EMError *)error{
//    
//    NSLog(@"注册成功回调");
//}

//登录按钮
- (IBAction)login:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"正在登录..."];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.userName.text password:self.pwd.text completion:^(NSDictionary *loginInfo, EMError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
           NSLog(@"登录成功");
            [JDStatusBarNotification showWithStatus:@"登陆成功" dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
            //1.在登录成功后设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            //自动获取好友列表
            [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
            //2.切换到根控制器
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:NSStringFromClass([WTTabBarController class])];
            [SVProgressHUD dismiss];
        }else{
            
            NSLog(@"%@", error);
        }
        
    } onQueue:nil];
    
}



//#pragma mark - 监听是否自动登录
////次方法不严谨
//- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
//    
//    NSLog(@"将要自动登录");
//}
//
////一般用这个方法
//- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
//    
//    NSLog(@"已经自动登录");
//}

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
            
            NSLog(@"退出登录成功");
        }
        
    } onQueue:nil];
    
}






@end
