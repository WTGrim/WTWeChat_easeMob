//
//  WTWeChatController.m
//  环信demo
//
//  Created by GRIM on 16/8/9.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTWeChatController.h"
#import "WTChatRoomController.h"

@interface WTWeChatController ()<EMChatManagerDelegate>

/**会话列表*/
@property(nonatomic, strong)NSMutableArray *conversations;


@end

NSString *const WTTitleWillReconnect = @"收取中...";
NSString *const WTTitleNormal = @"微信";
NSString *const WTTitleDisConnect = @"微信(未连接)";
NSString *const WTTitleWillConnect = @"连接中...";


@implementation WTWeChatController

- (NSMutableArray *)conversations{
    
    if (!_conversations) {
        _conversations = [NSMutableArray array];
        NSArray *conversation = [[EaseMob sharedInstance].chatManager conversations];
        [_conversations addObjectsFromArray:conversation];
    }
    return _conversations;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = WTTitleNormal;
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    //如果conversations没有值(内存中)，那么从数据库中去取
    if (!self.conversations.count) {
        
        [self reloadConversations];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //刷新会话列表
    [self reloadConversations];
    //显示未读消息的数字
    NSInteger unreadMsg = [[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase];
    NSString *bdv = unreadMsg ? [NSString stringWithFormat:@"%zd", unreadMsg]: nil;
    self.navigationController.tabBarItem.badgeValue = bdv;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)reloadConversations{
    
    [self.conversations removeAllObjects];
    //获取当前登录用户的会话列表(从数据库中)
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];//传YES存入内存中
    [self.conversations addObjectsFromArray:conversations];
    [self.tableView reloadData];
}

//会话列表信息更新时的回调
- (void)didUpdateConversationList:(NSArray *)conversationList{
    
    [self reloadConversations];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"add_friend_icon_offical"];
    cell.textLabel.text = [self.conversations[indexPath.row] chatter];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WTChatRoomController *chatVC = [[WTChatRoomController alloc]init];
    chatVC.username = [self.conversations[indexPath.row] chatter];
    [self.navigationController pushViewController:chatVC animated:YES];
    
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
