//
//  JLBalancePayViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

// 收支明细

#import "JLBalancePayViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

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
    // 获取userDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userDefaults objectForKey:@"uid"];
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = @"http://rifeng.weixinbm.com/app-personalinfo-op-income.html";
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = uid;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        // 收入
        self._income.text = [@"￥" stringByAppendingString:responseObject[@"income"]];
        // 支出
        self._spending.text = [@"￥" stringByAppendingString:responseObject[@"spending"]];
        // 余额
        self._balance.text = [@"￥" stringByAppendingString:responseObject[@"balance"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“加载失败”的提示；
        [MBProgressHUD showError:@"加载失败"];
    }];
}

// 交易记录
- (IBAction)transactionRecords {
}
@end










































