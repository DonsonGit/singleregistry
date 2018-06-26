//
//  NSManagedObject+NSManagedObject_APSDBAddtion.m
//  apos-enterprise-ios
//
//  Created by 刘洋 on 13-3-15.
//  Copyright (c) 2013年 cpz. All rights reserved.
//

#import "NSObject+APSDBAddtion.h"
#import "APSDBUtil.h"
#import "APSGroupByBaseObject.h"
#import "APSSumByBaseObject.h"

@implementation NSObject (APSDBAddtion) 

    
//    NSManagedObjectID *objId;



+ (id) newInstance {
    return [self new];
}

//保存对象
- (BOOL) save {
    return [APSDBUtil insertObj:self];
}

- (BOOL) update {
    return [APSDBUtil updateObj:self];
}


- (BOOL) del {
    return [APSDBUtil deleteObj:self];
}

+ (NSArray*) findByFiled : (NSString*) fieldName fieldValue : (id) value {
    return [APSDBUtil queryObj:[self class]  fieldName:fieldName fieldValue:value];
}

+ (NSArray*) findByCond : (id) cond  sort : (NSSortDescriptor*) sortDescriptor maxResultSize : (int) size {
    return [self findByCond:cond sort:sortDescriptor maxResultSize:size copyBlock:nil];
}
/**
 *  原有的数据库对象赋值采用的是发射机制 效率比较慢 ,通过具体类赋值能大大加快效率  如果数据量可能达到好几千的级别建议使用
 *
 */
+ (NSArray*) findByCond : (id) cond  sort : (NSSortDescriptor*) sortDescriptor maxResultSize : (int) size copyBlock:(id(^)(id dest,id src))copyBlock{
    return [APSDBUtil queryByCond:[self class] queryCond:cond sort:sortDescriptor maxResultSize:size copyBlock:copyBlock];
}

+ (NSArray *) queryCond : (id) cond groupByObject:(APSGroupByBaseObject*) groupObject {
   
    return [APSDBUtil queryByCond:[self class] queryCond:cond groupByFields:[groupObject getGroupByFileds] countName:[groupObject getCountFiledName] returnClass:[groupObject class]];
}

+ (NSArray *)queryCond:(id)cond sumByObject:(APSSumByBaseObject*)sumObject returnClass:(Class)returnClass
{
    return [APSDBUtil queryByCond:[self class] queryCond:cond sumByFields:sumObject.sumFieldDict groupByFields:sumObject.groupFieldDict returnClass:returnClass];
}



@end
