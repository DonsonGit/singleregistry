//
//  DateUtil.m
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "DateUtil.h"

NSString* defaultFormat = @"yyyy-MM-dd HH:mm:ss";

@implementation DateUtil

/*
 格式化日期对象：返回指定format的日期字符串
 */
+ (NSString *) date2String : (NSDate*) date dateFormat:(NSString*) format
{
    if(date == nil) {
        return nil;
    }
    if (format == nil || [format isEqualToString:@""]) {
        format = defaultFormat;
    }
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.timeZone = [NSTimeZone localTimeZone];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

/*
 构建日期对象，根据指定format的日期字符串
 */
+ (NSDate *) str2Date : (NSString*) dateStr  dateFormat:(NSString*) format
{
    if (format == nil || [format isEqualToString:@""]) {
        format = defaultFormat;
    }
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.timeZone = [NSTimeZone localTimeZone];
    [dateFormat setDateFormat:format];
    return [dateFormat dateFromString:dateStr];
}

/*
 获取Year
 */
+(NSInteger)getYear:(NSDate *)date
{
    NSCalendar *calendar      = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *com     =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    return com.year;
}

/*
 获取Month
 */
+(NSInteger)getMonth:(NSDate *)date
{
    NSCalendar *calendar      = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *com     =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    return com.month;
}

/*
 获取Day
 */
+(NSInteger)getDay:(NSDate *)date
{
    NSCalendar *calendar      = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *com     =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    return com.day;
}

/**
 * 获取月初第一天日期
 */
+(NSDate *)getMonthStartTime:(NSDate *)date
{
    NSCalendar *calendar      = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags =  NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    
    NSDateComponents *com =  [calendar components:unitFlags fromDate:date];
    com.day = 1;
    com.hour = 0;
    com.minute = 0;
    com.second = 0;
    com.nanosecond = 0;
    
    return [calendar dateFromComponents:com];
}

/**
 * 获取月尾最后一天日期
 */
+(NSDate *)getMonthEndTime:(NSDate *)date
{
    NSCalendar *calendar      = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags      = NSCalendarUnitYear    |
    NSCalendarUnitMonth   |
    NSCalendarUnitDay     |
    NSCalendarUnitHour    |
    NSCalendarUnitMinute  |
    NSCalendarUnitSecond;
    
    NSDateComponents *com     =  [calendar components:unitFlags fromDate:date];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    com.day = range.length;
    com.hour = 23;
    com.minute = 59;
    com.second = 59;
    com.nanosecond = 0;
    
    return [calendar dateFromComponents:com];
}

/**
 * 是否为同一天
 */
+ (BOOL)sameDayWithDate:(NSDate *)date1 date2:(NSDate *)date2
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date1];
    [components1 setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger day1 = [components1 day];
    NSInteger month1= [components1 month];
    NSInteger year1= [components1 year];
    
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date2];
    [components2 setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger day2 = [components2 day];
    NSInteger month2= [components2 month];
    NSInteger year2= [components2 year];
    
    if(day1 == day2 && month1 == month2 && year1 == year2) {
        return YES;
    } else {
        return NO;
    }
}


//获取时差
+ (NSString *)getDateDiff:(NSDate *)nowDate fromDate:(NSDate *)fromDate defaultSecond:(BOOL)enableDefaultSecond
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags      = NSCalendarUnitYear    |
    NSCalendarUnitMonth   |
    NSCalendarUnitDay     |
    NSCalendarUnitHour    |
    NSCalendarUnitMinute  |
    NSCalendarUnitSecond;
    
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:fromDate toDate:nowDate options:0];
    if(enableDefaultSecond) {
        if(comps.year == 0 && comps.month == 0 && comps.day == 0 && comps.hour == 0 && comps.minute == 0) {
            comps.minute = 1;
        }
    }
    
    return [NSString stringWithFormat:@"%02d天%02d时%02d分", (int)comps.day, (int)comps.hour, (int)comps.minute];
}

@end
