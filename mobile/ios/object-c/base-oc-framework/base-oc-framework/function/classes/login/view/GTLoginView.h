//
//  GTLoginView.h
//  GTreatCH
//
//  Created by 戴世豪 on 2018/4/13.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTLoginViewDelegate;
@interface GTLoginView : UIView
@property (nonatomic, weak) id<GTLoginViewDelegate> delegate;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * password;
@end

@protocol GTLoginViewDelegate <NSObject>
@optional
//登录按钮
-(void)login:(GTLoginView *)view;
//注册按钮
-(void)registerCommit;
//忘记密码
-(void)lostPassword;
@end
