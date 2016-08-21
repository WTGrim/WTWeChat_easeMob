//
//  WTChat.m
//  环信demo
//
//  Created by GRIM on 16/8/14.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTChat.h"
#import "NSString+YFTimestamp.h"

@interface WTChat ()

/**文字聊天内容*/
@property(nonatomic, copy)NSString * contentText;
/**用户对象*/
@property(nonatomic, copy)NSString * userIcon;
/**时间*/
@property(nonatomic, copy)NSString * timeStr;
/**聊天气泡图片*/
@property(nonatomic, strong)UIImage *contentTextBackgroundImage;
/**聊天气泡高亮图片*/
@property(nonatomic, strong)UIImage *contentTextBackgroundImageHL;


/**>>>>>>>>>>>>>>图片聊天内容>>>>>>>>>>>>>>>>>>>>>>>*/
/**详情图片*/
@property(nonatomic, strong)UIImage *contentImage;
/**缩略图*/
@property(nonatomic, strong)UIImage *contentThumbnailImage;
/**详情图片的Url*/
@property(nonatomic, strong)NSURL *contentImageUrl;
/**缩略图的Url*/
@property(nonatomic, strong)NSURL *contentThumbnailImageUrl;
/**是横预览还是竖预览*/
@property(nonatomic, assign, getter=isVertical)BOOL Vertical;


/**>>>>>>>>>>>>>>>音频聊天内容>>>>>>>>>>>>>>>>>>>>>>>*/
/**音频时间*/
@property(nonatomic, assign)NSInteger voiceDuration;
/**音频路径*/
@property(nonatomic, copy)NSString * voicePath;

/**注释*/
@property(nonatomic, assign, getter=isMe)BOOL me;
/**是否显示时间*/
@property(nonatomic, assign, getter=isShowTime)BOOL showTime;

/**聊天类型*/
@property(nonatomic, assign)WTchatType chatType;

@end

@implementation WTChat


- (void)setEMsg:(EMMessage *)eMsg{
    
    
    _eMsg = eMsg;
    
    //拿到当前登录的用户(我)
    NSString *loginUser = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    if ([loginUser isEqualToString:eMsg.from]) {
        
        self.me = YES;
        self.userIcon = @"1";

        self.contentTextBackgroundImage = [UIImage imageNamed:@"SenderTextNodeBkg"];
        self.contentTextBackgroundImageHL = [UIImage imageNamed:@"SenderTextNodeBkgHL"];
    }else{
        
        self.me = NO;
        self.userIcon = @"add_friend_icon_offical";
        self.contentTextBackgroundImage = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
        self.contentTextBackgroundImageHL = [UIImage imageNamed:@"ReceiverTextNodeBkgHL"];
    }
    
    //消息发送或者接受时间
    //如果两条消息的时间间隔小于10分钟（这里时间是ms级）则不显示时间
    self.showTime = ABS(eMsg.timestamp - self.preTimestamp) > 600000;
    
    self.timeStr = [NSString yf_convastionTimeStr:eMsg.timestamp];
    

    id<IEMMessageBody> msgBody = eMsg.messageBodies.firstObject;
    
    //直接为聊天消息体类型赋值
    self.chatType = (WTchatType)msgBody.messageBodyType;
    
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            
            //收到的文字消息赋值
            self.contentText =  txt;
            
            NSLog(@"收到的文字是 txt -- %@",txt);
        }
            break;
        case eMessageBodyType_Image:
        {
            // 得到一个图片消息body
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
            NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用SDK提供的下载方法后才会存在
            NSLog(@"大图的secret -- %@"    ,body.secretKey);
            NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
            NSLog(@"大图的下载状态 -- %lu",body.attachmentDownloadStatus);
            
            if ([[NSFileManager defaultManager]fileExistsAtPath:body.localPath]) {
                
                self.contentImage = [UIImage imageWithContentsOfFile:body.localPath];
            }
            self.contentImageUrl = [NSURL URLWithString:body.remotePath];
            
            
            // 缩略图sdk会自动下载
            NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
            NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
            NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
            NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
            NSLog(@"小图的下载状态 -- %lu",body.thumbnailDownloadStatus);
            
            if ([[NSFileManager defaultManager]fileExistsAtPath:body.thumbnailLocalPath]) {
                
                self.contentThumbnailImage = [UIImage imageWithContentsOfFile:body.thumbnailLocalPath];
            }
            self.contentThumbnailImageUrl = [NSURL URLWithString:body.thumbnailRemotePath];
            
            self.Vertical = body.thumbnailSize.width < body.thumbnailSize.height;
            
        }
            break;
        case eMessageBodyType_Location:
        {
            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
            NSLog(@"纬度-- %f",body.latitude);
            NSLog(@"经度-- %f",body.longitude);
            NSLog(@"地址-- %@",body.address);
        }
            break;
        case eMessageBodyType_Voice:
        {
            // 音频SDK会自动下载
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用SDK提供的下载方法后才会存在（音频会自动调用）
            NSLog(@"音频的secret -- %@"        ,body.secretKey);
            NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"音频文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
            NSLog(@"音频的时间长度 -- %lu"      ,body.duration);
            
            self.voicePath = ([self fileExits:body.localPath])? body.localPath: body.remotePath;
            self.voiceDuration = body.duration;
            
            
        }
            break;
        case eMessageBodyType_Video:
        {
            EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
            
            NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用SDK提供的下载方法后才会存在
            NSLog(@"视频的secret -- %@"        ,body.secretKey);
            NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"视频文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
            NSLog(@"视频的时间长度 -- %lu"      ,body.duration);
            NSLog(@"视频的W -- %f ,视频的H -- %f", body.size.width, body.size.height);
            
            // 缩略图sdk会自动下载
            NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
            NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailRemotePath);
            NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
            NSLog(@"缩略图的下载状态 -- %lu"      ,body.thumbnailDownloadStatus);
        }
            break;
        case eMessageBodyType_File:
        {
            EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
            NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
            NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用SDK提供的下载方法后才会存在
            NSLog(@"文件的secret -- %@"        ,body.secretKey);
            NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"文件文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)fileExits:(NSString *)path{
    
    return [[NSFileManager defaultManager]fileExistsAtPath:path];
}

@end
