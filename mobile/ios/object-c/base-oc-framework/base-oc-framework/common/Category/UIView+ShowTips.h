//
//  UIView+ShowTips.h
//  GTreat
//
//  Created by luyee on 2017/7/8.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+Add.h"

@interface UIView (ShowTips)

- (void)showTipsView:(NSString *)tips;

- (void)showTipsView:(NSString *)tips afterDelay:(NSTimeInterval)delay;

- (void)showTipsView:(NSString *)tips toView:(UIView *)view afterDelay:(NSTimeInterval)delay;

- (void)hideTipsView:(UIView *)view;

- (void)showLoading:(NSString *)tips toView:(UIView *)view;

- (void)hideLoading:(UIView *)view;

@end
