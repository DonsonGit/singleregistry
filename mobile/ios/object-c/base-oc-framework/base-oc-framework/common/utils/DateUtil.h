//
//  DateUtil.h
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

/*
 格式化日期对象：返回指定format的日期字符串
 */
+ (NSString *)date2String:(NSDate*)date dateFormat:(NSString*)format;

/*
 构建日期对象，根据指定format的日期字符串
 */
+ (NSDate *)str2Date:(NSString*)dateStr  dateFormat:(NSString*)format;

/*
 获取Year
 */
+(NSInteger)getYear:(NSDate *)date;

/*
 获取Month
 */
+(NSInteger)getMonth:(NSDate *)date;

/*
 获取Day
 */
+(NSInteger)getDay:(NSDate *)date;

/**
 * 获取月初第一天日期
 */
+(NSDate *)getMonthStartTime:(NSDate *)date;

/**
 * 获取月尾最后一天日期
 */
+(NSDate *)getMonthEndTime:(NSDate *)date;

/**
 * 是否为同一天
 */
+ (BOOL)sameDayWithDate:(NSDate *)date1 date2:(NSDate *)date2;

@end
