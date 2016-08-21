//
//  WTLongPressBtn.m
//  环信demo
//
//  Created by GRIM on 16/8/14.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTLongPressBtn.h"

@implementation WTLongPressBtn


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //长按手势
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGR:)];
        longPressGR.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPressGR];
        
        
    }
    return self;
}

- (void)longPressGR:(UILongPressGestureRecognizer *)longPressGR{
    
    if (self.longPressBlock) {
        self.longPressBlock(self);
    }
}

@end
