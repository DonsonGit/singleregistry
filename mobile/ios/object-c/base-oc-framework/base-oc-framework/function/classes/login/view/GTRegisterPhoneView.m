//
//  GTRegisterPhoneView.m
//  GTreatCH
//
//  Created by 戴世豪 on 2018/4/16.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import "GTRegisterPhoneView.h"
#import "GTRacTextField.h"

@interface GTRegisterPhoneView()

@property (nonatomic, strong) GTRacTextField * phone;
@property (nonatomic, strong) GTRacTextField * code;
@property (nonatomic, strong) UIButton * GetCode;
@property (nonatomic, strong) UIButton * Next;

@end
@implementation GTRegisterPhoneView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.phone];
        [self addSubview:self.code];
        [self addSubview:self.GetCode];
        [self addSubview:self.Next];
        
        [self Constraint];
        [self BindEvent];
    }
    return self;
}

-(void)Constraint{
    UIView *phoneLine = [[UIView alloc]init];
    phoneLine.backgroundColor = COM_BFBFBF_COLOR;
    [self.phone addSubview:phoneLine];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(12);
        make.centerX.equalTo(self);
        make.height.equalTo(56);
        make.width.equalTo(SCREEN_WIDTH*0.8);
    }];
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-1);
        make.left.right.equalTo(0);
        make.height.equalTo(0.8);
    }];
    UIView *codeLine = [[UIView alloc]init];
    codeLine.backgroundColor = COM_BFBFBF_COLOR;
    [self.code addSubview:codeLine];
    [self.code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phone.mas_bottom);
        make.centerX.equalTo(_phone);
        make.width.height.equalTo(_phone);
    }];
    [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-1);
        make.left.right.equalTo(0);
        make.height.equalTo(0.8);
    }];
    [self.GetCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_code);
        make.height.equalTo(35);
        make.right.equalTo(_code.mas_right).mas_offset(-5);
        make.width.equalTo(100);
    }];
    [self.Next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_code.mas_bottom).mas_offset(37);
        make.left.right.equalTo(_code);
        make.height.equalTo(42);
    }];
}

-(void)BindEvent{
    RACChannelTo(self, phoneValue) = RACChannelTo(_phone, text);
    RACChannelTo(self, codeValue ) = RACChannelTo(_code, text );
}

-(void)next{
    if (self.delegate && [self.delegate respondsToSelector:@selector(Next:)]) {
        [self.delegate Next:self];
    }
}

#pragma - initView

-(GTRacTextField *)phone{
    if (nil == _phone) {
        _phone = [[GTRacTextField alloc]init];
        _phone.textColor = COM_4E4E4E_COLOR;
        _phone.font = [UIFont systemFontOfSize:12.0];
        _phone.placeholder = @"输入手机号";
        _phone.leftViewMode = UITextFieldViewModeAlways;
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageNamed:@"user_icon"];
        _phone.leftView = img;
        _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phone.autocorrectionType = UITextAutocorrectionTypeNo;
        _phone.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _phone.returnKeyType = UIReturnKeyNext;
    }
    return _phone;
}

-(GTRacTextField *)code{
    if (nil == _code) {
        _code = [[GTRacTextField alloc]init];
        _code.textColor = COM_4E4E4E_COLOR;
        _code.font = [UIFont systemFontOfSize:12.0];
        _code.placeholder = @"输入验证码";
        _code.leftViewMode = UITextFieldViewModeAlways;
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageNamed:@"code_icon"];
        _code.leftView = img;
        _code.clearButtonMode = UITextFieldViewModeWhileEditing;
        _code.autocorrectionType = UITextAutocorrectionTypeNo;
        _code.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _code.keyboardType = UIKeyboardTypeNumberPad;
        _code.returnKeyType = UIReturnKeyNext;
    }
    return _code;
}

-(UIButton *)GetCode{
    if (nil == _GetCode) {
        _GetCode = [[UIButton alloc]init];
        _GetCode.backgroundColor = COM_FFB43D_COLOR;
        _GetCode.layer.cornerRadius = 5;
        _GetCode.titleLabel.font = [UIFont systemFontOfSize:13];
        [_GetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_GetCode setTintColor:COM_WHITE_COLOR];
    }
    return _GetCode;
}

-(UIButton *)Next{
    if (nil == _Next) {
        _Next = [[UIButton alloc]init];
        _Next.backgroundColor = COM_325DFE_COLOR;
        _Next.layer.cornerRadius = 21;
        _Next.layer.shadowColor = COM_325DFE_COLOR.CGColor;
        _Next.layer.shadowRadius = 12;
        _Next.layer.shadowOpacity = 0.55;
        _Next.layer.shadowOffset = CGSizeMake(0, 0);
        _Next.titleLabel.font = [UIFont systemFontOfSize:15];
        [_Next setTitle:@"下一步" forState:UIControlStateNormal];
        [_Next setTintColor:COM_WHITE_COLOR];
        [_Next addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Next;
}

@end
