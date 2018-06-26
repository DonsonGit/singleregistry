//
//  GTNavigationController.m
//  GTreat
//
//  Created by luyee on 2018/4/12.
//  Copyright © 2018年 Luyee. All rights reserved.
//

#import "GTNavigationController.h"

@interface GTNavigationController ()

@end

@implementation GTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:18.0 titleColor:[UIColor whiteColor]];
    [self setNavBkgColor:[UIColor colorWithRed:7.0/255.0 green:141.0/255.0 blue:237.0/255.0 alpha:1.0]];
    [self setNavTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
