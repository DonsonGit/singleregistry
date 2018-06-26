//
//  HLBaseArchiver.m
//  GTreatCH
//
//  Created by luyee on 2017/7/25.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "HLBaseArchiver.h"

@implementation HLBaseArchiver

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    //1.取出所有的属性
    objc_property_t *propertes = class_copyPropertyList([self class], &count);
    //2.遍历的属性
    for (int i=0; i<count; i++) {
        //获取当前遍历的属性的名称
        const char *propertyName = property_getName(propertes[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        //利用KVC取出对应属性的值
        id value = [self valueForKey:name];
        //归档到文件中
        [aCoder encodeObject:value forKey:name];
    }
    free(propertes);//释放内存
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        unsigned int count =0;
        //1.取出所有的属性
        objc_property_t *propertes = class_copyPropertyList([self class], &count);
        //2.遍历所有的属性
        for (int i = 0; i < count; i++) {
            //获取当前遍历到的属性名称
            const char *propertyName = property_getName(propertes[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            //解归档前遍历得到的属性的值
            id value = [aDecoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
        free(propertes);//释放内存
    }
    return self;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    id object = [[[self class] allocWithZone:zone] init];
    
    unsigned int count =0;
    //1.取出所有的属性
    objc_property_t *propertes = class_copyPropertyList([self class], &count);
    //2.遍历所有的属性
    for (int i = 0; i < count; i++) {
        //获取当前遍历到的属性名称
        const char *propertyName = property_getName(propertes[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        id value = [self valueForKey:name];
        [object setValue:value forKey:name];
    }
    free(propertes);//释放内存
    
    return object;
}


@end
