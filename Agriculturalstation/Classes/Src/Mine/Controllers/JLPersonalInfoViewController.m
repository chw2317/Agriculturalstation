//
//  JLPersonalInfoViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLPersonalInfoViewController.h"
#import "JLUserBaseInfoViewController.h"

@interface JLPersonalInfoViewController ()
// 基础信息
- (IBAction)baseInfo;
// 农场 or 农机信息
- (IBAction)farmOrOwnerInfo;

@end

@implementation JLPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:16]};
}

// 基础信息
- (IBAction)baseInfo {
    [self.navigationController pushViewController:[[JLUserBaseInfoViewController alloc] init] animated:YES];
}

// 农场 or 农机信息
- (IBAction)farmOrOwnerInfo {
}
@end
