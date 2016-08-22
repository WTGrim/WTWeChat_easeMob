//
//  WTChatFrame.m
//  环信demo
//
//  Created by GRIM on 16/8/14.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTChatFrame.h"

@interface WTChatFrame ()

/**注释*/
@property(nonatomic, assign)CGRect timeFrame;

@property(nonatomic, assign)CGRect iconFrame;

@property(nonatomic, assign)CGRect contentFrame;

@property(nonatomic, assign)CGRect durationFrame;

/**cell高度*/
@property(nonatomic, assign)CGFloat cellH;

@end
@implementation WTChatFrame


- (void)setChat:(WTChat *)chat{
    
    _chat = chat;
    
    CGFloat margin = 10;
    CGSize timeStrSize = [chat.timeStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size ;
    CGFloat screenW = CGRectGetWidth([UIScreen mainScreen].bounds);

    CGFloat timeY = 0;
    CGFloat timeW = timeStrSize.width + 5;
    CGFloat timeX = (screenW - timeW) * 0.5;
    CGFloat timeH = chat.isShowTime ? 20 : 0;
    self.timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    
    CGFloat iconX ;
    CGFloat iconY = margin + CGRectGetMaxY(self.timeFrame);
    CGFloat iconW = 44;
    CGFloat iconH = iconW;
    

    CGFloat contentX;
    CGFloat contentY = iconY;
    CGFloat contentW;
    CGFloat contentH;
    
    CGFloat durationX;
    CGFloat durationY = contentY;
    CGFloat durationH = iconH;
    CGFloat durationW = durationH;
    
    
    switch (chat.chatType) {
        case WTchatTypeText:
        {
            
            CGFloat contentMaxW = screenW - 2 * (margin + iconW + margin);
            CGSize contentStrSize = [chat.contentText boundingRectWithSize:CGSizeMake(contentMaxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            contentW = contentStrSize.width + kContentEdgeLeft + kContentEdgeRight;
            contentH = contentStrSize.height + kContentEdgeTop + kContentEdgeBottom;
            
        }
            break;
        case WTchatTypeImage:
        {
            if (chat.Vertical) {
                
                contentW = 120;
                contentH = 150;
            }else{
                
                contentH = 150;
                contentW = 120;
            }
            
        }
            break;
        case WTchatTypeLocation:
        {
            
        }
            break;
        case WTchatTypeVoice:
        {
            
            contentH = 60;
            contentW = [self voiceLengthWithTime:chat.voiceDuration];
            
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
    
    
    if (chat.isMe) {
        iconX = screenW - margin - iconW;
        contentX = iconX - margin - contentW;
        durationX = contentX - durationW;
        
    }else{
        iconX = margin;
        contentX = iconX +iconW + margin;
        durationX = contentX + contentW;
    }
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    self.contentFrame = CGRectMake(contentX, contentY, contentW, contentH);
    self.durationFrame = CGRectMake(durationX, durationY, durationW, durationH);
    
    //cellH判断聊天内容和头像高度哪个更大
    self.cellH = (contentH > iconH)?CGRectGetMaxY(self.contentFrame) + margin:CGRectGetMaxY(self.iconFrame) + margin;
}

//计算音频时间长度
- (CGFloat)voiceLengthWithTime:(NSInteger )time{
    
    if (time <= 5) {
        return 64.0;
    }else if (time >= 60)
    {
        return 200.0;
    }else{
        
        return 64.0 + time / 60.0 * 136.0;
    }
}

@end
