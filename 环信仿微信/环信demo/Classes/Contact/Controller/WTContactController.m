//
//  WTContactController.m
//  环信demo
//
//  Created by GRIM on 16/8/9.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTContactController.h"
#import "WTContactCell.h"
#import "WTDetaiUserInfoController.h"

@interface WTContactController ()<EMChatManagerDelegate>
/**注释*/
@property(nonatomic, strong)NSMutableArray *friends;


@end

@implementation WTContactController

- (NSMutableArray *)friends{
    if (!_friends) {
        _friends = [NSMutableArray array];
        
        //好友列表
        NSArray *buddies = [[EaseMob sharedInstance].chatManager buddyList];
        if (!buddies) {
            [_friends addObjectsFromArray:buddies];
        }
    }
    
    return _friends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录";
    //添加好友按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"contacts_add_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(addFriends)];
    
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WTContactCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([self class])];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //添加代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //在登录成功后设置自动获取好友列表。在此获取好友列表，回调监听是didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)erro方法
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyList];
    
    if (self.friends.count) {
        
        [self reloadContacts];
    }
}

//刷新通讯录
- (void)reloadContacts{
    
    [self.friends removeAllObjects];
    EMError *error = nil;
    
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:&error];
    if (!error) {
        [self.friends removeAllObjects];
        [self.friends addObjectsFromArray:buddyList];
    }
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}



- (void)addFriends{
    
    //好友申请弹出框
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"好友申请" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入微信号";
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"申请备注";
    }];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //发送好友申请
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager addBuddy:alertVC.textFields.firstObject.text message:alertVC.textFields.lastObject.text error:&error];
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
    
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WTContactCell *cell = [WTContactCell wt_cellWithTableView:tableView];
    cell.buddy = self.friends[indexPath.row];
    return cell;

}


#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMBuddy *buddy = self.friends[indexPath.row];
    WTDetaiUserInfoController *detailVc = [[UIStoryboard storyboardWithName:NSStringFromClass([WTDetaiUserInfoController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([WTDetaiUserInfoController class])];
    detailVc.buddy = buddy;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

//编辑删除按钮，删除好友
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //拿到当前好友
        EMBuddy *buddy = self.friends[indexPath.row];
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:&error];
        if (!error) {
            NSLog(@"删除成功");
        }
        
    }
    
    
}

//当请求被接受的回调
- (void)didAcceptedByBuddy:(NSString *)username{
    
    [self reloadContacts];
}
//当被某人删除好友的回调
- (void)didRemovedByBuddy:(NSString *)username{
    
    [self reloadContacts];
}

//接受好友成功的回调
- (void)didAcceptBuddySucceed:(NSString *)username{
    
    [self reloadContacts];
}

//监听好友列表刷新的回调
- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd{
    [self.friends removeAllObjects];
    [self.friends addObjectsFromArray:buddyList];
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });


}

//自动获取好友列表的回调，与
- (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error{
    
    if (!error) {
        [self.friends removeAllObjects];
        [self.friends addObjectsFromArray:buddyList];
        
        __weak typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }
}
@end
