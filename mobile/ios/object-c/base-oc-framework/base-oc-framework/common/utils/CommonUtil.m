//
//  CommonUtil.m
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+ (id)convertJSONToObject:(NSString *)string
{
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!data || data == nil) {
        return nil;
    }
    id ret = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (nil == error){
        return ret;
    }else{
        return nil;
    }
}

+ (NSString *)convertObjectToJSON:(id)object
{
    NSError *error = nil;
    NSData  *data = nil;
    if (object) {
        data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    if (data == nil) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (int)sexFromIdCard:(NSString *)idCard
{
    int result = 0;
    BOOL isAllNumber = YES;
    if([idCard length]<17)
        return result;
    //**截取第17为性别识别符
    NSString *fontNumer = [idCard substringWithRange:NSMakeRange(16, 1)];
    //**检测是否是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    if(!isAllNumber)
        return result;
    int sexNumber = [fontNumer intValue];
    if(sexNumber%2==1)
        result = 1;
    ///result = @"M";
    else if (sexNumber%2==0)
        result = 2;
    //result = @"F";
    return result;
}

+ (NSData *)compressImage:(UIImage *)image toMaxFileSize:(CGFloat)maxFileSize
{
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.2f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}

+ (UIButton *)createRightTitleBarItem:(NSString *)title color:(UIColor *)color fontsize:(CGFloat)size viewcontroller:(UIViewController *)controller selector:(SEL)sel
{
    CGFloat width = [title boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size.width;
    width = width > 44 ? width : 44;
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:color forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:size]];
    if(sel) {
        [rightBtn addTarget:controller action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(!controller.navigationItem.rightBarButtonItems) {
        if([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
            rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
            UIBarButtonItem * rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
            [controller.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBtnItem, nil]];
        } else {
            UIBarButtonItem * rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                negativeSpacer.width = -6;
            } else {
                negativeSpacer.width = 0;
            }
            [controller.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBtnItem, nil]];
        }
    } else {
        UIBarButtonItem * rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:controller.navigationItem.rightBarButtonItems];
        [arr addObject:rightBtnItem];
        [controller.navigationItem setRightBarButtonItems:arr];
    }
    
    return rightBtn;
}


+ (UIButton *)createLeftTitleBarItem:(NSString *)title color:(UIColor *)color fontsize:(CGFloat)size viewcontroller:(UIViewController *)controller selector:(SEL)sel
{
    CGFloat width = [title boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size.width;
    width = width > 44 ? width : 44;
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:color forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:size]];
    if(sel) {
        [rightBtn addTarget:controller action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
        rightBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        UIBarButtonItem * rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        [controller.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:rightBtnItem, nil]];
    } else {
        UIBarButtonItem * rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            negativeSpacer.width = -6;
        } else {
            negativeSpacer.width = 0;
        }
        [controller.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBtnItem, nil]];
    }
    
    return rightBtn;
}

+ (UIButton *)createRightImageBarItem:(UIImage *)image viewcontroller:(UIViewController *)controller selector:(SEL)sel
{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 40)];
    [rightBtn setImage:image forState:UIControlStateNormal];
    if(sel) {
        [rightBtn addTarget:controller action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(!controller.navigationItem.rightBarButtonItems) {
        if([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
            rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            UIBarButtonItem * rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
            [controller.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBtnItem, nil]];
        } else {
            UIBarButtonItem * rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                negativeSpacer.width = -12;
            } else {
                negativeSpacer.width = 0;
            }
            [controller.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBtnItem, nil]];
        }
    } else {
        UIBarButtonItem * rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:controller.navigationItem.rightBarButtonItems];
        [arr addObject:rightBtnItem];
        [controller.navigationItem setRightBarButtonItems:arr];
    }
    
    return rightBtn;
}

+ (UIButton *)createLeftImageBarItem:(UIImage *)image viewcontroller:(UIViewController *)controller selector:(SEL)sel
{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 40)];
    [rightBtn setImage:image forState:UIControlStateNormal];
    if(sel) {
        [rightBtn addTarget:controller action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
        rightBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        [controller.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftBarButtonItem, nil]];
    } else {
        UIBarButtonItem * rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            negativeSpacer.width = -18;
        } else {
            negativeSpacer.width = 0;
        }
        [controller.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBtnItem, nil]];
    }
    
    return rightBtn;
}


//将文件copy到tmp目录
+ (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL
{
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}


@end
