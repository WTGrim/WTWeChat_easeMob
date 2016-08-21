//
//  WTChatCell.h
//  环信demo
//
//  Created by GRIM on 16/8/14.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTChatFrame, WTChatCell;

@protocol WTChatCellDelegate <NSObject>
@optional
- (void)wt_chatCell:(WTChatCell *)chatCell contentClickWithChatFrame:(WTChatFrame *)chatFrame;

@end

@interface WTChatCell : UITableViewCell

/**布局*/
@property(nonatomic, strong)WTChatFrame *chatFrame;

/**代理*/
@property(nonatomic, weak)id<WTChatCellDelegate> delegate;


@end
