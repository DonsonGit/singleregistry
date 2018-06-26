//
//  DTabBarHomeViewController.m
//  base-oc-framework
//
//  Created by 戴世豪 on 2018/6/26.
//  Copyright © 2018年 戴世豪. All rights reserved.
//

#import "DTabBarHomeViewController.h"
#import "GTNavigationController.h"

@interface DTabBarHomeViewController ()

@end

@implementation DTabBarHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTabBarController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init tabbarController

- (void)initTabBarController
{
    GTNavigationController * taskNav = [self createTabWithRootController:@"GTHomePageViewController" titleName:@"首页" normalImageName:@"tabbar_hall_normal_icon" selectedImageName:@"tabbar_hall_select_icon"];
    GTNavigationController * publishNav = [self createTabWithRootController:@"GTServicesViewController" titleName:@"服务" normalImageName:@"tabbar_pub_normal_icon" selectedImageName:@"tabbar_pub_select_icon"];
    [publishNav.tabBarItem setImageInsets:UIEdgeInsetsMake(-17, -2, 13,-2)];
    GTNavigationController * mapNav = [self createTabWithRootController:@"GTMapViewController" titleName:@"地图" normalImageName:@"tabbar_me_normal_icon" selectedImageName:@"tabbar_me_select_icon"];
    GTNavigationController * meNav = [self createTabWithRootController:@"GTMineViewController" titleName:@"我的" normalImageName:@"tabbar_me_normal_icon" selectedImageName:@"tabbar_me_select_icon"];
    self.viewControllers = @[taskNav, publishNav, mapNav, meNav];
}

- (GTNavigationController *)createTabWithRootController:(NSString *)controllerClassName titleName:(NSString *)titleName normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName
{
    Class className = NSClassFromString(controllerClassName);
    UIViewController * controller = [[className alloc] init];
    GTNavigationController * nav = [[GTNavigationController alloc] initWithRootViewController:controller];
    nav.tabBarItem = [self createTabBarItem:titleName image:normalImageName selectedImage:selectedImageName];
    return nav;
}

- (UITabBarItem *)createTabBarItem:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName
{
    UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:COM_TABBAR_UNSELECTED_COLOR} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:COM_TABBAR_SELECTED_COLOR} forState:UIControlStateSelected];
    return item;
}

@end
