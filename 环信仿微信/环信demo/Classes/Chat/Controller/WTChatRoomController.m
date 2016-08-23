//
//  WTChatRoomController.m
//  环信demo
//
//  Created by GRIM on 16/8/11.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTChatRoomController.h"
#import "WTInputView.h"
#import "WTTabBarController.h"
#import "WTChat.h"
#import "WTChatCell.h"
#import "WTChatFrame.h"
#import <MWPhotoBrowser.h>
#import "EMCDDeviceManager.h"
#import "WTMoreInputView.h"

#define kInputViewH 44
#define kMoreInputViewFrame CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), kMoreInputViewH)

@interface WTChatRoomController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, EMChatManagerDelegate, WTInputViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, IEMChatProgressDelegate, WTChatCellDelegate, MWPhotoBrowserDelegate>

/**注释*/
@property(nonatomic, strong)UITableView *tableView;
/**底部输入框*/
@property(nonatomic, strong)WTInputView *inputView;

/**聊天消息数据源*/
@property(nonatomic, strong)NSMutableArray *chatMessage;
/**聊天图片*/
@property(nonatomic, strong)NSMutableArray *chatImage;
/**聊天缩略图*/
@property(nonatomic, strong)NSMutableArray *chatThumbImage;

/**更多按钮*/
@property(nonatomic, strong)WTMoreInputView *moreInputView;


@end

@implementation WTChatRoomController


//初始化确定聊天类型(私聊还是群聊)
+ (instancetype)wt_chatWithUsername:(NSString *)username chatType:(EMConversationType)chatType{
    
    WTChatRoomController *chatVC = [[WTChatRoomController alloc]init];
    chatVC.username = username;
    chatVC.chatType = chatType;
    return chatVC;
}


#pragma mark - 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = backgroundColor243;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        //此处tableview的高度不用减44就正确了
        _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    return _tableView;
    
}

- (WTInputView *)inputView{
    
    if (!_inputView) {
        _inputView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([WTInputView class]) owner:nil options:nil].lastObject;
        //添加输入框的代理
        _inputView.textField.delegate = self;
        _inputView.inputViewDelegate = self;
        _inputView.frame = CGRectMake(0, self.view.bounds.size.height - kInputViewH, self.view.bounds.size.width, kInputViewH);
    }
    return _inputView;
}

- (WTMoreInputView *)moreInputView{
    
    if (!_moreInputView) {
        _moreInputView = [[WTMoreInputView alloc]init];
        _moreInputView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), kMoreInputViewH);
        [[UIApplication sharedApplication].keyWindow addSubview:_moreInputView];
        [UIApplication sharedApplication].keyWindow.backgroundColor = backgroundColor243;
        
        weakSelf(self);
        _moreInputView.moreInputViewBlock = ^(UIButton *btn){
            
            [weakself.view endEditing:YES];
            [weakself dismissMoreInputViewWithAnimation:NO];
            
            if ([btn.currentTitle isEqualToString:@"照片"]) {
                //相片选择
                UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
                ipc.delegate = weakself;
                [weakself presentViewController:ipc animated:YES completion:nil];
            }else if([btn.currentTitle isEqualToString:@"视频聊天"]){
               
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                [alertVC addAction:[UIAlertAction actionWithTitle:@"视频聊天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //弹窗视频
                    
                    
                }]];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"音频聊天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //音频聊天
                    
                }]];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    //取消
                    
                }]];
                
                [weakself presentViewController:alertVC animated:YES completion:nil];
            }
            
        };
        
    }
    return _moreInputView;
}


- (NSMutableArray *)chatMessage{
    
    if (!_chatMessage) {
        _chatMessage = [NSMutableArray array];
    }
    return _chatMessage;
}

- (NSMutableArray *)chatImage{
    
    if (!_chatImage) {
        _chatImage = [NSMutableArray array];
    }
    return _chatImage;
}

- (NSMutableArray *)chatThumbImage{
    
    if (!_chatThumbImage) {
        _chatThumbImage = [NSMutableArray array];
    }
    return _chatThumbImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputView];
    self.navigationItem.title = self.username;
    
    //如果是群组聊天，那么标题显示
    if (self.chatType == eConversationTypeGroupChat) {
        
        EMError *error = nil;
        EMGroup *group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:self.username error:&error];
        self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)", group.groupSubject, group.groupOccupantsCount];
    }
    
    //键盘显示隐藏通知
    [self observeKeyboard];
    //聊天回话消息
    [self reloadChatMsg];
    
    [self.tableView registerClass:[WTChatCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    
    //添加代理，监听收到消息和收到离线消息
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];


}
 //键盘显示隐藏通知
- (void)observeKeyboard{
    
    [[NSNotificationCenter defaultCenter]addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        //        NSLog(@"%@", note);
        
        CGFloat endY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
        CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGFloat tempY = endY - self.view.bounds.size.height;
        self.view.frame = CGRectMake(0, tempY, self.view.bounds.size.width, self.view.bounds.size.height);
        [UIView animateWithDuration:duration animations:^{
            [self.view setNeedsLayout];
        }];
        
    }];
}

//聊天消息
- (void)reloadChatMsg{
    
    //移除已有的对象
    [self.chatMessage removeAllObjects];
    [self.chatImage removeAllObjects];
    [self.chatThumbImage removeAllObjects];
    //一个是聊天对象， 一个是聊天的类型
    /*
     @brief 会话类型
     @constant eConversationTypeChat            单聊会话
     @constant eConversationTypeGroupChat       群聊会话
     @constant eConversationTypeChatRoom        聊天室会话
     */
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.username conversationType:self.chatType];
    //从数据库中加载消息
    NSArray *msgArray = [conversation loadAllMessages];
    
    for (EMMessage *emsg in msgArray) {
        
        WTChat *chat = [[WTChat alloc]init];
        
        //拿到上一条消息的时间
        if (self.chatMessage.count) {
            WTChatFrame *preChatFrame = self.chatMessage.lastObject;
            chat.preTimestamp = preChatFrame.chat.eMsg.timestamp;
        }else{
            //如果之前没有聊天记录，直接设置为0
            chat.preTimestamp = 0;
        }
        
        chat.eMsg = emsg;

        
        WTChatFrame *chatFrame = [[WTChatFrame alloc]init];
        chatFrame.chat = chat;
        
        [self.chatMessage addObject:chatFrame];
        
        //为图片和预览图赋值
        if (chat.chatType == WTchatTypeImage) {
            
            if (chat.contentImage) {
                [self.chatImage addObject:chat.contentImage];
            }else{
                [self.chatImage addObject:chat.contentImageUrl];
            }
            
            [self.chatThumbImage addObject:(chat.contentThumbnailImage ? chat.contentThumbnailImage:chat.contentThumbnailImageUrl)];
            
        }
        
        
    }
    
//    [self.chatMessage addObjectsFromArray:msgArray];
    
    //刷新表格
    [self.tableView reloadData];
    //滚到最下面
    [self scrollToBottom];
    
}

- (void)scrollToBottom{
    
    if (self.chatMessage.count == 0) return;
    //这里第一条消息所以是0，那么需要在上面判断
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatMessage.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

//此处是解决第一次显示没有滚动到底部的问题  
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //调用一下更多按钮
    [self moreInputView];
    //将该会话未读的标记为已读
    [[[EaseMob sharedInstance].chatManager conversationForChatter:self.username conversationType:self.chatType] markAllMessagesAsRead:YES];
    
    [self scrollToBottom];
}

#pragma mark - tableviewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.chatMessage.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WTChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    cell.chatFrame = self.chatMessage[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.chatMessage[indexPath.row] cellH];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //收起moreInputView
    [self dismissMoreInputViewWithAnimation:NO];
    
    self.navigationController.tabBarController.tabBar.hidden = NO;
}


#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //构造chatText对象
    EMChatText *chatText = [[EMChatText alloc]initWithText:textField.text];
    //消息体
    EMTextMessageBody *body = [[EMTextMessageBody alloc]initWithChatObject:chatText];
    //消息
    EMMessage *msg = [[EMMessage alloc]initWithReceiver:self.username bodies:@ [body]];
    
    __weak typeof(self)weakSelf = self;
    //异步方法，发送一条消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil prepare:^(EMMessage *message, EMError *error) {
        //准备发送
        
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        //发送完成
        if (!error) {
            
            NSLog(@"发送成功");
            //将输入框的文字清空
            textField.text = nil;
            //设置输入框文字为空的时候不能点击，此处用的xib而且是回调方法，所以在xib里面设置输入框
//            [textField setEnablesReturnKeyAutomatically:YES];
            //收起键盘
            [textField resignFirstResponder];
            
            //刷新消息
            [weakSelf reloadChatMsg];
        }
    } onQueue:nil];
    
    return YES;
}

#pragma mark - inputViewDelegate

- (void)wt_inputView:(WTInputView *)inputView changeInputViewStyle:(inputViewStyle)Style{
    
    switch (Style) {
        case inputViewStyleText:
        {
            
        }
            break;
        case inputViewStyleVoice:
        {
            [self dismissMoreInputViewWithAnimation:YES];

        }
            break;
        default:
            break;
    }
    
}

- (void)wt_inputView:(WTInputView *)inputView moreOnclickWith:(NSInteger)moreStyle{
    

    weakSelf(self);
    if (self.view.frame.origin.y == 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
           
            CGRect tempRect = CGRectMake(0, -kMoreInputViewH, CGRectGetWidth(weakself.view.bounds), CGRectGetHeight(weakself.view.bounds));
            weakself.view.frame = tempRect;
            weakself.moreInputView.frame = CGRectMake(0, CGRectGetHeight(weakself.view.bounds) - kMoreInputViewH,  CGRectGetWidth(weakself.view.bounds), kMoreInputViewH);
        }];
    }else{
        
        [self dismissMoreInputViewWithAnimation:NO];
        [self.inputView.textField becomeFirstResponder];
    }
    
}


- (void)wt_inputView:(WTInputView *)inputView changeVoiceStatus:(voiceStatus)status{
    
    __weak typeof(self)weakSelf = self;
    switch (status) {
        case voiceStatusSpeaking:
        {
            //开始录制
            //文件路径：好友对象+时间+随机数
            NSInteger nowDate = (NSInteger)[[NSDate date]timeIntervalSince1970];
            NSInteger randomNum = arc4random()%100000;
            NSString *fileName = [NSString stringWithFormat:@"%@%zd%zd", self.username, nowDate, randomNum];
            [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
                
                NSLog(@"正在录制");
                
            }];
            
        }
            break;
        case voiceStatusSend:
        {
            //结束录制，并发送
            [[EMCDDeviceManager sharedInstance]asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
                
                if (!error) {
                    
                    //发送消息
                    EMChatVoice *voice = [[EMChatVoice alloc]initWithFile:recordPath displayName:@"voice"];
                    voice.duration = aDuration;
                    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc]initWithChatObject:voice];
                    EMMessage *emsg = [[EMMessage alloc]initWithReceiver:weakSelf.username bodies:@[body]];
                    [[EaseMob sharedInstance].chatManager asyncSendMessage:emsg progress:weakSelf prepare:^(EMMessage *message, EMError *error) {
                        
                        //在此处实现录制过程中btn一闪一闪的效果
                        
                    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
                        
                        if (!error) {
                            //刷新消息
                            [weakSelf reloadChatMsg];
                            
                        }
                    } onQueue:nil];
                    
                }
                
            }];
        }
            break;
        case voiceStatusWillCancle:
        {
            //HUD提示，将要取消当前录音
            
            
        }
            break;
        case voiceStatusCancled:
        {
            //取消当前录音
            [[EMCDDeviceManager sharedInstance]cancelCurrentRecording];
        }
            break;
            
        default:
            break;
    }
    
    
}




#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //拿到选中图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //发送构造消息
    EMChatImage *chatImage = [[EMChatImage alloc]initWithUIImage:image displayName:@"展示的图片名"];
    EMImageMessageBody *body = [[EMImageMessageBody alloc]initWithChatObject:chatImage];
    EMMessage *emsg = [[EMMessage alloc]initWithReceiver:self.username bodies:@[body]];
    
    
    __weak typeof(self)weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncSendMessage:emsg progress:self prepare:^(EMMessage *message, EMError *error) {
        //
       
        
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        //发送成功
        if (!error) {
            
            [weakSelf reloadChatMsg];
        }
        
        
    } onQueue:nil];
    
    
}

#pragma mark - IEMChatProgressDelegate必须实现的方法
- (void)setProgress:(float)progress forMessage:(EMMessage *)message forMessageBody:(id<IEMMessageBody>)messageBody{
    
    
}

#pragma mark - WTChatcellDelegate
- (void)wt_chatCell:(WTChatCell *)chatCell contentClickWithChatFrame:(WTChatFrame *)chatFrame{
    
    //在此处创建详情大图的浏览界面
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    
    //拿到点击图片的index
    NSInteger index = 0;
    if (chatFrame.chat.contentThumbnailImage) {
        
        index = [self.chatThumbImage indexOfObject:chatFrame.chat.contentThumbnailImage];
    }else{
        
        index = [self.chatThumbImage indexOfObject:chatFrame.chat.contentThumbnailImageUrl];
    }
    
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return self.chatThumbImage.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    id image = self.chatImage[index];
    MWPhoto *photo = ([image isKindOfClass:[UIImage class]])? [MWPhoto photoWithImage:image]:[MWPhoto photoWithURL:image];
    
    return photo;
    
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index{
    
    id image = self.chatThumbImage[index];
    MWPhoto *photo = ([image isKindOfClass:[UIImage class]])? [MWPhoto photoWithImage:image]:[MWPhoto photoWithURL:image];
    
    return photo;
    
}

#pragma mark - 收起键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
}

#pragma mark - 收到消息时的回调
- (void)didReceiveMessage:(EMMessage *)message{
    
    [self reloadChatMsg];
}

//接收到离线非透传消息的回调
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages{
    
    [self reloadChatMsg];
}


- (void)dismissMoreInputViewWithAnimation:(BOOL)hasAnimation{
    
    //将moreInputView收起来，回复原样
    if (hasAnimation) {
        [UIView animateWithDuration:0.25 animations:^{
            self.moreInputView.frame = kMoreInputViewFrame;
            self.view.frame = self.view.bounds;
        }];
    }
    self.moreInputView.frame = kMoreInputViewFrame;
    self.view.frame = self.view.bounds;
}
@end
