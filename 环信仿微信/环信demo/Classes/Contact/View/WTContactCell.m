//
//  WTContactCell.m
//  环信demo
//
//  Created by GRIM on 16/8/11.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTContactCell.h"
#import "WTContactItem.h"

@interface WTContactCell()

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation WTContactCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)wt_cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = nil;
    if (!ID) {
        ID = [NSString stringWithFormat:@"%@ID", NSStringFromClass(self)];
    }
    static UITableView *tableV = nil;
    if (![tableView isEqual:tableV]) {
     //如果使用的不同tableView，更新缓存池的tableView
        tableV = tableView;
    }
    id cell = [tableV dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setBuddy:(EMBuddy *)buddy{
    
    _buddy = buddy;
    self.username.text = buddy.username;
    
    //此处一般用SDWebImage
    self.userIcon.image = [UIImage imageNamed:@"1"];
}

- (void)setHeaderItem:(WTContactItem *)headerItem{
    
    _headerItem = headerItem;
    self.username.text = headerItem.title;
    self.userIcon.image = [UIImage imageNamed:headerItem.iconName];
    
}

- (void)setGroup:(EMGroup *)group{
    
    _group = group;
    self.username.text = group.groupSubject;
    self.userIcon.image = [UIImage imageNamed:@"add_friend_icon_addgroup"];
}

@end
