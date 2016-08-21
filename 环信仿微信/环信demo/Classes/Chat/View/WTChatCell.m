//
//  WTChatCell.m
//  环信demo
//
//  Created by GRIM on 16/8/14.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTChatCell.h"
#import "WTLongPressBtn.h"
#import "WTChatFrame.h"
#import "WTChat.h"
#import "UIImage+YFResizing.h"
#import <UIButton+WebCache.h>
@interface WTChatCell ()

/**时间*/
@property(nonatomic, weak)UILabel *timeLabel;
//头像按钮手势
@property(nonatomic, weak)WTLongPressBtn *userIconBtn;
//聊天内容手势
@property(nonatomic, weak)WTLongPressBtn *contentBtn;
@end


@implementation WTChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = backgroundColor243;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //在此添加子控件
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.backgroundColor = [UIColor lightGrayColor];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.layer.cornerRadius = 5;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.layer.masksToBounds = YES;
        
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        WTLongPressBtn *userIconBtn = [[WTLongPressBtn alloc] init];
        userIconBtn.longPressBlock = ^(WTLongPressBtn *btn){
            // 长按时的业务逻辑处理
        };
        [userIconBtn addTarget:self action:@selector(showDetailUserInfo) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: userIconBtn];
        self.userIconBtn = userIconBtn;
        
        
        WTLongPressBtn *contentTextBtn = [[WTLongPressBtn alloc] init];
        contentTextBtn.longPressBlock = ^(WTLongPressBtn *btn){
            // 长按时的业务逻辑处理
        };
        contentTextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        contentTextBtn.titleLabel.numberOfLines = 0;
        contentTextBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentEdgeTop, kContentEdgeLeft, kContentEdgeBottom, kContentEdgeRight);
        
        [contentTextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contentTextBtn addTarget:self action:@selector(showDetailContent) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: contentTextBtn];
        self.contentBtn = contentTextBtn;
        
        
    }
    return self;
}

//进入用户详情页面
- (void)showDetailUserInfo{
    
    NSLog(@"点击用户头像进入详情");
    
}

- (void)showDetailContent{
    
    NSLog(@"点击聊天内容");
    switch (self.chatFrame.chat.chatType) {
        case WTchatTypeText:
        {
            
        }
            break;
        case WTchatTypeImage:
        {
            if ([self.delegate respondsToSelector:@selector(wt_chatCell:contentClickWithChatFrame:)]) {
                
                [self.delegate wt_chatCell:self contentClickWithChatFrame:self.chatFrame];
            }
        }
            break;
        default:
            break;
    }
    
}

//这里给子控件赋值
- (void)setChatFrame:(WTChatFrame *)chatFrame{
    
    _chatFrame = chatFrame;
    
    WTChat *chat = chatFrame.chat;
    self.timeLabel.text = chat.timeStr;
    
    //实际开发中，这里应该用SDWebImage取图片
    [self.userIconBtn setImage:[UIImage imageNamed:chat.userIcon] forState:UIControlStateNormal];
    
    [self.contentBtn setBackgroundImage:[UIImage yf_resizingWithIma:chat.contentTextBackgroundImage] forState:UIControlStateNormal];
    [self.contentBtn setBackgroundImage:[UIImage yf_resizingWithIma:chat.contentTextBackgroundImageHL] forState:UIControlStateHighlighted];

    
    switch (chat.chatType) {
        case WTchatTypeText:
        {
            
            [self.contentBtn setTitle:chat.contentText forState:UIControlStateNormal];
            [self.contentBtn setImage:nil forState:UIControlStateNormal];
        }
            break;
        case WTchatTypeImage:
        {
            self.contentBtn.contentEdgeInsets = UIEdgeInsetsZero;
            [self.contentBtn setTitle:nil forState:UIControlStateNormal];
            if (chat.contentThumbnailImage) {
                [self.contentBtn setImage:chat.contentThumbnailImage forState:UIControlStateNormal];
            }else{
                //用SDWebImage进行图片下载
                [self.contentBtn sd_setImageWithURL:chat.contentThumbnailImageUrl forState:UIControlStateNormal];
            }

        }
            break;
        case WTchatTypeLocation:
        {
            
        }
            break;
        case WTchatTypeVoice:
        {
            
            [self.contentBtn setTitle:[NSString stringWithFormat:@"%zd", chat.voiceDuration] forState:UIControlStateNormal];
            
        }
            break;
        case WTchatTypeVideo:
        {
            
        }
            break;
        case WTchatTypeFile:
        {
            
        }
            break;
        case WTchatTypeCommand:
        {
            
        }
            break;
            
        default:
            break;
    }
    

    
}

//进行布局
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.timeLabel.frame = self.chatFrame.timeFrame;
    self.userIconBtn.frame = self.chatFrame.iconFrame;
    self.contentBtn.frame = self.chatFrame.contentFrame;
    
}
@end
