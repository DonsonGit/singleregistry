//
//  GTRacTextField.m
//  GTreatCH
//
//  Created by luyee on 2017/8/10.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "GTRacTextField.h"

@implementation GTRacTextField

- (instancetype)init
{
    self = [super init];
    if(self) {
        [self initBindEvent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self initBindEvent];
    }
    return self;
}

- (void)initBindEvent
{
    @weakify(self);
    [[self.rac_textSignal map:^id(NSString * value) {
        @strongify(self);
        
        //如果输入处于文本选择状态，markedTextRange则不为空，否则为nil
        UITextRange* textRange = [self markedTextRange];
        if(nil == textRange) {
            self.text = value;
        }
        return value;
    }] subscribeNext:^(id x) {
        
    }];
}

- (void)setText:(NSString *)text
{
    //预处理text
    NSString * retString = text;
    
    [super setText:retString];
}

@end
