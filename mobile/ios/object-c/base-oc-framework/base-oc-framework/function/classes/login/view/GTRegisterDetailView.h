//
//  GTRegisterDetailView.h
//  GTreatCH
//
//  Created by 戴世豪 on 2018/4/16.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTRegisterDetailViewDelegate;
@interface GTRegisterDetailView : UIView

@property (nonatomic, weak) id<GTRegisterDetailViewDelegate> delegate;
@property (nonatomic, strong) NSString * userValue;//用户名
@property (nonatomic, strong) NSString * codeValue;//身份证号
@property (nonatomic, strong) NSString * addrValue;//联系地址
@property (nonatomic, strong) NSString * teleValue;//手机号码
@property (nonatomic, strong) NSString * pawdValue;//注册密码
@property (nonatomic, strong) NSString * twicValue;//确认密码

@end

@protocol GTRegisterDetailViewDelegate <NSObject>
@optional
-(void)Done:(GTRegisterDetailView *)view;
@end
