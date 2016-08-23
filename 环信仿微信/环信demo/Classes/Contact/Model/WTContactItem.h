//
//  WTContactItem.h
//  环信demo
//
//  Created by GRIM on 16/8/22.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTContactItem : NSObject

/**名称*/
@property(nonatomic, copy)NSString * title;
/**图片名称*/
@property(nonatomic, copy)NSString * iconName;
/**控制器的类*/
@property(nonatomic, copy)Class  controller;




@end
