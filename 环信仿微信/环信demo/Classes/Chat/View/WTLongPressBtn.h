//
//  WTLongPressBtn.h
//  环信demo
//
//  Created by GRIM on 16/8/14.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTLongPressBtn;
typedef void(^longPressBlock)(WTLongPressBtn *btn);

@interface WTLongPressBtn : UIButton

/**注释*/
@property(nonatomic, copy)longPressBlock longPressBlock ;


@end
