//
//  UIImage+YFResizing.m
//  YFWeChat
//
//  Created by dyf on 16/5/19.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import "UIImage+YFResizing.h"

@implementation UIImage (YFResizing)

+ (UIImage *)yf_resizingWithImaName:(NSString *)iconName
{
    return [self yf_resizingWithIma: [UIImage imageNamed: iconName]];
}

+ (UIImage *)yf_resizingWithIma:(UIImage *)ima
{
    CGFloat w = ima.size.width * 0.499;
    CGFloat h = ima.size.height * 0.499;
    return [ima resizableImageWithCapInsets: UIEdgeInsetsMake(h, w, h, w)];
}

+ (UIImage *)yf_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

/**切圆角，加填充色*/
// 生成圆角图片(优化后)
- (UIImage *)wt_cornerImageWithSize:(CGSize)size fillClolor:(UIColor *)fillColor{
    
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    // 设置rect
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // 设置填充色
    [fillColor set];
    UIRectFill(rect);
    
    // 计算半径
    CGFloat cornerRadius = MIN(size.width, size.height) * 0.5;
    
    // 设置圆形路径并切割
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    
    // 将原始图片绘制到图形上下文中
    [self drawInRect:rect];
    
    // 从图形上下获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 返回圆形图片
    return image;
}

@end
