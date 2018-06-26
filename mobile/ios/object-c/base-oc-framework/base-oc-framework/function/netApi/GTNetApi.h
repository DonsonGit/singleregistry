//
//  GTNetApi.h
//  GTreat
//
//  Created by luyee on 2017/6/16.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "GTNetCustionService.h"

/**
 * @class QFNetApi
 *
 * 业务类网络请求封装
 */
@interface GTNetApi : GTNetCustionService

+(instancetype)netApi;

/******************************************登录与用户信息相关***************************************/
//登录
- (void)login:(NSDictionary *)params callBack:(responseHandler)completeBlock;

//注册
-(void)registerUser:(NSDictionary *)params callBack:(responseHandler)completeBlock;

//忘记密码
-(void)forgetPassword:(NSDictionary *)params callBack:(responseHandler)completeBlock;

//登出
-(void)logout:(NSDictionary *)params callBack:(responseHandler)completeBlock;

@end
