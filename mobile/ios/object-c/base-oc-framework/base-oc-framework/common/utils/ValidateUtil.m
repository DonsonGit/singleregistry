//
//  ValidateUtil.m
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "ValidateUtil.h"

@implementation ValidateUtil

/**
 检测是否为空
 */
+ (BOOL)isEmptyOrNull:(NSString*)string
{
    if([string isKindOfClass:[NSNull class]]){
        return YES;
    }
    
    if ([string isKindOfClass:[NSNumber class]]) {
        if (string != nil) {
            return  NO;
        }
        return YES;
    } else {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (string != nil && string.length > 0 && ![string isEqualToString:@"null"]&&![string isEqualToString:@"(null)"]&&![string isEqualToString:@" "]) {
            return  NO;
        }
        return YES;
    }
}

/**
 检查手机号码是否有效
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3,})\\d{7,}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestphs evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

/**
 检查身份证号码是否为有效
 */
+ (BOOL)isIDCardNumberCorrect:(NSString *)string{
    if (string.length == 0) {
        //        return NO;
        return YES;

    }
    if (string.length == 15 || string.length == 18) {
    } else {
        return NO;
    }
    // 身份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    if (![areasArray containsObject:[string substringToIndex:2]]) {
        return NO;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    NSInteger year = 0;
    switch (string.length) {
        case 15:
            year = [string substringWithRange:NSMakeRange(6, 2)].integerValue + 1900;
            if (year % 400 == 0 || (year % 100 != 0 && year % 4== 0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];
            }

            numberofMatch = [regularExpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
            if (numberofMatch > 0) {
                return YES;
            } else {
                return NO;
            }
            break;
        case 18:
            year = [string substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 400 == 0 || (year % 100 != 0 && year % 4== 0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];
            } else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];
            }
            numberofMatch = [regularExpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
            if (numberofMatch > 0) {
                int S = ([string substringWithRange:NSMakeRange(0,1)].intValue + [string substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([string substringWithRange:NSMakeRange(1,1)].intValue + [string substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([string substringWithRange:NSMakeRange(2,1)].intValue + [string substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([string substringWithRange:NSMakeRange(3,1)].intValue + [string substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([string substringWithRange:NSMakeRange(4,1)].intValue + [string substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([string substringWithRange:NSMakeRange(5,1)].intValue + [string substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([string substringWithRange:NSMakeRange(6,1)].intValue + [string substringWithRange:NSMakeRange(16,1)].intValue) *2 + [string substringWithRange:NSMakeRange(7,1)].intValue *1 + [string substringWithRange:NSMakeRange(8,1)].intValue *6 + [string substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[string substringWithRange:NSMakeRange(17, 1)]]) {
                    return YES;
                } else {
                    return NO;
                }
            } else {
                return NO;
            }

            break;


        default:
            break;
    }
    return YES;
}

/**
 检查邮箱地址是否有效
 */
+ (BOOL)isEmailAddress:(NSString*)email
{
    
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateChinaChar:(NSString *)realname
{
    NSString *regexStr = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:realname];
}

@end
