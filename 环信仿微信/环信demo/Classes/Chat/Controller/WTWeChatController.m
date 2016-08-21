//
//  WTWeChatController.m
//  环信demo
//
//  Created by GRIM on 16/8/9.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTWeChatController.h"

@interface WTWeChatController ()<EMChatManagerDelegate>

@end

NSString *const WTTitleWillReconnect = @"收取中...";
NSString *const WTTitleNormal = @"微信";
NSString *const WTTitleDisConnect = @"微信(未连接)";
NSString *const WTTitleWillConnect = @"连接中...";


@implementation WTWeChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = WTTitleNormal;
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


//将要自动连接
- (void)willAutoReconnect{
    
    self.navigationItem.title = WTTitleWillReconnect;
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    
    if (!error) {
        
        self.navigationItem.title = WTTitleNormal;
    }else{
        
        self.navigationItem.title = WTTitleDisConnect;
    }
}

//根据网络连接状态改变标题
- (void)didConnectionStateChanged:(EMConnectionState)connectionState{
    
    switch (connectionState) {
        case eEMConnectionConnected:
            self.navigationItem.title = WTTitleNormal;
            break;
            
        case eEMConnectionDisconnected:
            self.navigationItem.title = WTTitleDisConnect;
            break;
            
        default:
            break;
    }
    
}
@end
