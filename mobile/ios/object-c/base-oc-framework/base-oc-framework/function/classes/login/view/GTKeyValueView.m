//
//  GTKeyValueView.m
//  GTreatCH
//
//  Created by 戴世豪 on 2018/4/16.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import "GTKeyValueView.h"

@implementation GTKeyValueView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.key];
        [self addSubview:self.value];
        
        [self Constraints];
    }
    return self;
}

-(void)Constraints{
    [self.key mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(5);
        make.width.equalTo(100);
    }];
    [self.value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_key);
        make.left.equalTo(_key.mas_right).mas_offset(5);
        make.right.equalTo(-5);
    }];
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = COM_BFBFBF_COLOR;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-1);
        make.left.right.equalTo(0);
        make.height.equalTo(0.8);
    }];
}

#pragma - initView

-(UILabel *)key{
    if (nil == _key) {
        _key = [[UILabel alloc]init];
        _key.font = [UIFont systemFontOfSize:14];
        _key.textColor = COM_4E4E4E_COLOR;
        _key.textAlignment = NSTextAlignmentLeft;
    }
    return _key;
}

-(GTRacTextField *)value{
    if (nil == _value) {
        _value = [[GTRacTextField alloc]init];
        _value.textColor = COM_4E4E4E_COLOR;
        _value.textAlignment = NSTextAlignmentRight;
        _value.font = [UIFont systemFontOfSize:14];
        _value.clearButtonMode = UITextFieldViewModeWhileEditing;
        _value.autocorrectionType = UITextAutocorrectionTypeNo;
        _value.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _value.returnKeyType = UIReturnKeyNext;
    }
    return _value;
}

@end
