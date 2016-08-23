//
//  WTMoreInputView.m
//  环信demo
//
//  Created by GRIM on 16/8/23.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTMoreInputView.h"

@interface WTMoreInputView ()

/**更多的按钮*/
@property(nonatomic, strong)NSMutableArray *btns;

/**btn的标题*/
@property(nonatomic, strong)NSArray *btnTitles;

@end

@implementation WTMoreInputView

#pragma mark - 懒加载
- (NSArray *)btnTitles{
    
    if (!_btnTitles) {
        _btnTitles = @[@"照片", @"视频聊天"];
    }
    return _btnTitles;
}

- (NSMutableArray *)btns{
    
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = backgroundColor243;
        for (NSString *title in self.btnTitles) {
            
            [self wt_setBtnWithTitle:title];
        }
    }
    return self;
}

- (void)wt_setBtnWithTitle:(NSString *)title{
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    //添加到数据源
    [self.btns addObject:btn];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat btnW = 60;
    CGFloat btnH = btnW;
    NSInteger rowCount = 2;
    NSInteger colCount = 4;
    CGFloat orx = 10;
    CGFloat ory = 10;
    NSInteger index = 0;
    
    CGFloat colMargin = (CGRectGetWidth(self.bounds) - 2*orx - colCount*btnW) / (colCount - 1);
    CGFloat rowMargin = (CGRectGetHeight(self.bounds) - 2*ory - rowCount *btnH) / (rowCount - 1);
    
    for (UIButton *btn in self.btns) {
        //页面小于8个的时候，执行布局
        NSInteger row = index / colCount;
        NSInteger col = index % colCount;
        
        if (index < rowCount * colCount) {
            btn.backgroundColor = [UIColor darkGrayColor];
            btn.frame = CGRectMake(orx + (btnW + colMargin)*col , ory + (btnH + rowMargin) * row, btnW, btnH);
        }
        index++;
    }
    
}

- (void)moreBtnClick:(UIButton *)btn{
    
    //如果block有值
    if (self.moreInputViewBlock) {
        
        self.moreInputViewBlock(btn);
    }
}
@end
