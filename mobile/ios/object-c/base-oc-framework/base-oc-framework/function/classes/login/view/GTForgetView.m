//
//  GTForgetView.m
//  GTreat
//
//  Created by 戴世豪 on 2018/4/23.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import "GTForgetView.h"
#import "GTKeyValueView.h"
@interface GTForgetView()
@property (nonatomic, strong) GTKeyValueView * pwdNew;
@property (nonatomic, strong) GTKeyValueView * pwdConfirm;
@property (nonatomic, strong) UIButton * confirmBtn;
@end
@implementation GTForgetView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self addSubview:self.pwdNew];
        [self addSubview:self.pwdConfirm];
        [self addSubview:self.confirmBtn];
        
        [self Constraints];
        [self BindEvent];
    }
    return self;
}

-(void)Constraints{
    [self.pwdNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(12);
        make.centerX.equalTo(self);
        make.width.equalTo(SCREEN_WIDTH*0.8);
        make.height.equalTo(56);
    }];
    [self.pwdConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwdNew.mas_bottom);
        make.centerX.equalTo(_pwdNew);
        make.width.height.equalTo(_pwdNew);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwdConfirm.mas_bottom).mas_offset(32);
        make.centerX.equalTo(_pwdConfirm);
        make.width.equalTo(_pwdConfirm);
        make.height.equalTo(42);
    }];
}

-(void)BindEvent{
    RACChannelTo(self, pwdN) = RACChannelTo(_pwdNew, key.text);
    RACChannelTo(self, pwdC) = RACChannelTo(_pwdConfirm, key.text);
}

#pragma - initView

-(GTKeyValueView *)pwdNew{
    if (nil == _pwdNew) {
        _pwdNew = [[GTKeyValueView alloc]init];
        _pwdNew.key.text = @"新密码";
    }
    return _pwdNew;
}

-(GTKeyValueView *)pwdConfirm{
    if (nil == _pwdConfirm) {
        _pwdConfirm = [[GTKeyValueView alloc]init];
        _pwdConfirm.key.text = @"确认密码";
    }
    return _pwdConfirm;
}

-(UIButton *)confirmBtn{
    if (nil == _confirmBtn) {
        _confirmBtn = [[UIButton alloc]init];
        _confirmBtn.backgroundColor = COM_325DFE_COLOR;
        _confirmBtn.layer.cornerRadius = 21;
        _confirmBtn.layer.shadowColor = COM_325DFE_COLOR.CGColor;
        _confirmBtn.layer.shadowRadius = 12;
        _confirmBtn.layer.shadowOpacity = 0.55;
        _confirmBtn.layer.shadowOffset = CGSizeMake(0, 0);
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn setTintColor:COM_WHITE_COLOR];
    }
    return _confirmBtn;
}

@end
