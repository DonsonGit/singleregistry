//
//  QFHttpBaseProtocol.h
//  GTreat
//
//  Created by luyee on 2018/4/12.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QFHttpBaseProtocol <NSObject>

@required

/**
 * 初始化HttpRequestHeader，必须实现
 *
 * 注意：Content—Type格式是否正确，是表单格式，还是json格式，或文本格式
 */
- (void)initRequestHeader;

/**
 * 对网络请求结果response的统一数据格式解析，必须实现
 *
 * @params responseObj response原始数据
 * @params resultClass responseObj对应的模型名
 *
 */
-(void)dealResponseData:(NSString *)urlString requestResponse:(id)responseObj dataModalClass:(Class)resultClass;


@optional

/**
 * 网络请求发送前，预处理一些其他自定义事物，可选
 *
 */
- (void)addOtherEventBeforeSendRequest:(NSString *)urlString;

/**
 * 是否拦截response原有回调，可选
 */
- (BOOL)isInterceptResponseCallback:(NSString *)urlString;

/**
 * 自定义response的回调过程
 *
 * 注：此方式需配合isInterceptResponseCallback一起使用
 */
- (void)customResponseCallback:(NSString *)urlString;

@end
