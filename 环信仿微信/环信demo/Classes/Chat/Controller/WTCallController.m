//
//  WTCallController.m
//  环信demo
//
//  Created by GRIM on 16/8/25.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTCallController.h"

@interface WTCallController ()<EMCallManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *usernameLab;

@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;

@property (weak, nonatomic) IBOutlet UIButton *agreeCall;

@end

@implementation WTCallController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

//取消通话
- (IBAction)cancleOnClick:(UIButton *)sender {
    /** 
     @constant eCallReason_Null 正常挂断
     @constant eCallReason_Offline 对方不在线
     @constant eCallReason_NoResponse 对方没有响应
     @constant eCallReason_Hangup 对方挂断
     @constant eCallReason_Reject 对方拒接
     @constant eCallReason_Busy 对方占线
     @constant eCallReason_Failure 失败*/
    [[EaseMob sharedInstance].callManager asyncEndCall:self.callSession.sessionId reason:eCallReason_Reject];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//同意电话
- (IBAction)agreeCall:(UIButton *)sender {
    
    [[EaseMob sharedInstance].callManager asyncAnswerCall:self.callSession.sessionId];
}

@end
