//
//  WTGroupController.m
//  环信demo
//
//  Created by GRIM on 16/8/22.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTGroupController.h"
#import "WTContactCell.h"
#import "WTChatRoomController.h"
#import "WTWeChatController.h"

@interface WTGroupController ()

/**群聊数据*/
@property(nonatomic, strong)NSMutableArray *groups;


@end

@implementation WTGroupController

- (NSMutableArray *)groups{
    
    if (!_groups) {
        _groups = [NSMutableArray array];
        NSArray *groupList = [[EaseMob sharedInstance].chatManager groupList];
        if (!groupList.count) {
            groupList = [[EaseMob sharedInstance].chatManager loadAllMyGroupsFromDatabaseWithAppend2Chat:YES];
        }
        [_groups addObjectsFromArray:groupList];
    }
    return _groups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.groups.count) {
        [self reloadGroup];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"建群" style:UIBarButtonItemStylePlain target:self action:@selector(createGroup)];
}

//创建群组
- (void)createGroup{
    weakSelf(self);
    [SVProgressHUD showWithStatus:@"正在创建中..."];
    //先预设群组的设置（其他设置在群组已经创建完成后可以进行修改）
    EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
    groupStyleSetting.groupMaxUsersCount = 500; // 创建500人的群，如果不设置，默认是200人。
    groupStyleSetting.groupStyle = eGroupStyle_PublicOpenJoin; // 创建不同类型的群组，这里需要才传入不同的类型
    
    NSString *username = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:[NSString stringWithFormat:@"%@的群组", username]
                                                          description:@"群组描述"
                                                             invitees:nil//先传nil，创建成功后可以邀请
                                                initialWelcomeMessage:@"邀请您加入群组"
                                                         styleSetting:groupStyleSetting
                                                           completion:^(EMGroup *group, EMError *error) {
                                                               [SVProgressHUD dismiss];
                                                               if(!error){
                                                                   NSLog(@"创建成功 -- %@",group);
                                                                   [JDStatusBarNotification showWithStatus:@"建群成功,去邀请小伙伴吧!" dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
                                                                   [weakself reloadGroup];
                                                               }        
                                                           } onQueue:nil];
}

- (void)reloadGroup{
    
    __weak typeof(self)weakSelf = self;
    //获取与我相关的群组列表（自己创建的，加入的）(异步方法)
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        
        if(!error){
            [weakSelf.groups removeAllObjects];
            [weakSelf.groups addObjectsFromArray:groups];
            [weakSelf.tableView reloadData];
        }
    } onQueue:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WTContactCell *cell = [WTContactCell wt_cellWithTableView:tableView];
    cell.group = self.groups[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WTChatRoomController *chatVC = [[WTChatRoomController alloc]init];
    chatVC.username = [self.groups[indexPath.row] groupId];
    chatVC.chatType = eConversationTypeGroupChat;
    
//    [self.navigationController pushViewController:chatVC animated:YES];
    
    UITabBarController *tbc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tbc.selectedViewController = tbc.viewControllers[0];
    [(UINavigationController *)tbc.viewControllers[0] pushViewController:chatVC animated:YES];
}

@end
