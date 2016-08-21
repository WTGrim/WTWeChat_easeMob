//
//  NSString+YFTimestamp.m
//  YFWeChat
//
//  Created by dyf on 16/5/19.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import "NSString+YFTimestamp.h"

@implementation NSString (YFTimestamp)

+ (NSString *)yf_convastionTimeStr:(long long)time
{
    // 1.获取日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 2.获取当前时间
    NSDate *currentDate = [NSDate date];
    // 3.获取当前时间的年月日
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    NSInteger currentHour = components.hour;
    NSInteger currentMinute = components.minute;
    NSInteger currentSecond = components.second;
    // 4.获取发送时间
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    // 5.获取发送时间的年月日
    NSDateComponents *sendComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sendDate];
    NSInteger sendYear = sendComponents.year;
    NSInteger sendMonth = sendComponents.month;
    NSInteger sendDay = sendComponents.day;
    NSInteger sendHour = components.hour;
    NSInteger sendMinute = components.minute;
    NSInteger sendSecond = components.second;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    
    if (currentYear == sendYear &&
        currentMonth == sendMonth &&
        currentDay == sendDay) {// 今天发送的
        if (currentHour == sendHour &&
            currentMinute == sendMinute &&
            currentSecond == sendSecond) {
            fmt.dateFormat = @"刚刚";
        }
        fmt.dateFormat = @"今天 HH:mm";
    }else if(currentYear == sendYear &&
             currentMonth == sendMonth &&
             currentDay == sendDay + 1){// 昨天发的
        fmt.dateFormat = @"昨天 HH:mm";
    }else{// 前天以前发的
        fmt.dateFormat = @"yyyy年MM月dd日 HH:mm";
    }
    
    return [fmt stringFromDate:sendDate];
}

@end
