//
//  WTChat.h
//  环信demo
//
//  Created by GRIM on 16/8/14.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WTchatTypeText = eMessageBodyType_Text,
    WTchatTypeImage = eMessageBodyType_Image,
    WTchatTypeVoice = eMessageBodyType_Voice,
    WTchatTypeVideo = eMessageBodyType_Video,
    WTchatTypeLocation = eMessageBodyType_Location,
    WTchatTypeFile = eMessageBodyType_File,
    WTchatTypeCommand = eMessageBodyType_Command,
} WTchatType;



@interface WTChat : NSObject

/**友盟聊天消息对象*/
@property(nonatomic, strong)EMMessage *eMsg;
/**上一条消息的时间*/
@property(nonatomic, assign)long long preTimestamp;


/**文字聊天内容*/
@property(nonatomic, copy, readonly)NSString * contentText;

/**>>>>>>>>>>>>>>>图片聊天内容>>>>>>>>>>>>>>>>>>>>>>>*/
/**详情图片*/
@property(nonatomic, strong, readonly)UIImage *contentImage;
/**缩略图*/
@property(nonatomic, strong, readonly)UIImage *contentThumbnailImage;
/**详情图片的Url*/
@property(nonatomic, strong, readonly)NSURL *contentImageUrl;
/**缩略图的Url*/
@property(nonatomic, strong, readonly)NSURL *contentThumbnailImageUrl;
/**是横预览还是竖预览*/
@property(nonatomic, assign, getter=isVertical, readonly)BOOL Vertical;


/**>>>>>>>>>>>>>>>音频聊天内容>>>>>>>>>>>>>>>>>>>>>>>*/
/**音频时间*/
@property(nonatomic, assign, readonly)NSInteger voiceDuration;
/**音频路径*/
@property(nonatomic, copy, readonly)NSString * voicePath;


/**聊天类型*/
@property(nonatomic, assign, readonly)WTchatType chatType;

/**用户对象*/
@property(nonatomic, copy, readonly)NSString * userIcon;
/**时间*/
@property(nonatomic, copy, readonly)NSString * timeStr;
/**聊天气泡图片*/
@property(nonatomic, strong, readonly)UIImage *contentTextBackgroundImage;
/**聊天气泡高亮图片*/
@property(nonatomic, strong, readonly)UIImage *contentTextBackgroundImageHL;
/**是我还是他*/
@property(nonatomic, assign, getter=isMe, readonly)BOOL me;

/**是否显示时间*/
@property(nonatomic, assign, getter=isShowTime,readonly)BOOL showTime;




@end
