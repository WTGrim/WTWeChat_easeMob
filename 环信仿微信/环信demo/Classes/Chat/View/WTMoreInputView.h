//
//  WTMoreInputView.h
//  环信demo
//
//  Created by GRIM on 16/8/23.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMoreInputViewH 200

typedef void(^moreInputViewBlock)(UIButton *btn);

@interface WTMoreInputView : UIView

/**注释*/
@property(nonatomic, copy)moreInputViewBlock  moreInputViewBlock;


@end
