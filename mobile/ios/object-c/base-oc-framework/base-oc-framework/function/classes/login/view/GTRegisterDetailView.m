//
//  GTRegisterDetailView.m
//  GTreatCH
//
//  Created by 戴世豪 on 2018/4/16.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import "GTRegisterDetailView.h"
#import "GTKeyValueView.h"

@interface GTRegisterDetailView()

@property (nonatomic, strong) GTKeyValueView * userText;
@property (nonatomic, strong) GTKeyValueView * codeText;
@property (nonatomic, strong) GTKeyValueView * addrText;
@property (nonatomic, strong) GTKeyValueView * teleText;
@property (nonatomic, strong) GTKeyValueView * pawdText;
@property (nonatomic, strong) GTKeyValueView * twicText;
@property (nonatomic, strong) UIButton       * confirmButton;

@end
@implementation GTRegisterDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.userText];
        [self addSubview:self.codeText];
        [self addSubview:self.addrText];
        [self addSubview:self.teleText];
        [self addSubview:self.pawdText];
        [self addSubview:self.twicText];
        [self addSubview:self.confirmButton];
        
        [self Constraints];
        [self BindEvent];
    }
    return self;
}

-(void)Constraints{
    [self.userText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(12);
        make.centerX.equalTo(self);
        make.width.equalTo(SCREEN_WIDTH*0.8);
        make.height.equalTo(56);
    }];
    [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userText.mas_bottom);
        make.centerX.equalTo(_userText);
        make.width.height.equalTo(_userText);
    }];
    [self.addrText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeText.mas_bottom);
        make.centerX.equalTo(_codeText);
        make.width.height.equalTo(_codeText);
    }];
    [self.teleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addrText.mas_bottom);
        make.centerX.equalTo(_addrText);
        make.width.height.equalTo(_addrText);
    }];
    [self.pawdText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_teleText.mas_bottom);
        make.centerX.equalTo(_teleText);
        make.width.height.equalTo(_teleText);
    }];
    [self.twicText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pawdText.mas_bottom);
        make.centerX.equalTo(_pawdText);
        make.width.height.equalTo(_pawdText);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_twicText.mas_bottom).mas_offset(32);
        make.centerX.equalTo(_twicText);
        make.width.equalTo(_twicText);
        make.height.equalTo(42);
    }];
}

-(void)BindEvent{
    RACChannelTo(self, userValue) = RACChannelTo(_userText, value.text);
    RACChannelTo(self, codeValue) = RACChannelTo(_codeText, value.text);
    RACChannelTo(self, addrValue) = RACChannelTo(_addrText, value.text);
    RACChannelTo(self, teleValue) = RACChannelTo(_teleText, value.text);
    RACChannelTo(self, pawdValue) = RACChannelTo(_pawdText, value.text);
    RACChannelTo(self, twicValue) = RACChannelTo(_twicText, value.text);
}

-(void)done{
    if (self.delegate && [self.delegate respondsToSelector:@selector(Done:)]) {
        [self.delegate Done:self];
    }
}

#pragma - initView

-(GTKeyValueView *)userText{
    if (nil == _userText) {
        _userText = [[GTKeyValueView alloc]init];
        _userText.key.attributedText = [self importantStr:@"用户姓名"];
        NSString * str = @"(真实姓名)";
        _userText.value.attributedPlaceholder = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:COM_B1B1B1_COLOR}];
    }
    return _userText;
}

-(GTKeyValueView *)codeText{
    if (nil == _codeText) {
        _codeText = [[GTKeyValueView alloc]init];
        _codeText.key.attributedText = [self importantStr:@"身份证号"];
    }
    return _codeText;
}

-(GTKeyValueView *)addrText{
    if (nil == _addrText) {
        _addrText = [[GTKeyValueView alloc]init];
        _addrText.key.text = @"联系地址";
    }
    return _addrText;
}

-(GTKeyValueView *)teleText{
    if (nil == _teleText) {
        _teleText = [[GTKeyValueView alloc]init];
        _teleText.key.text = @"手机号码";
    }
    return _teleText;
}

-(GTKeyValueView *)pawdText{
    if (nil == _pawdText) {
        _pawdText = [[GTKeyValueView alloc]init];
        _pawdText.key.attributedText = [self importantStr:@"注册密码"];
    }
    return _pawdText;
}

-(GTKeyValueView *)twicText{
    if (nil == _twicText) {
        _twicText = [[GTKeyValueView alloc]init];
        _twicText.key.attributedText = [self importantStr:@"确认密码"];
    }
    return _twicText;
}

-(UIButton *)confirmButton{
    if (nil == _confirmButton) {
        _confirmButton = [[UIButton alloc]init];
        _confirmButton.backgroundColor = COM_325DFE_COLOR;
        _confirmButton.layer.cornerRadius = 21;
        _confirmButton.layer.shadowColor = COM_325DFE_COLOR.CGColor;
        _confirmButton.layer.shadowRadius = 12;
        _confirmButton.layer.shadowOpacity = 0.55;
        _confirmButton.layer.shadowOffset = CGSizeMake(0, 0);
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTintColor:COM_WHITE_COLOR];
    }
    return _confirmButton;
}

#pragma - Function

-(NSAttributedString *)importantStr:(NSString *)str{
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"*%@",str]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    return attrStr;
}

@end
