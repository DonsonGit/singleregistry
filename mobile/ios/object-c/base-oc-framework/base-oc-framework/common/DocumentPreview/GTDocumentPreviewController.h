//
//  GTDocumentPreviewController.h
//  GTreatCH
//
//  Created by yangji on 2017/8/3.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "HLBaseViewControler.h"
#import <QuickLook/QuickLook.h>

@interface GTDocumentPreviewController : HLBaseViewControler

@property (nonatomic, strong) NSString *documentUrl;
@property (nonatomic, strong) NSString *fileName;

-(instancetype)init:(NSString *)url fileName:(NSString *) filename;

@end
