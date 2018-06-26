//
//  GTNetApi.m
//  GTreat
//
//  Created by luyee on 2017/6/16.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "GTNetApi.h"
#import "GTNetCustionService.h"
#import "GTNetApiUrlDefine.h"

@implementation GTNetApi

+(instancetype)netApi
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance  = [[[self class] alloc] init];
    });
    return instance;
}

-(void)login:(NSDictionary *)params callBack:(responseHandler)completeBlock{
    [self PostMethod:apiurl_login params:params responseBlock:completeBlock];
}

-(void)registerUser:(NSDictionary *)params callBack:(responseHandler)completeBlock{
    [self PostMethod:apiurl_register params:params responseBlock:completeBlock];
}

-(void)forgetPassword:(NSDictionary *)params callBack:(responseHandler)completeBlock{
    [self PostMethod:apiurl_forget params:params responseBlock:completeBlock];
}

-(void)logout:(NSDictionary *)params callBack:(responseHandler)completeBlock{
    [self PostMethod:apiurl_logout params:params responseBlock:completeBlock];
}

@end
