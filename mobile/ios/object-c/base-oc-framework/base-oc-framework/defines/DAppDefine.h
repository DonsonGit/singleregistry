//
//  DAppDefine.h
//  base-oc-framework
//
//  Created by 戴世豪 on 2018/6/26.
//  Copyright © 2018年 戴世豪. All rights reserved.
//

#ifndef DAppDefine_h
#define DAppDefine_h

#define IS_iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)

/*********************************日志打印***************************************/
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

/************************************屏幕尺寸************************************/
#define SCREEN_HEIGHT                       [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH                        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_SCALE                        [UIScreen mainScreen].scale

/************************************等比例高度宽度*******************************/
#define SCALE_WIDTH(SELF_WIDTH) (SCREEN_WIDTH * SELF_WIDTH / 750.0)
#define SCALE_HEIGHT(SELF_HEIGHT) (SCREEN_HEIGHT * SELF_HEIGHT / 1334.0)

/************************************UI高度适配**********************************/
//状态栏高度
#define STATUSBAR_HEIGHT                        (IS_iPhoneX ? 44 : 20)
//导航栏高度
#define NAVIGATIONBAR_HEIGHT                    44
//状态栏和导航栏高度
#define STATUSBAR_AND_NAVIGATIONBAR_HEIGHT      (IS_iPhoneX ? 88 : 64)

//tabBar底部安全区高度
#define TABBAR_SAFE_BOTTOM_MARGIN               (IS_iPhoneX ? 34 : 0)
//tabBar和安全区高度
#define TABBAR_AND_SAFEAREA_HEIGHT              (IS_iPhoneX ? (49+34) : 49)

/************************************判空***************************************/
#ifndef AVOID_NIL_VALUE
#define AVOID_NIL_VALUE(target, defaultValue) ((target && ![target isKindOfClass:[NSNull class]]) ? target : defaultValue)
#endif

#endif /* DAppDefine_h */
