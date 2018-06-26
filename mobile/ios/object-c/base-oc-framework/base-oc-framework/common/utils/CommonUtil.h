//
//  CommonUtil.h
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

/**
 * Json and Object 互转
 */
+ (id)convertJSONToObject:(NSString *)string;
+ (NSString *)convertObjectToJSON:(id)object;

/**
 * 判断身份证号性别
 *
 * @param idCard 身份证号
 *
 * @return 0:未知 1:男性 2:女性
 */
+ (int)sexFromIdCard:(NSString *)idCard;

/**
 * 压缩图片质量大小
 *
 * @param image 原图
 * @param maxFileSize 压缩后，图片允许的最大字节
 *
 * @return 压缩后图片
 */
+ (NSData *)compressImage:(UIImage *)image toMaxFileSize:(CGFloat)maxFileSize;

/**
 * 创建文本类型BarButtonItem
 *
 * @param title 文本
 * @param color 颜色
 * @param size 文本字号
 * @param controller 导航栏
 * @param sel 响应方法
 *
 * @return BarButton
 */
+ (UIButton *)createRightTitleBarItem:(NSString *)title color:(UIColor *)color fontsize:(CGFloat)size viewcontroller:(UIViewController *)controller selector:(SEL)sel;

/**
 * 创建图片类型BarButtonItem
 *
 * @param image 图片
 * @param controller 导航栏
 * @param sel 响应方法
 *
 * @return BarButton
 */
+ (UIButton *)createRightImageBarItem:(UIImage *)image viewcontroller:(UIViewController *)controller selector:(SEL)sel;

/**
 * 创建文本类型BarButtonItem
 *
 * @param title 文本
 * @param color 颜色
 * @param size 文本字号
 * @param controller 导航栏
 * @param sel 响应方法
 *
 * @return BarButton
 */
+ (UIButton *)createLeftTitleBarItem:(NSString *)title color:(UIColor *)color fontsize:(CGFloat)size viewcontroller:(UIViewController *)controller selector:(SEL)sel;

/**
 * 创建图片类型BarButtonItem
 *
 * @param image 图片
 * @param controller 导航栏
 * @param sel 响应方法
 *
 * @return BarButton
 */
+ (UIButton *)createLeftImageBarItem:(UIImage *)image viewcontroller:(UIViewController *)controller selector:(SEL)sel;

/**
 * 将文件copy到tmp目录
 */
+ (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL;

@end
