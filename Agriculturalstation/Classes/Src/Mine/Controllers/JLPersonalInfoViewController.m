//
//  JLPersonalInfoViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLPersonalInfoViewController.h"
#import "JLUserBaseInfoViewController.h"
#import "JLFarmViewController.h"
#import "JLOwnerViewController.h"

@interface JLPersonalInfoViewController ()
// 基础信息
- (IBAction)baseInfo;
// 农场 or 农机信息
- (IBAction)farmOrOwnerInfo;


// 农场 or 农机信息
@property (strong, nonatomic) IBOutlet UIButton *farmOrOwner;
@property (assign, nonatomic) int regtype;

@end

@implementation JLPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.regtype = [[userDefaults objectForKey:@"regtype"] intValue];
    if(self.regtype == 1){ // 农场主
        [self.farmOrOwner setTitle:@"农场主" forState:UIControlStateNormal];
        [self.farmOrOwner setTitle:@"农场主" forState:UIControlStateHighlighted];
//        self.farmOrOwner.titleLabel.text = @"农场主";
    }else if (self.regtype == 2){ // 农机主
        [self.farmOrOwner setTitle:@"农机主" forState:UIControlStateNormal];
        [self.farmOrOwner setTitle:@"农机主" forState:UIControlStateHighlighted];
//        self.farmOrOwner.titleLabel.text = @"农机主";
    }
}

// 基础信息
- (IBAction)baseInfo {
    [self.navigationController pushViewController:[[JLUserBaseInfoViewController alloc] init] animated:YES];
}

// 农场 or 农机信息
- (IBAction)farmOrOwnerInfo { // 农场主
    if(self.regtype == 1){
        [self.navigationController pushViewController:[[JLFarmViewController alloc] init] animated:YES];
    }else if (self.regtype == 2){ // 农机主
        [self.navigationController pushViewController:[[JLOwnerViewController alloc] init] animated:YES];
    }
}
@end








