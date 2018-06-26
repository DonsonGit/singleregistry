//
//  DColorDefine.h
//  base-oc-framework
//
//  Created by 戴世豪 on 2018/6/26.
//  Copyright © 2018年 戴世豪. All rights reserved.
//  色谱管理 - 建议UI给出主题式色系

#ifndef DColorDefine_h
#define DColorDefine_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

//导航栏背景整体tintColor
#define COM_TINT_COLOR                                  UIColorFromRGB(0x078DED)

//TabBarItem选中颜色
#define COM_TABBAR_SELECTED_COLOR                       UIColorFromRGB(0x00ff00)

//TabBarItem未选中颜色
#define COM_TABBAR_UNSELECTED_COLOR                     UIColorFromRGB(0xff0000)

//需要颜色
#define COM_WHITE_COLOR                                 [UIColor whiteColor]
#define COM_BFBFBF_COLOR                                UIColorFromRGB(0xbfbfbf)
#define COM_4E4E4E_COLOR                                UIColorFromRGB(0x4e4e4e)
#define COM_325DFE_COLOR                                UIColorFromRGB(0x325dfe)
#define COM_DC43DB_COLOR                                UIColorFromRGB(0xdc43db)
#define COM_FFB43D_COLOR                                UIColorFromRGB(0xffb43d)
#define COM_B1B1B1_COLOR                                UIColorFromRGB(0xb1b1b1)

#endif /* DColorDefine_h */
