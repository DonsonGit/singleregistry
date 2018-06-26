//
//  GTHomePageViewController.m
//  GTreat
//
//  Created by luyee on 2017/6/19.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "GTHomePageViewController.h"
#import "GTLoginViewController.h"

@interface GTHomePageViewController ()

@end

@implementation GTHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GTLoginViewController * controller = [[GTLoginViewController alloc]init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
