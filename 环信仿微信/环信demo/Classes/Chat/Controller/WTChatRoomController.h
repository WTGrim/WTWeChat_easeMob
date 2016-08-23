//
//  WTChatRoomController.h
//  环信demo
//
//  Created by GRIM on 16/8/11.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTChatRoomController : UIViewController

+ (instancetype)wt_chatWithUsername:(NSString *)username chatType:(EMConversationType)chatType;

/**注释*/
@property(nonatomic, strong)NSString *username;

/**聊天类型*/
@property(nonatomic, assign)EMConversationType chatType;

@end
