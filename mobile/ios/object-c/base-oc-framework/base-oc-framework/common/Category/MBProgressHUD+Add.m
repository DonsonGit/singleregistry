//
//  MBProgressHUD+Add.m
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view afterDelay:(CGFloat)delay
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:14];
    
    if(text.length == 0) {
        text = @"正在加载...";
    }
    hud.labelText = text;
    
    //设置模式与图片
    if([icon length] > 0) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    } else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    hud.animationType = MBProgressHUDAnimationFade;
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    if(delay > 0) {
        [hud hide:YES afterDelay:delay];
    }
}

+ (void)showText:(NSString *)message toView:(UIView *)view afterDelay:(CGFloat)delay completeBlock:(MBProgressHUDCompletionBlock)completeBlock
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if ([message length] > 15) {
        hud.detailsLabelText = message;
    }else{
        hud.labelText = message;
    }
    hud.animationType = MBProgressHUDAnimationFade;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.completionBlock = completeBlock;
    
    if(delay > 0) {
        [hud hide:YES afterDelay:delay];
    } else {
        [hud hide:YES afterDelay:1.5];
    }
}

+ (void)showLoading:(NSString *)message
{
    [self show:message icon:nil view:nil afterDelay:0];
}

+ (void)showLoading:(NSString *)message toView:(UIView *)view
{
    [self show:message icon:nil view:view afterDelay:0];
}

+ (void)showSuccess:(NSString *)success
{
    [self show:success icon:@"success.png" view:nil afterDelay:1.5];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view afterDelay:1.5];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay
{
    [self show:success icon:@"success.png" view:view afterDelay:afterDelay];
}

+ (void)showError:(NSString *)error
{
    [self show:error icon:@"error.png" view:nil afterDelay:1.5];
}

+ (void)showError:(NSString *)error toView:(UIView *)view
{
    [self show:error icon:@"error.png" view:view afterDelay:1.5];
}

+ (void)showError:(NSString *)error toView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay
{
    [self show:error icon:@"error.png" view:view afterDelay:afterDelay];
}

+ (void)showToast:(NSString *)message
{
    [self showText:message toView:nil afterDelay:1.5 completeBlock:nil];
}

+ (void)showToast:(NSString *)message afterDelay:(NSInteger)afterDelay
{
    [self showText:message toView:nil afterDelay:afterDelay completeBlock:nil];
}

+ (void)showToast:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay
{
    [self showText:message toView:view afterDelay:afterDelay completeBlock:nil];
}

+ (void)showToast:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay completeBlock:(MBProgressHUDCompletionBlock)completeBlock
{
    [self showText:message toView:view afterDelay:afterDelay completeBlock:completeBlock];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [self hideAllHUDsForView:view animated:YES];
}

@end
