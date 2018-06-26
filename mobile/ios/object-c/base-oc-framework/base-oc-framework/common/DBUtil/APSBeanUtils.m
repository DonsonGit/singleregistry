//
//  APSBeanUtils.m
//  apos-enterprise-ios
//
//  Created by 刘洋 on 13-5-13.
//  Copyright (c) 2013年 cpz. All rights reserved.
//

#import "APSBeanUtils.h"

@implementation APSBeanUtils

+(void)copyProperties:(id)src dest:(id)dest {
    
    // APOSDLog(@"classeSrc=%@ dst=%@", [src class], [dest class]);
    if(src == NULL || dest == NULL) {
        return;
    }

    [self copyClassProperties:src dest:dest refClass:[src class]];
}


+ (void) copyClassProperties : (id)src dest:(id)dest  refClass : (Class) refClass {
    if(refClass == [NSObject class]) {
        return;
    }
    Class clazz = refClass;
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        [propertyArray addObject:propertyName];
        //on verifie que la prop existe dans la classe dest
        objc_property_t prop =  [self getPropertyByClass:propertyName refClass:[dest class]];
        if(prop != NULL ) {
            id result = [src valueForKey:propertyName];
            @try {
                [dest setValue:result forKey: propertyName];
            }
            @catch (NSException *exception) {
                
            }
        }
       
    }
    free(properties);
    if([refClass superclass] != nil) {
        [self copyClassProperties:src dest:dest refClass:[refClass superclass]];
    }
}

+ (objc_property_t) getPropertyByClass : (NSString*) propertyName refClass : (Class) refClass {
    objc_property_t prop = class_getProperty(refClass, [propertyName UTF8String]);
    if(prop != NULL) {
        return prop;
    }
    if([refClass superclass] != nil) {
        return [self getPropertyByClass:propertyName refClass:[refClass superclass]];
    } else {
        return NULL;
    }
}

@end
