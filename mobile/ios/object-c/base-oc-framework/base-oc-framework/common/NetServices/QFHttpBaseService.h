//
//  QFHttpBaseService.h
//  QFly
//
//  Created by hanlu on 16/12/30.
//  Copyright © 2016年 hanlu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QFHttpTool.h"
#import "QFHttpBaseProtocol.h"

//面向api层回调
typedef void (^responseAPIHandler)(NSURLSessionDataTask *task, id dataObj, QFHttpErrorResult *error);
//下载成功回调
typedef void(^downloadResponseAPIBlock)(NSURLResponse * response, id dataObj, QFHttpErrorResult *error);
//面向UI层回调
typedef void (^responseHandler)(id dataObj, QFHttpErrorResult *error);


/**
 * 网络通讯层基类
 *
 * 根据各项目自身约定，业务层通讯类必须实现QFHttpBaseProtocol协议方法
 */
@interface QFHttpBaseService : NSObject<QFHttpBaseProtocol>

/**
 *  发送GET(post...)请求
 *
 *  @param type                 请求类型
 *  @param urlString            请求路径
 *  @param params               请求参数
 *  @param resultClass          结果集模型Class，可以是模型对象，也可以仍是NSDictionary
 *  @param responseDataBlock    请求response回调
 */
- (void)requestWithHttpType:(HttpRequestType)type
                  urlString:(NSString *)urlString
                     params:(id)params
                resultClass:(Class)resultClass
              responseBlock:(responseAPIHandler)responseDataBlock;


/**
 *  上传文件
 *
 *  @param urlString            请求路径
 *  @param params               请求参数
 *  @param fileKeyNameArray     上传文件对应的KeyName
 *  @param fileDataArray        文件源数组
 *  @param fileNameArray        文件名
 *  @param resultClass          结果集模型Class
 *  @param responseDataBlock    请求response回调
 */
- (void)uploadFileWithUrlString:(NSString *)urlString
                         params:(id)params
                    filekeyName:(NSArray *)fileKeyNameArray
                       fileData:(NSArray *)fileDataArray
                       fileName:(NSArray *)fileNameArray
                    resultClass:(Class)resultClass
                  responseBlock:(responseAPIHandler)responseDataBlock;

/**
 *  下载文件
 *
 *  @param urlString        下载文件的网址字符串
 *  @param responseDataBlock   请求成功后的回调
 */
- (void)downloadFileWithUrlString:(NSString *)urlString
                         saveFilePath:(NSString *)saveFilePath
                    responseBlock:(downloadResponseAPIBlock)responseDataBlock;

/**
 * 缓存response数据解析后的模型对象
 */
-(void)setDataObj:(id)obj;

/**
 * 缓存response数据解析后的异常信息对象
 */
-(void)setError:(id)errorObj;

/**
 *  获取请求头
 */
- (NSMutableDictionary *)getRequestHeader;

@end
