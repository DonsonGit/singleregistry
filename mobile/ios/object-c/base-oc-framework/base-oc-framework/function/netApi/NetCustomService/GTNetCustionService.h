//
//  GTNetCustionService.h
//  GTreat
//
//  Created by luyee on 2018/4/12.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import "QFHttpBaseService.h"

@interface GTNetCustionService : QFHttpBaseService

/**
 *  对requestWithHttpType封装简化
 *
 *  @param urlString            请求路径
 *  @param params               请求参数
 *  @param response             请求response回调
 */
- (void)PostMethod:(NSString *)urlString params:(id)params responseBlock:(responseHandler)response;

/**
 *  对HttpRequestTypeGet封装简化
 *
 *  @param urlString            请求路径
 *  @param params               请求参数
 *  @param response             请求response回调
 */
-(void)GetMethod:(NSString *)urlString params:(id)params responseBlock:(responseHandler)response;

@end
