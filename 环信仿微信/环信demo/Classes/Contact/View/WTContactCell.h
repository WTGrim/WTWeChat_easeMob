//
//  WTContactCell.h
//  环信demo
//
//  Created by GRIM on 16/8/11.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTContactItem;
@interface WTContactCell : UITableViewCell

/**好友*/
@property(nonatomic, strong)EMBuddy *buddy;

/**注释*/
@property(nonatomic, strong)WTContactItem *headerItem;

/**群组*/
@property(nonatomic, strong)EMGroup *group;


+ (instancetype)wt_cellWithTableView:(UITableView *)tableView;

@end
