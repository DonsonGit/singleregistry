//
//  APSDBUtil.h
//  apos-enterprise-ios
//
//  Created by 刘洋 on 13-3-14.
//  Copyright (c) 2013年 cpz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EQUALS @"eq"
#define LESS_THAN @"lt"
#define GREATE_THAN @"gt"
#define LESS_EQUALS_THAN @"let"
#define GREATE_EQUALS_THAN @"get"
#define NOT_EQUALS @"neq"
#define IN @"in"
#define BETW @"in_"
#define IS  @"is"

#define SPLIT @"_"

#define AND @"and"
#define OR @"or"
#define LIKE @"like"

//用于获取反射mapping
@protocol APSDBQueryReflectMapping <NSObject>

- (NSArray* ) getMapping;

@end

@interface APSDBUtil : NSObject

+(void)initDB:(NSString *)dbname saveName:(NSString *)saveName;

+ (id) newContextObject :  (Class) objClass;

+ (BOOL) insertObj : (id) obj ;

+ (BOOL) updateObj : (id) obj;

+ (BOOL) deleteObj : (id) obj;

+ (BOOL) commitContextChange;

+ (NSArray *) queryByCond : (Class) dtoClass  queryCond : (id) cond sort : (NSSortDescriptor*) sortDescriptor maxResultSize : (int) size;
+ (NSArray *) queryByCond : (Class) dtoClass queryCond : (id) cond  sort : (NSSortDescriptor*) sortDescriptor maxResultSize : (int) size copyBlock:(id(^)(id dest,id src))copyBlock;

+ (NSArray *) queryObj:(Class) dtoClass  fieldName : (NSString*) fieldName fieldValue : (id) value;

+ (NSArray *) queryByCond:(Class) dtoClass querySql : (NSString*) sql params : (NSMutableDictionary*) params sort:(NSSortDescriptor *)sortDescriptor maxResultSize:(int)size;

+ (NSArray *) queryByCond: (Class) dtoClass querySql : (NSString*) sql params : (NSMutableDictionary*) params sort:(NSSortDescriptor *)sortDescriptor maxResultSize:(int)size  copyBlock:(id(^)(id dest,id src))copyBlock;

//+(void) reset;

+ (NSArray *) queryByCond : (Class) dtoClass queryCond : (id) cond groupByFields:(NSArray*) groupByFields countName:(NSString*) countName returnClass:(Class) returnClass;

+ (NSArray *)queryByCond:(Class)dtoClass queryCond:(id)cond sumByFields:(NSDictionary *)sumFieldsDict groupByFields:(NSDictionary *)groupByFields returnClass:(Class)returnClass;

/**
 *  一次性更新大量数据
 *
 *  @param objes 需要更新的数据
 *
 *  @return BOOL
 */
+(BOOL) updateSomeObjes:(NSArray *)objes updateBlock:(id(^)(id dest,id src))updateBlock;


@end
