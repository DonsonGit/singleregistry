//
//  ValidateUtil.h
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateUtil : NSObject

/**
 检测是否为空
 */
+ (BOOL)isEmptyOrNull:(NSString*)string;

/**
 检查手机号码是否有效
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 检查身份证号码是否为有效
 */
+ (BOOL)isIDCardNumberCorrect:(NSString *)string;

/**
 检查邮箱地址是否有效
 */
+ (BOOL)isEmailAddress:(NSString*)email;


/**
 检查是否为纯汉字
 
 @param realname 字符串参数
 @return 是否
 */
+ (BOOL)isValidateChinaChar:(NSString *)realname;

@end
