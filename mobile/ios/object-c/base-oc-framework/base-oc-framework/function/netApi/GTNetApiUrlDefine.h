//
//  GTNetApiUrlDefine.h
//  GTreat
//
//  Created by luyee on 2017/6/16.
//  Copyright © 2017年 Luyee. All rights reserved.
//
//  业务类网络请求Url的定义
//

#ifndef GTNetApiUrlDefine_h
#define GTNetApiUrlDefine_h

#define USE_HTTPS 1

#if USE_HTTPS
#define http_type @"https://"
#else
#define http_type @"http://"
#endif

#define HOST_URL_CONCAT(STRA,STRB)      [NSString stringWithFormat:@"%@%@",STRA,STRB]
#define URL_CONCAT(STRA,STRB)           [NSString stringWithFormat:@"%@/%@",STRA,STRB]

//测试环境
#define domain                      HOST_URL_CONCAT(http_type, @"test-zhzl.spacecig.com/zhzlApp")

/******************************************用户信息相关BEGIN***********************************/

//用户登录
#define apiurl_login                            URL_CONCAT(domain, @"bmUser/login")

//用户注册
#define apiurl_register                         URL_CONCAT(domain, @"bmUser/addUser")

//忘记密码
#define apiurl_forget                           URL_CONCAT(domain, @"bmUser/changePassword")

//登出
#define apiurl_logout                           URL_CONCAT(domain, @"bmUser/quit")

/******************************************用户信息相关END***********************************/

#endif /* GTNetApiUrlDefine_h */
