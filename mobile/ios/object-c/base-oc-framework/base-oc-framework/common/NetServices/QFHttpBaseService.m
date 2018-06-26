//
//  QFHttpBaseService.h
//  QFly
//
//  Created by hanlu on 16/12/30.
//  Copyright © 2016年 hanlu. All rights reserved.
//

#import "QFHttpBaseService.h"
#import "MJExtension.h"

static id dataObj = nil;
static id dataError = nil;
@interface QFHttpBaseService () {
    QFHttpTool * _httpTool;
    
}

@end

@implementation QFHttpBaseService

- (instancetype)init
{
    self = [super init];
    if(self) {
        _httpTool = [[QFHttpTool alloc] init];
        
        [self initRequestHeader];
    }
    return self;
}

- (void)requestWithHttpType:(HttpRequestType)type
                  urlString:(NSString *)urlString
                     params:(id)params
                resultClass:(Class)resultClass
              responseBlock:(responseAPIHandler)responseDataBlock
{
    [self addOtherEventBeforeSendRequest:urlString];
    
    //检查网络状态，是否可以访问；网络不通，则直接返回nil
    if (![self networkStatusCheck]) {
        if(responseDataBlock) {
            responseDataBlock(nil, nil, nil);
        }
        return;
    }
    
    //有效性检测
    if([urlString length] == 0) {
        return;
    }
    
    //params如果是个model，则转换成字典
    if (params && ![params isKindOfClass:[NSDictionary class]]) {
        params = [params mj_keyValues];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //显示状态栏网络访问标示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    //请求
    [_httpTool requestWithHttpType:type urlString:urlString params:params success:^(NSURLSessionDataTask* task, id responseObj) {
        //隐藏状态栏网络访问标示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //数据解析或转化
        NSLog(@"请求Url地址：%@", urlString);
        [self dealResponseData:urlString requestResponse:responseObj dataModalClass:resultClass];
        NSLog(@"response响应：%@", responseObj);
        
        //是否拦截, 如果是，则自定义response回调过程
        BOOL isIntercept = [self isInterceptResponseCallback:urlString];
        if(isIntercept) {
            [self customResponseCallback:urlString];
            return;
        }
        
        //回调
        if(!isIntercept && responseDataBlock) {
            responseDataBlock(task, dataObj, dataError);
        }
        
    } failure:^(NSURLSessionDataTask* task, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"请求失败：%@", error);
        
        QFHttpErrorResult * errorResult = [[QFHttpErrorResult alloc] init];
        if(error.code == NSURLErrorTimedOut) {
            errorResult.errorMsg = @"请求超时";
            errorResult.errorCode = @"-1001";
        } else if (error.code == NSURLErrorNotConnectedToInternet) {
            errorResult.errorMsg = @"当前无网络连接，请稍后重试";
            errorResult.errorCode = @"-1009";
        } else {
            errorResult.errorMsg = @"网络错误";
        }
        
        if(responseDataBlock) {
            responseDataBlock(task, nil, errorResult);
        }
    }];

}

- (void)uploadFileWithUrlString:(NSString *)urlString
                         params:(id)params
                    filekeyName:(NSArray *)fileKeyNameArray
                       fileData:(NSArray *)fileDataArray
                       fileName:(NSArray *)fileNameArray
                    resultClass:(Class)resultClass
                  responseBlock:(responseAPIHandler)responseDataBlock
{
    [self addOtherEventBeforeSendRequest:urlString];
    
    //检查网络状态，是否可以访问；网络不通，则直接返回nil
    if (![self networkStatusCheck]) {
        !responseDataBlock?:responseDataBlock(nil, nil, nil);
        return;
    }
    
    //有效性检测
    if([urlString length] == 0 || [fileDataArray count] == 0 || [fileKeyNameArray count] == 0) {
        return;
    }
    
    //params如果是个model，则转换成字典
    if (![params isKindOfClass:[NSDictionary class]]) {
        params = [params mj_keyValues];
    }
    
    //状态栏网络访问标示设置
    if(![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
    }
    
    //请求
    [_httpTool uploadFileWithURLString:urlString params:params fileKeyName:fileKeyNameArray fileData:fileDataArray fileName:fileNameArray success:^(NSURLSessionDataTask *task, id responseObj) {
        //隐藏状态栏网络访问标示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //数据解析或转化
        NSLog(@"请求Url地址：%@", urlString);
        [self dealResponseData:urlString requestResponse:responseObj dataModalClass:resultClass];
        NSLog(@"response响应：%@", responseObj);
        
        //回调
        if(responseDataBlock) {
            responseDataBlock(task, dataObj, dataError);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        QFHttpErrorResult * errorResult = [[QFHttpErrorResult alloc] init];
        if(error.code == NSURLErrorTimedOut) {
            errorResult.errorMsg = @"请求超时";
            errorResult.errorCode = @"-1001";
        } else if (error.code == NSURLErrorNotConnectedToInternet) {
            errorResult.errorMsg = @"当前无网络连接，请稍后重试";
            errorResult.errorCode = @"-1009";
        } else {
            errorResult.errorMsg = @"网络错误";
        }
        
        if(responseDataBlock) {
            responseDataBlock(task, nil, errorResult);
        }
    }];
}

- (void)downloadFileWithUrlString:(NSString *)urlString
                         saveFilePath:(NSString *)saveFilePath
                    responseBlock:(downloadResponseAPIBlock)responseDataBlock
{
    [self addOtherEventBeforeSendRequest:urlString];
    
    //检查网络状态，是否可以访问；网络不通，则直接返回nil
    if (![self networkStatusCheck]) {
        !responseDataBlock?:responseDataBlock(nil, nil, nil);
        return;
    }
    
    //有效性检测
    if([urlString length] == 0 && [saveFilePath length] == 0) {
        return;
    }
    
    //状态栏网络访问标示设置
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [_httpTool downloadFile:urlString saveFilePath:saveFilePath success:^(NSURLResponse *response, NSURL *filePath) {
        //隐藏状态栏网络访问标示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"请求Url地址：%@", urlString);
        
        if(responseDataBlock) {
            responseDataBlock(response, filePath, nil);
        }
    } failure:^(NSURLResponse *response, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        QFHttpErrorResult * errorResult = [[QFHttpErrorResult alloc] init];
        if(error.code == NSURLErrorTimedOut) {
            errorResult.errorMsg = @"请求超时";
            errorResult.errorCode = @"-1001";
        } else if (error.code == NSURLErrorNotConnectedToInternet) {
            errorResult.errorMsg = @"当前无网络连接，请稍后重试";
            errorResult.errorCode = @"-1009";
        } else {
            errorResult.errorMsg = @"网络错误";
        }
        
        if(responseDataBlock) {
            responseDataBlock(response, nil, errorResult);
        }
    }];
}

-(void)setDataObj:(id)obj
{
    dataObj = nil;
    dataObj = obj;
    dataError = nil;
}

-(void)setError:(id)errorObj
{
    dataError = nil;
    dataError = errorObj;
    dataObj = nil;
}

- (NSMutableDictionary *)getRequestHeader
{
    return [_httpTool requestHeader];
}

#pragma mark- 网络状态监测

-(BOOL)networkStatusCheck
{
    __block BOOL netWorkCanUse = YES;
    AFNetworkReachabilityManager *reachabilityMgr = [AFNetworkReachabilityManager sharedManager];
    [reachabilityMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            netWorkCanUse = YES;
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            netWorkCanUse = YES;
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            netWorkCanUse = YES;
        } else if (status == AFNetworkReachabilityStatusNotReachable){
            // 网络异常处理
            netWorkCanUse = NO;
        }
    }];
    [reachabilityMgr startMonitoring];
    return netWorkCanUse;
}

#pragma mark - QFHttpBaseProtocol

/**
 * 初始化HttpRequestHeader
 *
 * 注意：Content—Type格式是否正确，是表单格式，还是json格式，或文本格式
 */
- (void)initRequestHeader
{
//    //json格式，
//    NSMutableDictionary * requestHeader = [_httpTool requestHeader];
//    [requestHeader setObject:@"application/json; charset=UTF-8" forKey:@"Content-Type"];
//    [requestHeader setObject:@"application/json" forKey:@"Response-Content-Type"];
//
//    //form表单格式
//    NSMutableDictionary * requestHeader = [_httpTool requestHeader];
//    [requestHeader setObject:@"application/x-www-form-urlencoded;charset=UTF-8;multipart/form-data" forKey:@"Content-Type"];
//    [requestHeader setObject:@"application/json" forKey:@"Response-Content-Type"];
}

/**
 * 网络请求发送前，预处理一些其他自定义事物
 */
- (void)addOtherEventBeforeSendRequest:(NSString *)urlString
{
    
}

/**
 * 对网络请求结果response的统一数据格式解析
 *
 * @params responseObj response原始数据
 * @params resultClass responseObj对应的模型名
 */
-(void)dealResponseData:(NSString *)urlString requestResponse:(id)responseObj dataModalClass:(Class)resultClass
{
    
}

/**
 * 是否拦截response原有回调
 */
- (BOOL)isInterceptResponseCallback:(NSString *)urlString
{
    return NO;
}

/**
 * 自定义response的回调过程
 *
 * 注：此方式需配合isInterceptResponseCallback一起使用
 */
- (void)customResponseCallback:(NSString *)urlString
{
    
}

@end
