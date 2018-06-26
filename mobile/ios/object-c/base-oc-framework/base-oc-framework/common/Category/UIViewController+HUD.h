//
//  UIViewController+HUD.h
//  GTreatCH
//
//  Created by yangji on 2017/8/18.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface UIViewController (HUD)

- (void)showloading:(NSString *)message;

- (void)showloading:(NSString *)message toView:(UIView *)view;

- (void)hideLoading;

- (void)hideLoading:(UIView *)view;

- (void)showToast:(NSString *)message;

- (void)showToast:(NSString *)message completeBlock:(MBProgressHUDCompletionBlock)completeBlock;

- (void)showToast:(NSString *)message delayHide:(CGFloat)delay;

- (void)showToast:(NSString *)message delayHide:(CGFloat)delay completeBlock:(MBProgressHUDCompletionBlock)completeBlock;


@end
