//
//  WTInputView.h
//  环信demo
//
//  Created by GRIM on 16/8/11.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTInputView;

typedef enum : NSUInteger {
    inputViewStyleText,
    inputViewStyleVoice,
} inputViewStyle;

typedef enum : NSUInteger {
    voiceStatusSpeaking,
    voiceStatusSend,
    voiceStatusWillCancle,
    voiceStatusCancled,
} voiceStatus;


@protocol WTInputViewDelegate <NSObject>

@optional
/**更多按钮*/
- (void)wt_inputView:(WTInputView *)inputView moreOnclickWith:(NSInteger)moreStyle;
/**改变输入形式*/
- (void)wt_inputView:(WTInputView *)inputView changeInputViewStyle:(inputViewStyle)Style;
/**改变声音输入状态*/
- (void)wt_inputView:(WTInputView *)inputView changeVoiceStatus:(voiceStatus)status;

@end

@interface WTInputView : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;

//代理
@property (weak, nonatomic) id<WTInputViewDelegate>inputViewDelegate;


@end
