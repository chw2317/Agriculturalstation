//
//  JLTabBarController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/8.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLTabBarController.h"
#import "JLHomeViewController.h"
#import "JLTaskViewController.h"
#import "JLGrabViewController.h"
#import "JLBBSViewController.h"
#import "JLMineViewController.h"
#import "JLNavigationController.h"

@interface JLTabBarController ()

@end

@implementation JLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpAllChildViewController];
}

/**
 *
 * 添加所有子控制器
 *
 */
- (void)setUpAllChildViewController{
    // 添加第1个控制器（首页）
    JLHomeViewController *homeVC = [[JLHomeViewController alloc]init];
    [self setUpOneChildViewController:homeVC image:[UIImage imageNamed:@"tab_home-Small"] title:@"首页"];
    
    // 添加第2个控制器（任务）
    JLTaskViewController *taskVC = [[JLTaskViewController alloc]init];
    [self setUpOneChildViewController:taskVC image:[UIImage imageNamed:@"tab_task-Small"] title:@"任务"];
    
    // 添加第3个控制器（抢单）
    JLGrabViewController *grabVC = [[JLGrabViewController alloc]init];
    [self setUpOneChildViewController:grabVC image:[UIImage imageNamed:@"tab_grab-Small"] title:@"抢单"];
    
    // 添加第4个控制器（论坛）
    JLBBSViewController *bbsVC = [[JLBBSViewController alloc]init];
    [self setUpOneChildViewController:bbsVC image:[UIImage imageNamed:@"tab_bbs-Small"] title:@"论坛"];
    
    // 添加第5个控制器（我的）
    JLMineViewController *mineVC = [[JLMineViewController alloc]init];
    [self setUpOneChildViewController:mineVC image:[UIImage imageNamed:@"tab_mine-Small"] title:@"我的"];
}

/**
 *
 * 添加一个子控制器的方法
 *
 */
- (void)setUpOneChildViewController:(UIViewController *)viewController image:
    (UIImage *)image title:(NSString *)title{
    JLNavigationController *navC = [[JLNavigationController alloc]initWithRootViewController:viewController];
    navC.title = title;
    navC.tabBarItem.image = image;
    [navC.navigationBar setBackgroundImage:[UIImage imageNamed:@"commentary_num_bg"] forBarMetrics:UIBarMetricsDefault];
    viewController.navigationItem.title = title;
    // 设置self.title的字体大小以及颜色
    viewController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
    
    [self addChildViewController:navC];
}

@end





































