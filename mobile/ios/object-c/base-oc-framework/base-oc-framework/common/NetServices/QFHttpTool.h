//
//  QFHttpTool.h
//  QFly
//
//  Created by hanlu on 16/12/29.
//  Copyright © 2016年 hanlu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "QFHttpErrorResult.h"

//request成功回调
typedef void (^responseBlock)(NSURLSessionDataTask* task, id responseObj);
//request失败回调
typedef void (^requestFailureBlock)(NSURLSessionDataTask *task, NSError *error);
//下载成功回调
typedef void(^downloadBlock)(NSURLResponse * response, NSURL * filePath);
//下载失败回调
typedef void(^downloadFailureBlock)(NSURLResponse * response, NSError *error);

//HTTP请求类型
typedef NS_ENUM(NSUInteger, HttpRequestType){
    HttpRequestTypeGet = 0,
    HttpRequestTypePost,
    HttpRequestTypePut,
    HttpRequestTypeDelete,
};

@interface QFHttpTool : NSObject

/**
 *  发送GET(post...)请求
 *
 *  @param type             请求类型
 *  @param urlString        请求路径
 *  @param params           请求参数
 *  @param successHandler   请求成功后的回调
 *  @param failureHandler   请求失败后的回调
 */
- (void)requestWithHttpType:(HttpRequestType)type
                  urlString:(NSString *)urlString
                     params:(id)params
                    success:(responseBlock)successHandler
                    failure:(requestFailureBlock)failureHandler;

/**
 *  上传图片
 *
 *  @param urlString        上传文件的网址字符串
 *  @param params           上传文件参数
 *  @param fileKeyNameArray 上传文件对应的KeyName
 *  @param fileDataArray    上传文件原始数据
 *  @param fileNameArray    文件名
 *  @param successHandler   请求成功后的回调
 *  @param failureHandler   请求失败后的回调
 */
- (void)uploadFileWithURLString:(NSString *)urlString
                          params:(id)params
                    fileKeyName:(NSArray *)fileKeyNameArray
                       fileData:(NSArray *)fileDataArray
                       fileName:(NSArray *)fileNameArray
                         success:(responseBlock)successHandler
                         failure:(requestFailureBlock)failureHandler;

/**
 *  下载文件
 *
 *  @param urlString        下载文件的网址字符串
 *  @param successHandler   请求成功后的回调
 *  @param failureHandler   请求失败后的回调
 */
- (void)downloadFile:(NSString *)urlString
            saveFilePath:(NSString *)saveFilePath
             success:(downloadBlock)successHandler
             failure:(downloadFailureBlock)failureHandler;

/**
 *  获取请求头
 */
- (NSMutableDictionary *)requestHeader;

@end
