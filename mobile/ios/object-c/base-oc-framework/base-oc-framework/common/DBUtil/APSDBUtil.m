
//
//  APSDBUtil.m
//  apos-enterprise-ios
//
//  Created by 刘洋 on 13-3-14.
//  Copyright (c) 2013年 cpz. All rights reserved.
//

#include <objc/runtime.h>

#import "APSDBUtil.h"
#import "AppDelegate.h"
#import "NSObject+APSDBAddtion.h"
#import "APSBeanUtils.h"
#import <CoreData/CoreData.h>




static NSMutableDictionary * mappings;
static NSMutableDictionary * operatorMappings;

@interface APSDBUtil(Private)

+ (NSString *) generateQueySql : (id) queryCond args : (NSMutableDictionary *) argMappings;

@end

@implementation APSDBUtil

static NSManagedObjectModel *managedObjectModel;
static NSManagedObjectContext *managedObjectContext;
static NSPersistentStoreCoordinator *persistentStoreCoordinator;

static  NSConditionLock  *syCondition;
static  dispatch_queue_t apsDBQueue;

+ (void)initDB:(NSString *)dbname saveName:(NSString *)saveName
{
    dispatch_sync(apsDBQueue, ^{
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    });
}

+ (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [[self class] persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return managedObjectContext;
}


+ (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GTreatCH" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    //从本地所有xcdatamodel文件中获得这个CoreData的数据模板
    //managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}


+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"GTreatCH.sqlite"]];
    
    NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[[self class] managedObjectModel]];
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeUrl
                                                        options:optionsDictionary
                                                          error:&error]) {
        NSLog(@"error [%@]", error);
    }
    return persistentStoreCoordinator;
}

+ (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (void) initialize {
    mappings = [[NSMutableDictionary alloc] init];
    operatorMappings = [[NSMutableDictionary alloc] init];
    [mappings setObject:@"=" forKey:EQUALS];
    [mappings setObject:@"<" forKey:LESS_THAN];
    [mappings setObject:@">" forKey:GREATE_THAN];
    [mappings setObject:@"<=" forKey:LESS_EQUALS_THAN];
    [mappings setObject:@">=" forKey:GREATE_EQUALS_THAN];
    [mappings setObject:@"!=" forKey:NOT_EQUALS];
    [mappings setObject:@"in" forKey:IN];
    [mappings setObject:@"is" forKey:IS];
    [mappings setObject:@"like" forKey:LIKE];
    
    [operatorMappings setObject:@"and" forKey:AND];
    [operatorMappings setObject:@"or" forKey:OR];
    syCondition = [[NSConditionLock alloc] init];
    apsDBQueue = dispatch_queue_create("aps.database.operation.queue",nil);
    
    
    
}

//+(void) reset {
//    NSManagedObjectContext * context = [(APSAppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
//    [context reset];
//    [context deletedObjects];
//
//}

+ (BOOL) insertObj : (id) obj {
    __block BOOL flag = false;
    dispatch_sync(apsDBQueue, ^{
        NSManagedObjectContext * context = [self managedObjectContext];
        [context performBlockAndWait:^{
            NSManagedObject *contextObj = [self newContextObject:[obj class]];
            [APSBeanUtils copyProperties:obj dest:contextObj];
            objc_setAssociatedObject(obj, NSManagedObjectIDKey, contextObj.objectID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            flag = [self commitContextChange];
        }];
    });
    return flag;
}

+ (BOOL) updateObj : (id) obj{
    __block BOOL flag = false;
    dispatch_sync(apsDBQueue, ^{
        @try {
            NSManagedObjectContext * context = [self managedObjectContext];
            [context performBlockAndWait:^{
                NSManagedObject *contextObj = [context objectWithID:objc_getAssociatedObject(obj, NSManagedObjectIDKey)];
                [APSBeanUtils copyProperties:obj dest:contextObj];
                flag = [self commitContextChange];
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception.reason);
        }
        @finally {
            
        }
       
    });
    return flag;
}


/**
 *  一次性更新大量数据
 *
 *  @param objes 需要更新的数据
 *
 */
+(BOOL) updateSomeObjes:(NSArray *)objes updateBlock:(id(^)(id dest,id src))updateBlock{
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
    __block BOOL flag = false;
    dispatch_sync(apsDBQueue, ^{
        NSManagedObjectContext * context = [self managedObjectContext];
        [context performBlockAndWait:^{
            for (id obj in objes) {
                NSManagedObject *contextObj = [context objectWithID:objc_getAssociatedObject(obj, NSManagedObjectIDKey)];
                if (updateBlock) {
                    updateBlock(contextObj,obj);
                }
            }
            flag = [self commitContextChange];
        }];
    });
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    NSLog(@"update_start:%f   update_end:%f  interval:%f",start,end,end - start);
    return flag;
    
}

+ (BOOL)deleteObj:(id)obj{
    __block BOOL flag = false;
    dispatch_sync(apsDBQueue, ^{
        NSManagedObjectContext * context = [self managedObjectContext];
//        [context lock];
        [context performBlockAndWait:^{
            NSManagedObject *contextObj = [context objectWithID:objc_getAssociatedObject(obj, NSManagedObjectIDKey)];
            [context deleteObject:contextObj];
            flag = [self commitContextChange];
        }];
//        [context unlock];
    });
    return flag;
    
}

+ (id) newContextObject : (Class) objClass{
    NSManagedObjectContext * context = [self managedObjectContext];
    return (id)([NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(objClass) inManagedObjectContext:context]);
}

+ (NSArray *) queryByCond: (Class) dtoClass querySql : (NSString*) sql params : (NSMutableDictionary*) params sort:(NSSortDescriptor *)sortDescriptor maxResultSize:(int)size {
    return [self queryByCond:dtoClass querySql:sql params:params sort:sortDescriptor maxResultSize:size copyBlock:nil];
    
}

+ (NSArray *) queryByCond: (Class) dtoClass querySql : (NSString*) sql params : (NSMutableDictionary*) params sort:(NSSortDescriptor *)sortDescriptor maxResultSize:(int)size  copyBlock:(id(^)(id dest,id src))copyBlock{
    __block NSArray *results = nil;
    __block NSMutableArray *dtoResults = [NSMutableArray new];
    dispatch_sync(apsDBQueue, ^{
        
        NSManagedObjectContext * context = [self managedObjectContext];
//        [context lock];
        [context performBlockAndWait:^{
            NSFetchRequest * request = [[NSFetchRequest alloc] init];
            //设置请求的数据表对象
            NSEntityDescription *entity =  [NSEntityDescription entityForName:NSStringFromClass(dtoClass) inManagedObjectContext:context];
            [request setEntity:entity];
            if(sortDescriptor != nil) {
                [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            }
            NSLog(@"query sql %@", sql);
            
            NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:sql];
            [request setPredicate:[predicateTemplate predicateWithSubstitutionVariables: params]];
            
            //设置最大返回条数
            [request setFetchLimit:size];
            NSError * error = nil;
            //        CFTimeInterval start1 = CFAbsoluteTimeGetCurrent();
            
            results =[context executeFetchRequest: request error: &error];
            
            //        CFTimeInterval end1 = CFAbsoluteTimeGetCurrent();
            //        APOSDLog(@"fetch_start:%f   fetch_end:%f  interval:%f",start1,end1,end1 - start1);
            
            //        CFTimeInterval start = CFAbsoluteTimeGetCurrent();
            
            if(error != nil) {
                NSLog(@"queryObj happend error, the error is %@, %@", error, [error userInfo]);
            }
            for (NSManagedObject* obj in results) {
                if([(NSObject *)obj respondsToSelector:@selector(roundNSDecimalNumber)] == YES )
                {
                    [(id<APSModelRound>)obj roundNSDecimalNumber];
                }
                id dto = [dtoClass new];
                if (copyBlock) {
                    copyBlock(dto,obj);
                }else{
                    [APSBeanUtils copyProperties:obj dest:dto];
                }
                //            [dto setManagedObjectId:obj.objectID];
                objc_setAssociatedObject(dto, NSManagedObjectIDKey, obj.objectID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [dtoResults addObject:dto];
            }
            //        CFTimeInterval end = CFAbsoluteTimeGetCurrent();
            //        APOSDLog(@"copy_start:%f   copy_end:%f  interval:%f",start,end,end - start);
        }];
//        [context unlock];
    });
    return dtoResults;
    
}



+ (NSArray *) queryByCond : (Class) dtoClass queryCond : (id) cond groupByFields:(NSArray*) groupByFields countName:(NSString*) countName returnClass:(Class) returnClass{
    
    __block NSMutableArray *returnObjects = nil;
    
    
    dispatch_sync(apsDBQueue, ^{
        NSMutableDictionary *vars = [NSMutableDictionary new];
        NSString* sql=[self generateQueySql:cond args:vars];
        
        
        NSManagedObjectContext * context = [self managedObjectContext];
        [context performBlockAndWait:^{
            NSEntityDescription* entity = [NSEntityDescription entityForName:NSStringFromClass(dtoClass)
                                                      inManagedObjectContext:context];
            
            NSFetchRequest * request = [[NSFetchRequest alloc] init];
            [request  setEntity:entity];
            
            NSExpression *keyPathExpression = [NSExpression expressionForKeyPath: countName]; // Does not really matter
            NSExpression *countExpression = [NSExpression expressionForFunction: @"count:"
                                                                      arguments: [NSArray arrayWithObject:keyPathExpression]];
            
            
            
            NSExpressionDescription *expressionCountDescription = [[NSExpressionDescription alloc] init];
            [expressionCountDescription setName: @"count"];
            [expressionCountDescription setExpression: countExpression];
            [expressionCountDescription setExpressionResultType: NSInteger32AttributeType];
            
            NSMutableArray *descs = [NSMutableArray array];
            for(NSString* field in groupByFields) {
                NSAttributeDescription* desc = [entity.attributesByName objectForKey:field];
                [descs addObject:desc];
                
            }
            
            NSMutableArray *descsCopy = [descs mutableCopy];
            [descsCopy addObject:expressionCountDescription];
            [request setPropertiesToFetch:descsCopy];
            [request setPropertiesToGroupBy:descs];
            
            NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:sql];
            [request setPredicate:[predicateTemplate predicateWithSubstitutionVariables: vars]];
            
            [request setResultType:NSDictionaryResultType];
            NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
            returnObjects = [NSMutableArray new];
            for (NSObject *obj in fetchedObjects) {
                
                NSObject *returnObj = [[returnClass alloc] init];
                
                id value = [obj valueForKey:@"count"];
                [returnObj setValue:value forKey:@"dataCount"];
                
                u_int count;
                objc_property_t* properties = class_copyPropertyList(returnClass, &count);
                
                for (int i = 0; i < count ; i++)
                {
                    NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
                    id value = [obj valueForKey:propertyName];
                    if(value) {
                        [returnObj setValue:value forKey:propertyName];
                    }
                    
                }
                
                [returnObjects  addObject:returnObj];
            }
        }];
    });
    
    return returnObjects;
    
}

+ (NSArray *)queryByCond:(Class)dtoClass queryCond:(id)cond sumByFields:(NSDictionary *)sumFieldsDict groupByFields:(NSDictionary *)groupByFields returnClass:(Class)returnClass
{
    __block NSMutableArray *returnObjects = nil;
    
    
    dispatch_sync(apsDBQueue, ^{
        NSMutableDictionary *vars = [NSMutableDictionary new];
        NSString* sql=[self generateQueySql:cond args:vars];
        
        
        NSManagedObjectContext * context = [self managedObjectContext];
        [context performBlockAndWait:^{
            NSEntityDescription* entity = [NSEntityDescription entityForName:NSStringFromClass(dtoClass)
                                                      inManagedObjectContext:context];
            
            NSFetchRequest * request = [[NSFetchRequest alloc] init];
            [request  setEntity:entity];
            
            //求和属性集合
            NSMutableArray * expressionDescArray = [[NSMutableArray alloc] init];
            NSArray * keyArray = [sumFieldsDict allKeys];
            for (NSString * temp in keyArray) {
                NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
                NSString * keyPath = [NSString stringWithFormat:@"@sum.%@", temp];
                expressionDescription.expression = [NSExpression expressionForKeyPath:keyPath];
                expressionDescription.name = [sumFieldsDict objectForKey:temp];
                expressionDescription.expressionResultType = NSDecimalAttributeType;
                
                [expressionDescArray addObject:expressionDescription];
            }
            
            //分组属性集合
            NSMutableArray * groupByArray = [[NSMutableArray alloc] init];
            keyArray = [groupByFields allKeys];
            for(NSString* field in keyArray) {
                NSAttributeDescription* desc = [entity.attributesByName objectForKey:field];
                [groupByArray addObject:desc];
                [expressionDescArray addObject:desc];
            }
            
            
            //检索字段
            if([expressionDescArray count] > 0) {
                [request setPropertiesToFetch:expressionDescArray];
            }
            
            //分组
            if([groupByArray count] > 0) {
                [request setPropertiesToGroupBy:groupByArray];
            }
            
            //WHERE条件
            NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:sql];
            [request setPredicate:[predicateTemplate predicateWithSubstitutionVariables: vars]];
            [request setResultType:NSDictionaryResultType];
            
            
            //结果集转换
            NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
            returnObjects = [NSMutableArray new];
            for (NSObject *obj in fetchedObjects) {
                
                NSObject *returnObj = [[returnClass alloc] init];
                
                //            //sum:
                //            NSArray * keyValues = [sumFieldsDict allValues];
                //            for (NSString * temp in keyValues) {
                //                NSDecimalNumber * sum = [obj valueForKey:temp];
                //                [returnObj setValue:sum forKey:temp];
                //            }
                
                //Group:
                NSArray *keyArray = [groupByFields allKeys];
                for (NSString * temp in keyArray) {
                    NSString * value = [obj valueForKey:temp];
                    NSString * modalKey = [groupByFields objectForKey:temp];
                    [returnObj setValue:value forKey:modalKey];
                }
                
                //根据retunModal的属性名赋值
                u_int count;
                objc_property_t* properties = class_copyPropertyList(returnClass, &count);
                for (int i = 0; i < count ; i++)
                {
                    NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
                    id value = [obj valueForKey:propertyName];
                    if(value) {
                        [returnObj setValue:value forKey:propertyName];
                    }
                    
                }
                
                [returnObjects  addObject:returnObj];
            }
        }];
    });
    
    return returnObjects;
}

+ (NSArray *) queryByCond : (Class) dtoClass queryCond : (id) cond  sort : (NSSortDescriptor*) sortDescriptor maxResultSize : (int) size{
    return  [self queryByCond:dtoClass queryCond:cond sort:sortDescriptor maxResultSize:size copyBlock:nil];
}

+ (NSArray *) queryByCond : (Class) dtoClass queryCond : (id) cond  sort : (NSSortDescriptor*) sortDescriptor maxResultSize : (int) size copyBlock:(id(^)(id dest,id src))copyBlock{
    NSMutableDictionary *vars = [NSMutableDictionary new];
    return [self queryByCond:dtoClass querySql:[self generateQueySql:cond args:vars] params:vars sort:sortDescriptor maxResultSize:size copyBlock:copyBlock];
}

+ (NSArray *) queryObj:(Class) dtoClass fieldName : (NSString*) fieldName fieldValue : (id) value {
    __block NSMutableArray *mutableFetchResults = nil;
    __block NSMutableArray *dtoResults = [NSMutableArray new];
    // value 为空的话 查询会crash
    if (value == nil) {
        return dtoResults;
    }
    dispatch_sync(apsDBQueue, ^{
        NSManagedObjectContext * context = [self managedObjectContext];
        [context performBlockAndWait:^{
            NSFetchRequest * request = [[NSFetchRequest alloc] init];
            //设置请求的数据表对象
            [request setEntity:[NSEntityDescription entityForName:NSStringFromClass(dtoClass) inManagedObjectContext:context]];
            NSPredicate *preTemplate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = $%@", fieldName, fieldName]];
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                               value, fieldName,nil];
            NSPredicate *pre=[preTemplate predicateWithSubstitutionVariables: dic];
            [request setPredicate:pre];
            NSError * error = nil;
            
            mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
            for (NSManagedObject* obj in mutableFetchResults) {
                if([(NSManagedObject *)obj respondsToSelector:@selector(roundNSDecimalNumber)] == YES )
                {
                    [(id<APSModelRound>)obj roundNSDecimalNumber];
                }
                id dto = [dtoClass new];
                [APSBeanUtils copyProperties:obj dest:dto];
                //[dto setManagedObjectId:obj.objectID];
                objc_setAssociatedObject(dto, NSManagedObjectIDKey, obj.objectID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
                [dtoResults addObject:dto];
            }
            if(error != nil) {
                NSLog(@"queryObj happend error, the error is %@, %@", error, [error userInfo]);
            }
        }];
    });
    return dtoResults;
}






+ (BOOL) commitContextChange {
    NSManagedObjectContext * context = [self managedObjectContext];
    NSError * error = nil;
    [context processPendingChanges];
    if(![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return NO;
    }
    return YES;
    
}



+ (NSString *) generateQueySql : (id) queryCond args : (NSMutableDictionary *) argMappings {
    if(![queryCond respondsToSelector:@selector(getMapping)]) {
        return nil;
    }
    NSMutableString * condStr = [NSMutableString stringWithString:@"1 = 1"];
    
    __block NSMutableString * orCondStr = nil;
    
    NSArray *propertiesMappings = [queryCond getMapping];
    [propertiesMappings enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        id value = [queryCond valueForKey:key];
        if(value == nil) {
            return;
        }
        
        //        if([value isKindOfClass:[NSDate class]]) {
        //            (NSDate*) value
        //        }
        //
        NSArray * strs = [key
                          componentsSeparatedByString:SPLIT];
        if(strs == nil || [strs count] < 2) {
            return;
        }
        
        NSString *keyName = nil;
        NSString *cal = nil;
        
        if(strs.count == 3) {
            cal = [operatorMappings objectForKey:[strs objectAtIndex:1]]; //得到运算符
            if(cal == nil || [cal isEqualToString:@""] || [cal isEqualToString:@"null"]) {
                cal = @"and";
            }
            keyName = strs[2];
        }else {
            cal = @"and";
            keyName = strs[1];
        }
        
        NSString * oper = [mappings objectForKey:[strs objectAtIndex:0]];
        if(oper == nil || [oper isEqualToString:@""] || [oper isEqualToString:@"null"]) {
            return;
        }
        
        
        if([cal isEqualToString:@"or"]) {
            if (!orCondStr) {
                orCondStr = [NSMutableString stringWithString:@""];
            }
            if([oper isEqualToString:@"is"]) {
                [orCondStr appendFormat:@" %@ %@ = %@",cal,keyName,value];
            }
            else if ([oper isEqualToString:@"in"])
            {
                [orCondStr appendFormat:@"%@ %@ IN $%@",cal,keyName,key];
                [argMappings setObject:value forKey:key];
            }
            else if([oper isEqualToString:@"like"]) {
                [condStr appendFormat:@" %@ %@ contains[cd] $%@", cal, keyName, key];
                [argMappings setObject:value forKey:key];
            }
            else {
                [orCondStr appendFormat:@" %@ %@ %@ $%@", cal,keyName, oper, key];
                [argMappings setObject:value forKey:key];
            }
        }
        else {
            
            if([oper isEqualToString:@"is"]) {
                [condStr appendFormat:@" %@ %@ = %@",cal,keyName,value];
            }
            else if ([oper isEqualToString:@"in"])
            {
                [condStr appendFormat:@" %@ %@ IN $%@",cal,keyName,key];
                [argMappings setObject:value forKey:key];
            }
            else if([oper isEqualToString:@"like"]) {
                [condStr appendFormat:@" %@ %@ contains[cd] $%@", cal, keyName, key];
                [argMappings setObject:value forKey:key];
            }
            else {
                [condStr appendFormat:@" %@ %@ %@ $%@", cal,keyName, oper, key];
                [argMappings setObject:value forKey:key];
            }
            
        }
        
        
        
    }];
    
    if(orCondStr) {
        [orCondStr appendString:@" )"];
        [condStr appendFormat:@" and (%@",[orCondStr substringFromIndex:3]];
    }
    
    
    return condStr;
}

@end
