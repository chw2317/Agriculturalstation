//
//  DateUtil.h
//  Agriculturalstation
//
//  Created by chw on 17/3/23.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

#pragma mark - 获取当前时间的 时间戳
+ (NSInteger)getNowTimestamp;

#pragma mark - 将某个时间转化成 时间戳
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

#pragma mark - 将某个时间戳转化成 时间
+ (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

#pragma mark - 获取当前时间的年、月、日、时、分、秒
+ (NSInteger)getTimeByFormatter:(NSString *)formatter;
@end
