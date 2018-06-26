//
//  GTBaseViewControler.m
//  GTreat
//
//  Created by luyee on 2017/6/17.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "GTBaseViewControler.h"
#import "CommonUtil.h"

@interface GTBaseViewControler ()

@end

@implementation GTBaseViewControler

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavBackItemButtton:YES];
}

#pragma mark - init back button

- (void)createNavBackItemButtton:(BOOL)show
{
    if(show) {
        if (self.navigationController.viewControllers.count > 1 ) { // 栈里面不止一个ViewController
            self.backBtn = [CommonUtil createLeftImageBarItem:[UIImage imageNamed:@"default_back_icon"] viewcontroller:self selector:@selector(vc_back)];
        } else {
            if (self.presentingViewController) { // present形式
                self.backBtn = [CommonUtil createLeftTitleBarItem:@"关闭" color:[UIColor whiteColor] fontsize:16.0 viewcontroller:self selector:@selector(vc_back)];
            }
        }
        
    } else {
        self.navigationController.navigationItem.leftBarButtonItems = nil;
        self.backBtn = nil;
    }
}

- (void)setShowBackBtn:(BOOL)showBackBtn
{
    [self createNavBackItemButtton:showBackBtn];
}

#pragma mark - no data view

- (void) showNodataView
{
    if(self.nodataView == nil) {
        self.nodataView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.nodataView.backgroundColor = [UIColor whiteColor];
        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_no_data_icon"]];
        image.contentMode = UIViewContentModeCenter;
        image.backgroundColor = [UIColor clearColor];
        [self.nodataView addSubview:image];
        
        UILabel *text = [[UILabel alloc] init];
        text.backgroundColor = [UIColor clearColor];
        text.text = @"亲，目前没有数据哦～";
        text.textAlignment = NSTextAlignmentCenter;
        text.textColor = [UIColor grayColor];
        text.font = [UIFont systemFontOfSize:15.0];
        [self.nodataView addSubview:text];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nodataView.mas_centerY).offset(-50);
            make.centerX.equalTo(self.nodataView.mas_centerX);
        }];
        
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(image.mas_bottom).offset(8);
            make.centerX.equalTo(image.mas_centerX);
            make.height.equalTo(15);
        }];
    }
    [self.view insertSubview:self.nodataView atIndex:0];
    [self.nodataView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

- (void)hideNodataView
{
    if(self.nodataView == nil) {
        return;
    }
    [self.nodataView removeFromSuperview];
}

@end
