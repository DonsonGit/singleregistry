//
//  UIView+ShowTips.m
//  GTreat
//
//  Created by luyee on 2017/7/8.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "UIView+ShowTips.h"

@implementation UIView (ShowTips)

- (void)showTipsView:(NSString *)tips
{
    [MBProgressHUD showToast:tips toView:self afterDelay:0];
}

- (void)showTipsView:(NSString *)tips afterDelay:(NSTimeInterval)delay
{
    [MBProgressHUD showToast:tips toView:self afterDelay:delay];
}

- (void)showTipsView:(NSString *)tips toView:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    [MBProgressHUD showToast:tips toView:view afterDelay:delay];
}

- (void)hideTipsView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view];
}

- (void)showLoading:(NSString *)tips toView:(UIView *)view
{
    [MBProgressHUD showLoading:tips toView:view];
}

- (void)hideLoading:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view];
}

@end
