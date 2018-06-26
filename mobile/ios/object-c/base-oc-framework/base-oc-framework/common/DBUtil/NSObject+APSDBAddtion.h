//
//  NSManagedObject+NSManagedObject_APSDBAddtion.h
//  apos-enterprise-ios
//
//  Created by 刘洋 on 13-3-15.
//  Copyright (c) 2013年 cpz. All rights reserved.
//

#import <CoreData/CoreData.h>
@class APSGroupByBaseObject;
@class APSSumByBaseObject;

static char const * const NSManagedObjectIDKey = "NSManagedObjectID";


@protocol APSModelRound <NSObject>

-(void) roundNSDecimalNumber;

@end


@protocol APSDBGroupByDelefate <NSObject>

@optional

-(NSString*) getCountFiledName;

-(NSArray*) getGroupByFileds;

@end

@interface NSObject (APSDBAddtion) 

- (BOOL) save;

- (BOOL) update;

- (BOOL) del;

//- (void) setManagedObjectId : (NSManagedObjectID*) mid;
//
//- (NSManagedObjectID*) getManagedObjectId;

+ (id) newInstance;

+ (NSArray*) findByFiled : (NSString*) fieldName fieldValue : (id) value;

+ (NSArray*) findByCond : (id) cond  sort : (NSSortDescriptor*) sortDescriptor maxResultSize : (int) size;

/**
 *  原有的数据库对象赋值采用的是发射机制 效率比较慢 ,通过具体类赋值能大大加快效率  如果数据量可能达到好几千的级别建议使用
 *
 */
+ (NSArray*) findByCond : (id) cond  sort : (NSSortDescriptor*) sortDescriptor maxResultSize : (int) size copyBlock:(id(^)(id dest,id src))copyBlock;


//+ (Class) getRefrenceCObjClass;

+ (NSArray *) queryCond : (id) cond groupByObject:(APSGroupByBaseObject*) groupObject;

+ (NSArray *)queryCond:(id)cond sumByObject:(APSSumByBaseObject*)sumObject returnClass:(Class)returnClass;

@end
