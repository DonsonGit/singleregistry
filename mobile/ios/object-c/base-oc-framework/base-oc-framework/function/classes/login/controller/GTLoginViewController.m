//
//  GTLoginViewController.m
//  GTreatCH
//
//  Created by 戴世豪 on 2017/7/18.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "GTLoginViewController.h"
#import "AppDelegate.h"
#import "GTLoginView.h"
#import "GTLoginViewModal.h"
#import "GTRegisterViewController.h"

@interface GTLoginViewController () <GTLoginViewDelegate>

@property (nonatomic, strong) GTLoginView * loginMainView;
@property (nonatomic, strong) GTLoginViewModal * viewModal;

@end

@implementation GTLoginViewController

-(instancetype)init{
    if (self = [super init]) {
        self.viewModal = [[GTLoginViewModal alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.loginMainView];
    
    [self Constraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)Constraints{
    [self.loginMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma - initView

-(GTLoginView *)loginMainView{
    if (nil == _loginMainView) {
        _loginMainView = [[GTLoginView alloc]init];
        _loginMainView.delegate = self;
    }
    return _loginMainView;
}

#pragma - GTLoginViewDelegate
-(void)login:(GTLoginView *)view{
    //TODO:登录
    NSLog(@"D-UserName------>%@",view.userName);
    NSLog(@"D-Password------>%@",view.password);
    if (view.userName.length < 6) {
        [self showToast:@"用户名不得少于6位"];
        return;
    }
    
    if (view.password.length < 6) {
        [self showToast:@"密码不得少于6位"];
        return;
    }
    
    [self.viewModal login:view.userName pwd:view.password];
    //    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    Class class = NSClassFromString(@"GTTabBarHomeViewController");
    //    appdelegate.window.rootViewController = [[class alloc] init];
    //    [[NSNotificationCenter defaultCenter]
}

///注册
-(void)registerCommit{
    GTRegisterViewController * controller = [[GTRegisterViewController alloc]init];
    UINavigationController * registerController = [[UINavigationController alloc]initWithRootViewController:controller];
    [registerController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont  boldSystemFontOfSize:18], NSForegroundColorAttributeName:COM_WHITE_COLOR}];
    registerController.navigationBar.barTintColor = COM_325DFE_COLOR;
    registerController.navigationBar.tintColor = COM_WHITE_COLOR;
    registerController.navigationBar.translucent = NO;
    [self presentViewController:registerController animated:YES completion:nil];
}

///忘记密码
-(void)lostPassword{
    GTRegisterViewController * controller = [[GTRegisterViewController alloc]init];
    controller.isForget = YES;
    UINavigationController * registerController = [[UINavigationController alloc]initWithRootViewController:controller];
    [registerController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont  boldSystemFontOfSize:18], NSForegroundColorAttributeName:COM_WHITE_COLOR}];
    registerController.navigationBar.barTintColor = COM_325DFE_COLOR;
    registerController.navigationBar.tintColor = COM_WHITE_COLOR;
    registerController.navigationBar.translucent = NO;
    [self presentViewController:registerController animated:YES completion:nil];
}

@end
