//
//  JLAccountInfoViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

  //  账户信息

#import "JLAccountInfoViewController.h"

@interface JLAccountInfoViewController ()
// 充值
- (IBAction)chongZhiBtn;
// 提现
- (IBAction)withDrawalBtn;


// 账户余额
@property (strong, nonatomic) IBOutlet UILabel *_balance;
// 我的星级
@property (strong, nonatomic) IBOutlet UIView *_starsView;
// 个人积分
@property (strong, nonatomic) IBOutlet UILabel *_integral;


@end

@implementation JLAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)chongZhiBtn {
}

- (IBAction)withDrawalBtn {
}
@end






































