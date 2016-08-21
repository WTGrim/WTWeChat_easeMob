//
//  WTChatFrame.h
//  环信demo
//
//  Created by GRIM on 16/8/14.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTChat.h"

#define kContentEdgeTop 15
#define kContentEdgeLeft 20
#define kContentEdgeBottom 25
#define kContentEdgeRight 20

@interface WTChatFrame : NSObject

/**注释*/
@property(nonatomic, strong)WTChat *chat;


/**注释*/
@property(nonatomic, assign, readonly)CGRect timeFrame;

@property(nonatomic, assign, readonly)CGRect iconFrame;

@property(nonatomic, assign, readonly)CGRect contentFrame;

/**cell高度*/
@property(nonatomic, assign, readonly)CGFloat cellH;




@end
