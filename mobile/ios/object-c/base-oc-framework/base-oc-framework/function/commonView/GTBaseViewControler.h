//
//  GTBaseViewControler.h
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLBaseViewControler.h"

typedef void(^ResultCallback)(id);

@interface GTBaseViewControler : HLBaseViewControler

@property (nonatomic, strong) UIButton *backBtn;

//是否显示返回按钮
@property (nonatomic, assign, setter=setShowBackBtn:) BOOL showBackBtn;

@end
