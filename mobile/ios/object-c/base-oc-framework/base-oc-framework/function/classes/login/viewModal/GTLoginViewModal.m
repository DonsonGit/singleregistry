//
//  GTLoginViewModal.m
//  GTreatCH
//
//  Created by luyee on 2017/7/27.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "GTLoginViewModal.h"
#import "GTNetApi.h"

@implementation GTLoginViewModal

- (instancetype)init
{
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void)login:(NSString *)u pwd:(NSString *)p {
    [[GTNetApi netApi] login:@{@"userId":u,@"password":p} callBack:^(id dataObj, QFHttpErrorResult *error) {
        if (!error && dataObj){
            
        }else{
            
        }
    }];
}

@end
