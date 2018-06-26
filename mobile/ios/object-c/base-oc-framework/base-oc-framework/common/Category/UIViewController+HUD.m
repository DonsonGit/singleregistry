//
//  UIViewController+HUD.m
//  GTreatCH
//
//  Created by yangji on 2017/8/18.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "MBProgressHUD+Add.h"

@implementation UIViewController (HUD)

#pragma mark -  network loading and show tips

- (void)showloading:(NSString *)message
{
    [MBProgressHUD showLoading:message];
}

- (void)showloading:(NSString *)message toView:(UIView *)view
{
    [MBProgressHUD showLoading:message toView:view];
}

- (void)hideLoading
{
    [MBProgressHUD hideHUD];
}

- (void)hideLoading:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

- (void)showToast:(NSString *)message
{
    [MBProgressHUD showToast:message toView:self.view afterDelay:1.5];
}

- (void)showToast:(NSString *)message completeBlock:(MBProgressHUDCompletionBlock)completeBlock
{
    [MBProgressHUD showToast:message toView:self.view afterDelay:1.5 completeBlock:completeBlock];
}

- (void)showToast:(NSString *)message delayHide:(CGFloat)delay
{
    [MBProgressHUD showToast:message toView:self.view afterDelay:delay];
}

- (void)showToast:(NSString *)message delayHide:(CGFloat)delay completeBlock:(MBProgressHUDCompletionBlock)completeBlock
{
    [MBProgressHUD showToast:message toView:self.view afterDelay:delay completeBlock:completeBlock];
}

@end
