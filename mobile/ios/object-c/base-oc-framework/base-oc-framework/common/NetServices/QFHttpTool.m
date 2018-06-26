//
//  QFHttpTool.m
//  QFly
//
//  Created by hanlu on 16/12/29.
//  Copyright © 2016年 hanlu. All rights reserved.
//

#import "QFHttpTool.h"
#import <AdSupport/AdSupport.h>

@interface QFHttpTool () {
    NSMutableDictionary * _requestHeaderDict;
}

@end

@implementation QFHttpTool

- (instancetype)init
{
    self = [super init];
    if(self) {
        _requestHeaderDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)requestWithHttpType:(HttpRequestType)type
                  urlString:(NSString *)urlString
                     params:(id)params
                    success:(responseBlock)successHandler
                    failure:(requestFailureBlock)failureHandler
{
    AFHTTPSessionManager * mgr = [self defaultRequestManager];
    
    switch (type) {
        case HttpRequestTypeGet:
        {
            [mgr.requestSerializer setQueryStringSerializationWithBlock:nil];
            [mgr GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if(successHandler) {
                            successHandler(task,responseObject);
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        if(failureHandler) {
                            failureHandler(task,error);
                        }
                    }];
            break;
        }
        case HttpRequestTypePost:
        {
            [mgr POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successHandler) {
                    successHandler(task,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failureHandler) {
                    failureHandler(task,error);
                }
            }];

            break;
        }
        case HttpRequestTypePut:
        {
            [mgr PUT:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successHandler) {
                    successHandler(task,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failureHandler) {
                    failureHandler(task,error);
                }
            }];

            break;
        }
        case HttpRequestTypeDelete:
        {
            [mgr DELETE:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successHandler) {
                    successHandler(task,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failureHandler) {
                    failureHandler(task,error);
                }
            }];

            break;
        }
        default:
            break;
    }
    
}

- (void)uploadFileWithURLString:(NSString *)urlString
                         params:(id)params
                    fileKeyName:(NSArray *)fileKeyNameArray
                       fileData:(NSArray *)fileDataArray
                       fileName:(NSArray *)fileNameArray
                        success:(responseBlock)successHandler
                        failure:(requestFailureBlock)failureHandler
{
    AFHTTPSessionManager * mgr = [self defaultRequestManager];
    
    [mgr POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < [fileDataArray count]; i ++) {
            
            NSData * imageData = [fileDataArray objectAtIndex:i];
            NSString * fileKeyName = ([fileKeyNameArray count] > i) ? fileKeyNameArray[i] : @"file";
            NSString * filename = ([fileNameArray count] > i) ? fileNameArray[i] : @"file";
            
            [formData appendPartWithFileData:imageData name:fileKeyName fileName:filename mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successHandler) {
            successHandler(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureHandler) {
            failureHandler(task,error);
        }
    }];
}

- (void)downloadFile:(NSString *)urlString
            saveFilePath:(NSString *)saveFilePath
             success:(downloadBlock)successHandler
             failure:(downloadFailureBlock)failureHandler
{
    
    AFHTTPSessionManager * manager = [self defaultRequestManager];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *pathURL = [NSURL fileURLWithPath:saveFilePath];
        return pathURL;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载完后
        if(!error) {
            if(successHandler) {
                successHandler(response, filePath);
            }
        } else {
            if(failureHandler) {
                failureHandler(response, error);
            }
        }
        
    }];
    [downloadTask resume];
}

#pragma mark - AFHTTPSessionManager初始化

-(AFHTTPSessionManager *)defaultRequestManager
{
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    
    //请求超时设定
    mgr.requestSerializer.timeoutInterval = 45;
    
    //缓存策略
    mgr.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    //安全策略
    mgr.securityPolicy.allowInvalidCertificates = YES;
    mgr.securityPolicy.validatesDomainName = NO;

    //设置接受的类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                     @"application/json",
                                                     @"text/json",
                                                     @"text/javascript",
                                                     @"text/html",
                                                     @"application/octet-stream",
                                                     @"image/png",
                                                     @"image/jpeg",nil];
    
    //设置请求内容的类型
    NSDictionary * httpHeader = [self requestHeader];
    
    [httpHeader enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [mgr.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    //json请求则需要序列化josn
    NSString * contentType = [httpHeader objectForKey:@"Content-Type"];
    if([contentType containsString:@"application/json"]) {
        [mgr.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
            if([parameters isKindOfClass:[NSDictionary class]]) {
                NSString *json =  [self convertObjectToJSON:parameters];
                return json;
            } else {
                return nil;
            }
        }];
    } else {
        [mgr.requestSerializer setQueryStringSerializationWithBlock:nil];
    }
    
    return mgr;
}

- (NSString *)convertObjectToJSON:(id)object
{
    NSError *error = nil;
    NSData  *data = nil;
    if (object) {
        data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    if (data == nil) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


- (NSMutableDictionary *)requestHeader {
    return _requestHeaderDict;
}

@end

