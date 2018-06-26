//
//  GTRegisterPhoneView.h
//  GTreatCH
//
//  Created by 戴世豪 on 2018/4/16.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTRegisterPhoneViewDelegate;
@interface GTRegisterPhoneView : UIView

@property (nonatomic, weak) id<GTRegisterPhoneViewDelegate> delegate;
@property (nonatomic, strong) NSString * phoneValue;
@property (nonatomic, strong) NSString * codeValue;

@end

@protocol GTRegisterPhoneViewDelegate <NSObject>
@optional
-(void)Next:(GTRegisterPhoneView *)view;
@end
