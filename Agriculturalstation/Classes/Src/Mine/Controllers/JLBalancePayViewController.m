//
//  JLBalancePayViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

// 收支明细

#import "JLBalancePayViewController.h"

@interface JLBalancePayViewController ()
// 交易记录
- (IBAction)transactionRecords;


// 收入
@property (strong, nonatomic) IBOutlet UILabel *_income;
// 支出
@property (strong, nonatomic) IBOutlet UILabel *_spending;
// 余额
@property (strong, nonatomic) IBOutlet UILabel *_balance;

@end

@implementation JLBalancePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// 交易记录
- (IBAction)transactionRecords {
}
@end










































