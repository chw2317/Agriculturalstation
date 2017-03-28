//
//  DateUtil.m
//  Agriculturalstation
//
//  Created by chw on 17/3/23.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

// 获取当前系统时间的 时间戳
+ (NSInteger)getNowTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // 设置你想要的格式，hh与HH的区别：分别表示12小时制，24小时制
    // 设置时区，这个对于时间的处理有时很重要
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date]; // 现在时间
    // 时间转时间戳的方法
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    return timeSp;
}

// 将某个时间转化成 时间戳
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // 设置你想要的格式，hh与HH的区别：分别表示12小时制，24小时制
    // 设置时区，这个对于时间的处理有时很重要
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *date = [formatter dateFromString:formatTime]; // 将字符串按formatter转成nsdate
    // 时间转时间戳的方法
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    return timeSp;
}

// 将某个时间戳转化成 时间
+ (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // 设置你想要的格式，hh与HH的区别：分别表示12小时制，24小时制
    // 设置时区，这个对于时间的处理有时很重要
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

// 获取当前时间的年、月、日、时、分、秒
+ (NSInteger)getTimeByFormatter:(NSString *)formatter{
    // 获取当前时间
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    if([formatter isEqualToString:@"yyyy"]){
        return [dateComponent year];
    }else if ([formatter isEqualToString:@"MM"]){
        return [dateComponent month];
    }else if ([formatter isEqualToString:@"dd"]){
        return [dateComponent day];
    }else if ([formatter isEqualToString:@"HH"]){
        return [dateComponent hour];
    }else if ([formatter isEqualToString:@"mm"]){
        return [dateComponent minute];
    }else if ([formatter isEqualToString:@"ss"]){
        return [dateComponent second];
    }
    return -1;
}
@end






































