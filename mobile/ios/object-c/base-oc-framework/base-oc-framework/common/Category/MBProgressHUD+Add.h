//
//  MBProgressHUD+Add.h
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Add)

/**
 *  显示Loading信息 - 附带loading Icon
 *
 *  @param message 信息内容
 */
+ (void)showLoading:(NSString *)message;

/**
 *  显示Loading信息 - 附带loading Icon
 *
 *  @param message 信息内容
 *  @param view hud附加哪个view
 */
+ (void)showLoading:(NSString *)message toView:(UIView *)view;

/**
 *  显示成功信息 - 附带加载成功Icon，并默认一秒后自动消息
 *
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success;

/**
 *  显示成功信息- 附带加载成功Icon，并默认一秒后自动消息
 *
 *  @param success 信息内容
 *  @param view hud附加哪个view
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  显示成功信息 - 附带加载成功Icon，并默认一秒后自动消息
 *
 *  @param success 信息内容
 *  @param view hud附加哪个view
 *  @param afterDelay 几秒后消失
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;

/**
 *  显示错误信息 - 附带加载失败Icon，并默认一秒后自动消息
 *
 *  @param error 信息内容
 */
+ (void)showError:(NSString *)error;

/**
 *  显示错误信息 - 附带加载失败Icon，并默认一秒后自动消息
 *
 *  @param error 信息内容
 *  @param view hud附加哪个view
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 *  显示错误信息 - 附带加载失败Icon，并默认一秒后自动消息
 *
 *  @param error 信息内容
 *  @param view hud附加哪个view
 *  @param afterDelay 几秒后消失
 */
+ (void)showError:(NSString *)error toView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;

/**
 *  显示toast提示信息 - 默认一秒后自动消息
 *
 *  @param message 信息内容
 */
+ (void)showToast:(NSString *)message;

/**
 *  显示toast提示信息 - 默认一秒后自动消息
 *
 *  @param message 信息内容
 *  @param afterDelay 几秒后消失
 */
+ (void)showToast:(NSString *)message afterDelay:(NSInteger)afterDelay;

/**
 *  显示toast提示信息 - 默认一秒后自动消息
 *
 *  @param message 信息内容
 *  @param view hud附加哪个view
 *  @param afterDelay 几秒后消失
 */
+ (void)showToast:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;

/**
 *  显示toast提示信息 - 默认一秒后自动消息
 *
 *  @param message 信息内容
 *  @param view hud附加哪个view
 *  @param afterDelay 几秒后消失
 *  @param completeBlock 完成后回调
 */
+ (void)showToast:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay completeBlock:(MBProgressHUDCompletionBlock)completeBlock;

/**
 *  隐藏Hud
 */
+ (void)hideHUD;

/**
 *  隐藏Hud
 *
 *  @param view hud附加哪个view
 */
+ (void)hideHUDForView:(UIView *)view;

@end
