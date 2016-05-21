//
//  NSDate+WY.m
//  WY-BSBDJ
//
//  Created by sialice on 16/5/6.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "NSDate+WY.h"

@implementation NSDate (WY)
- (BOOL)wy_isThisYear{
    // 两个时间
    NSDate *date1 = self;
    NSDate *date2 = [NSDate date];
    
    // 把时间字符串转NSDate类型
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置时间的格式
    fmt.dateFormat = @"yyyy";
    
    NSString *dateStr1 = [fmt stringFromDate:date1];
    NSString *dateStr2 = [fmt stringFromDate:date2];
    
    return [dateStr1 isEqualToString:dateStr2];
    
}

- (BOOL)wy_isToday{
    // 两个时间
    NSDate *date1 = self;
    NSDate *date2 = [NSDate date];
    
    // 把时间字符串转NSDate类型
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置时间的格式
    fmt.dateFormat = @"yyyyMMdd";
    
    NSString *dateStr1 = [fmt stringFromDate:date1];
    NSString *dateStr2 = [fmt stringFromDate:date2];
    
    return [dateStr1 isEqualToString:dateStr2];
}


- (BOOL)wy_isYesterday{
    
    
    // 把时间字符串转NSDate类型
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置时间的格式
    
    
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = self;
    NSDate *date2 = [NSDate date];
    
    //把时分秒去除了
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr1 = [fmt stringFromDate:date1];
    NSString *dateStr2 = [fmt stringFromDate:date2];
    
    date1 = [fmt dateFromString:dateStr1];
    date2 = [fmt dateFromString:dateStr2];
    
    // 日历类
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unit fromDate:date1 toDate:date2 options:0];
    
    BOOL isYesterDay = (components.year == 0 &&  components.month == 0 && components.day == 1);
    
    
    return isYesterDay;
}

@end
