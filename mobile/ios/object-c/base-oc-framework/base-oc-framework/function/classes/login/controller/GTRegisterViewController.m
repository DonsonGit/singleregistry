//
//  GTRegisterViewController.m
//  GTreatCH
//
//  Created by 戴世豪 on 2018/4/16.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import "GTRegisterViewController.h"
#import "GTRegisterPhoneView.h"
#import "GTRegisterDetailView.h"
#import "GTForgetView.h"

@interface GTRegisterViewController ()<GTRegisterPhoneViewDelegate,GTRegisterDetailViewDelegate>

@property (nonatomic, strong) GTRegisterPhoneView  * phoneView;
@property (nonatomic, strong) GTRegisterDetailView * detailView;
@property (nonatomic, strong) GTForgetView * forgetView;

@end

@implementation GTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.isForget ? @"忘记密码" : @"注册";
    [self.view addSubview:self.phoneView];
    if (self.isForget){
        [self.view addSubview:self.forgetView];
    }else{
        [self.view addSubview:self.detailView];
    }
    [self Constraints];
}

-(void)Constraints{
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    if (!self.isForget) {
        self.detailView.hidden = YES;
        [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(SCREEN_WIDTH);
            make.top.bottom.equalTo(0);
            make.width.equalTo(SCREEN_WIDTH);
        }];
    }else{
        self.forgetView.hidden = YES;
        [self.forgetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(SCREEN_WIDTH);
            make.top.bottom.equalTo(0);
            make.width.equalTo(SCREEN_WIDTH);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma - initView
-(GTRegisterPhoneView *)phoneView{
    if (nil == _phoneView) {
        _phoneView = [[GTRegisterPhoneView alloc]init];
        _phoneView.delegate = self;
    }
    return _phoneView;
}

-(GTRegisterDetailView *)detailView{
    if (nil == _detailView) {
        _detailView = [[GTRegisterDetailView alloc]init];
        _detailView.delegate = self;
    }
    return _detailView;
}

-(GTForgetView *)forgetView{
    if (nil == _forgetView) {
        _forgetView = [[GTForgetView alloc]init];
    }
    return _forgetView;
}

#pragma - Delegate - Phone,Detail

-(void)Next:(GTRegisterPhoneView *)view{
    //TODO:校验手机号
    [self NextAnimation];
}

-(void)Done:(GTRegisterDetailView *)view{
    
}

#pragma - animation

-(void)NextAnimation{
    UIView * view = self.isForget ? self.forgetView : self.detailView;
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
    }];
    [self.phoneView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    view.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.phoneView.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.phoneView.hidden = YES;
    }];
}

@end
