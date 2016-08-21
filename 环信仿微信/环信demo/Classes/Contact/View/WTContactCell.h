//
//  WTContactCell.h
//  环信demo
//
//  Created by GRIM on 16/8/11.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTContactCell : UITableViewCell

/**好友*/
@property(nonatomic, strong)EMBuddy *buddy;

+ (instancetype)wt_cellWithTableView:(UITableView *)tableView;

@end
