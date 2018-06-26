//
//  GTLoginView.m
//  GTreatCH
//
//  Created by 戴世豪 on 2018/4/13.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import "GTLoginView.h"
#import "GTRacTextField.h"
#import "GTGradualChangeLabel.h"

@interface GTLoginView ()

@property (nonatomic, strong) UIImageView * LoginLogo;
@property (nonatomic, strong) GTGradualChangeLabel * LoginLogoText;
@property (nonatomic, strong) GTRacTextField * userNameTextField;
@property (nonatomic, strong) GTRacTextField * passwordTextField;
@property (nonatomic, strong) UIButton * loginBtn;
@property (nonatomic, strong) UIButton * forgetBtn;
@property (nonatomic, strong) UIButton * registerBtn;

@end
@implementation GTLoginView
//TODODON:登录View

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.LoginLogo];
        [self addSubview:self.LoginLogoText];
        [self addSubview:self.userNameTextField];
        [self addSubview:self.passwordTextField];
        [self addSubview:self.loginBtn];
        [self addSubview:self.forgetBtn];
        [self addSubview:self.registerBtn];
        
        [self Constraints];
        [self BindEvent];
    }
    return self;
}

-(void)Constraints{
    [self.LoginLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SCREEN_WIDTH*0.3);
        make.centerX.equalTo(self);
        make.height.width.equalTo(97);
    }];
    [self.LoginLogoText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_LoginLogo.mas_bottom).mas_offset(23);
        make.centerX.equalTo(self);
        make.height.equalTo(19);
    }];
    UIView *userLine = [[UIView alloc]init];
    userLine.backgroundColor = COM_BFBFBF_COLOR;
    [self.userNameTextField addSubview:userLine];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_LoginLogoText.mas_bottom).mas_offset(35);
        make.centerX.equalTo(self);
        make.height.equalTo(56);
        make.width.equalTo(SCREEN_WIDTH*0.8);
    }];
    [userLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-1);
        make.left.right.equalTo(0);
        make.height.equalTo(0.8);
    }];
    UIView * passwordLine = [[UIView alloc]init];
    passwordLine.backgroundColor = COM_BFBFBF_COLOR;
    [self.passwordTextField addSubview:passwordLine];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameTextField.mas_bottom);
        make.centerX.equalTo(_userNameTextField);
        make.height.width.equalTo(_userNameTextField);
    }];
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-1);
        make.left.right.equalTo(0);
        make.height.equalTo(0.8);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).mas_offset(32);
        make.centerX.equalTo(_passwordTextField);
        make.width.equalTo(_passwordTextField);
        make.height.equalTo(42);
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).mas_offset(28);
        make.left.equalTo(_loginBtn.mas_left).mas_offset(28);
        make.width.greaterThanOrEqualTo(30);
        make.height.equalTo(14);
    }];
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).mas_offset(28);
        make.right.equalTo(_loginBtn.mas_right).mas_offset(-28);
        make.width.greaterThanOrEqualTo(30);
        make.height.equalTo(14);
    }];
    
}

-(void)BindEvent{
    RACChannelTo(self, userName) = RACChannelTo(_userNameTextField, text);
    RACChannelTo(self, password) = RACChannelTo(_passwordTextField, text);
}

#pragma - initView

-(UIImageView *)LoginLogo{
    if (nil == _LoginLogo) {
        _LoginLogo = [[UIImageView alloc]init];
        _LoginLogo.image = [UIImage imageNamed:@"login_logo"];
        _LoginLogo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _LoginLogo;
}

-(UILabel *)LoginLogoText{
    if (nil == _LoginLogoText) {
        _LoginLogoText = [[GTGradualChangeLabel alloc]init];
        _LoginLogoText.colors = @[(id)COM_325DFE_COLOR.CGColor,(id)COM_DC43DB_COLOR.CGColor];
        _LoginLogoText.font = [UIFont boldSystemFontOfSize:18];
        _LoginLogoText.textAlignment = NSTextAlignmentCenter;
        _LoginLogoText.text = @"长兴便民服务平台";
    }
    return _LoginLogoText;
}

-(GTRacTextField *)userNameTextField{
    if (nil == _userNameTextField) {
        _userNameTextField = [[GTRacTextField alloc]init];
        _userNameTextField.textColor = COM_4E4E4E_COLOR;
        _userNameTextField.font = [UIFont systemFontOfSize:12.0];
        _userNameTextField.placeholder = @"请输入用户名或手机号";
        _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageNamed:@"user_icon"];
        _userNameTextField.leftView = img;
        _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _userNameTextField.returnKeyType = UIReturnKeyNext;
    }
    return _userNameTextField;
}

-(GTRacTextField *)passwordTextField{
    if (nil == _passwordTextField) {
        _passwordTextField = [[GTRacTextField alloc]init];
        _passwordTextField.textColor = COM_4E4E4E_COLOR;
        _passwordTextField.font = [UIFont systemFontOfSize:12.0];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageNamed:@"pwd_icon"];
        _passwordTextField.leftView = img;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
    }
    return _passwordTextField;
}

-(UIButton *)loginBtn{
    if (nil == _loginBtn) {
        _loginBtn = [[UIButton alloc]init];
        _loginBtn.backgroundColor = COM_325DFE_COLOR;
        _loginBtn.layer.cornerRadius = 21;
        _loginBtn.layer.shadowColor = COM_325DFE_COLOR.CGColor;
        _loginBtn.layer.shadowRadius = 12;
        _loginBtn.layer.shadowOpacity = 0.55;
        _loginBtn.layer.shadowOffset = CGSizeMake(0, 0);
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTintColor:COM_WHITE_COLOR];
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(UIButton *)forgetBtn{
    if (nil == _forgetBtn) {
        _forgetBtn = [[UIButton alloc]init];
        _forgetBtn.backgroundColor = [UIColor clearColor];
        _forgetBtn.layer.masksToBounds = YES;
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:COM_325DFE_COLOR forState:UIControlStateNormal];
        [_forgetBtn addTarget:self action:@selector(lostPasswordEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}

-(UIButton *)registerBtn{
    if (nil == _registerBtn) {
        _registerBtn = [[UIButton alloc]init];
        _registerBtn.backgroundColor = [UIColor clearColor];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:COM_325DFE_COLOR forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

#pragma - Event

-(void)login{
    if (self.delegate && [self.delegate respondsToSelector:@selector(login:)]) {
        [self.delegate login:self];
    }
}

-(void)registerEvent{
    if (self.delegate && [self.delegate respondsToSelector:@selector(registerCommit)]) {
        [self.delegate registerCommit];
    }
}

-(void)lostPasswordEvent{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lostPassword)]) {
        [self.delegate lostPassword];
    }
}

@end
