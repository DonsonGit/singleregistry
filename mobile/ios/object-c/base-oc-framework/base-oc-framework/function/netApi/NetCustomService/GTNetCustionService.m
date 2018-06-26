//
//  GTNetCustionService.m
//  GTreat
//
//  Created by luyee on 2018/4/12.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import "GTNetCustionService.h"

@implementation GTNetCustionService

- (void)PostMethod:(NSString *)urlString params:(id)params responseBlock:(responseHandler)response
{
    [self requestWithHttpType:HttpRequestTypePost urlString:urlString params:params resultClass:nil responseBlock:^(NSURLSessionDataTask *task, id dataObj, QFHttpErrorResult *error) {
        response(dataObj,error);
    }];
}

-(void)GetMethod:(NSString *)urlString params:(id)params responseBlock:(responseHandler)response
{
    [self requestWithHttpType:HttpRequestTypeGet urlString:urlString params:params resultClass:nil responseBlock:^(NSURLSessionDataTask *task, id dataObj, QFHttpErrorResult *error) {
        response(dataObj,error);
    }];
}

#pragma mark - overwrite protocol method

- (void)initRequestHeader
{
    //json格式
    NSMutableDictionary * requestHeader = [self getRequestHeader];
    [requestHeader setObject:@"application/json; charset=UTF-8" forKey:@"Content-Type"];
    [requestHeader setObject:@"application/json" forKey:@"Response-Content-Type"];
}

-(void)dealResponseData:(NSString *)urlString requestResponse:(id)responseObj dataModalClass:(Class)resultClass
{
    //服务器接口返回值统一处理
    NSDictionary *rawData = responseObj[@"data"] ? responseObj[@"data"] : nil;
    NSString *errorStr = responseObj[@"errMsg"] ? responseObj[@"errMsg"] : @"网络错误";
    NSString *errorCode = [NSString stringWithFormat:@"%@",responseObj[@"errCode"]];
    BOOL success = [responseObj[@"success"] boolValue];
    
    if(success) {
        // 如果指定的结果集是个模型，则转换成model
        if (resultClass && ![resultClass isSubclassOfClass:[NSDictionary class]]) {
            [self setDataObj:[resultClass mj_objectWithKeyValues:rawData]];
        } else {
            [self setDataObj:rawData];
        }
    } else {
        QFHttpErrorResult * errorResult = [[QFHttpErrorResult alloc] init];
        errorResult.errorCode = errorCode;
        errorResult.errorMsg = errorStr;
        [self setError:errorResult];
    }
}

@end
