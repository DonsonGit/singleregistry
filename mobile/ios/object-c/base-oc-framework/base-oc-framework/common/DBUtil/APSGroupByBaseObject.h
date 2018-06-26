//
//  APSGroupByBaseObject.h
//  apos-enterprise-ios
//
//  Created by cpz on 14/12/3.
//  Copyright (c) 2014年 cpz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+APSDBAddtion.h"


@interface APSGroupByBaseObject : NSObject<APSDBGroupByDelefate>


@property (nonatomic) NSInteger dataCount;


@property (nonatomic,strong) NSString *countFiledName;

@property (nonatomic,strong) NSArray *groupByFileds;


@end
