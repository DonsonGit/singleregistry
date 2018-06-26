//
//  APSSumByBaseObject.h
//  TestCoreData
//
//  Created by hanlu on 15/1/5.
//  Copyright (c) 2015年 hanlu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APSSumByBaseObject : NSObject

//求和字典：求和字段->结果字段名
@property (nonatomic, strong) NSDictionary * sumFieldDict;

//分组字典：分组字段->结果字段名
@property (nonatomic, strong) NSDictionary * groupFieldDict;

@end
