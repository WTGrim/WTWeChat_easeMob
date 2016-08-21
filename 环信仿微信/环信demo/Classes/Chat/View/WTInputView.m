//
//  WTInputView.m
//  环信demo
//
//  Created by GRIM on 16/8/11.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTInputView.h"
#import "UIImage+YFResizing.h"


@interface WTInputView ()

@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;


@end
@implementation WTInputView


- (void)awakeFromNib{
    
    self.backgroundColor = backgroundColor243;
    [self.voiceBtn setBackgroundImage:[UIImage yf_imageWithColor:backgroundColor243] forState:UIControlStateNormal];
    self.voiceBtn.layer.borderWidth = 0.5;
    self.voiceBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.voiceBtn.layer.cornerRadius = 5;
    self.voiceBtn.layer.masksToBounds = YES;
    self.voiceBtn.hidden = YES;
}

- (IBAction)changeInputStyle:(UIButton *)sender {
    
    self.voiceBtn.hidden = sender.isSelected;
    sender.selected = !sender.isSelected;
    
    //通过代理监听键盘回退
    self.voiceBtn.hidden ? [self.textField becomeFirstResponder]: [self.textField resignFirstResponder];
}


- (IBAction)emojiOnclick:(UIButton *)sender {
}

- (IBAction)moreOnclick:(UIButton *)sender {
    
    if ([self.inputViewDelegate respondsToSelector:@selector(wt_inputView:moreOnclickWith:)]) {
        
        [self.inputViewDelegate wt_inputView:self moreOnclickWith:0];
    }
    
}


- (IBAction)voiceTouchDown:(UIButton *)sender {
    
    if ([self.inputViewDelegate respondsToSelector:@selector(wt_inputView:changeVoiceStatus:)]) {
        
        [self.inputViewDelegate wt_inputView:self changeVoiceStatus:voiceStatusSpeaking];
    }
    
    
}
- (IBAction)voiceTouchUpInSide {
    
    if ([self.inputViewDelegate respondsToSelector:@selector(wt_inputView:changeVoiceStatus:)]) {
        
        [self.inputViewDelegate wt_inputView:self changeVoiceStatus:voiceStatusSend];
    }
    
}
- (IBAction)voiceTouchDragOutside {
    
    if ([self.inputViewDelegate respondsToSelector:@selector(wt_inputView:changeVoiceStatus:)]) {
        
        [self.inputViewDelegate wt_inputView:self changeVoiceStatus:voiceStatusWillCancle];
    }
    
}
- (IBAction)voiceTouchUpOutside {
    
    if ([self.inputViewDelegate respondsToSelector:@selector(wt_inputView:changeVoiceStatus:)]) {
        
        [self.inputViewDelegate wt_inputView:self changeVoiceStatus:voiceStatusCancled];
    }
    
}

@end
