//
//  UIImage+Watermark.h
//  GTreatCH
//
//  Created by yangji on 2018/2/12.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Watermark)

+ (UIImage *)getWaterMarkImage: (UIImage *)originalImage andTitle: (NSString *)title andMarkFont: (UIFont *)markFont andMarkColor: (UIColor *)markColor;

@end
