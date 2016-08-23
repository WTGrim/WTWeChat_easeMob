//
//  WTContactItemController.m
//  环信demo
//
//  Created by GRIM on 16/8/22.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTContactItemController.h"
#import "WTContactItem.h"
#import "WTContactCell.h"
#import "WTGroupController.h"
@interface WTContactItemController ()

/**注释*/
@property(nonatomic, strong)NSArray *contactItems;

@end

@implementation WTContactItemController

- (NSArray *)contactItems{
    
    if (!_contactItems) {
        WTContactItem *item1 = [[WTContactItem alloc]init];
        item1.title = @"新的朋友";
        item1.iconName = @"plugins_FriendNotify";
        item1.controller = [UIViewController class];
        
        WTContactItem *item2 = [[WTContactItem alloc]init];
        item2.title = @"群聊";
        item2.iconName = @"add_friend_icon_addgroup";
        item2.controller = [WTGroupController class];
        
        WTContactItem *item3 = [[WTContactItem alloc]init];
        item3.title = @"标签";
        item3.iconName = @"Contact_icon_ContactTag";
        item3.controller = [UIViewController class];
        
        WTContactItem *item4 = [[WTContactItem alloc]init];
        item4.title = @"公众号";
        item4.iconName = @"add_friend_icon_offical";
        item4.controller = [UIViewController class];
        
        _contactItems = @[item1, item2, item3, item4];
    }
    
    return _contactItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 50;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contactItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WTContactCell *cell = [WTContactCell wt_cellWithTableView:tableView];
    cell.headerItem = self.contactItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIViewController *vc = [[[self.contactItems[indexPath.row] controller]alloc]init];
    //因为在WTContactController中添加了子控制器，所以这里拿到父控制器可以push
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
    
}

@end
