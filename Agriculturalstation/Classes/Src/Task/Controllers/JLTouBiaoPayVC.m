//
//  JLTouBiaoPayVC.m
//  Agriculturalstation
//
//  Created by chw on 17/3/25.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLTouBiaoPayVC.h"
#import "ServerResult.h"

#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"

@interface JLTouBiaoPayVC ()<UIAlertViewDelegate>{
    NSString *uid;
    double accountBalance;
    int payType; // 支付方式：1支付宝(默认)、2微信、3余额
}

// 支付宝
- (IBAction)aliClick:(id)sender;
// 微信
- (IBAction)weixinClick:(id)sender;
// 余额
- (IBAction)balanceClick:(id)sender;
// 下一步
- (IBAction)nextClick:(id)sender;



// 账户余额
@property (strong, nonatomic) IBOutlet UILabel *balance;

// 需付金额
@property (strong, nonatomic) IBOutlet UILabel *cost;

// 支付宝
@property (strong, nonatomic) IBOutlet UIButton *aliCB;

// 微信
@property (strong, nonatomic) IBOutlet UIButton *weixinCB;

// 余额
@property (strong, nonatomic) IBOutlet UIButton *balanceCB;


@end

@implementation JLTouBiaoPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    payType = 1;
    self.cost.text = [NSString stringWithFormat:@"本次需支付金额为：%0.2f元",_totalprice];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    uid = [userDefaults objectForKey:@"uid"];
    
    // 获取账户余额
    [self getBalance];
}

- (void)getBalance{
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-task-op-balance.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = uid;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
        accountBalance = [result.msg doubleValue];
        self.balance.text = [NSString stringWithFormat:@"您的账户余额：%0.2f元", accountBalance];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        [MBProgressHUD showError:@"加载失败"];
    }];
}

// 支付宝
- (IBAction)aliClick:(id)sender {
    payType = 1;
    [self.aliCB setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
    [self.weixinCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self.balanceCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
}

// 微信
- (IBAction)weixinClick:(id)sender {
    payType = 2;
    [self.aliCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self.weixinCB setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
    [self.balanceCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
}

// 余额
- (IBAction)balanceClick:(id)sender {
    payType = 3;
    [self.aliCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self.weixinCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self.balanceCB setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
}

// 下一步
- (IBAction)nextClick:(id)sender {
    if (payType == 1){
        // 支付宝
    }else if (payType == 2){
        // 微信
    }else if (payType == 3){
        // 余额
        if(accountBalance < _totalprice){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的账户余额不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定进行支付吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self payTaskCost];
    }
}

// 余额支付
- (void)payTaskCost{
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-task-op-tbpay.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = uid;
    parameters[@"taskid"] = [NSString stringWithFormat:@"%d",_taskid];
    parameters[@"paytype"] = [NSString stringWithFormat:@"%d",payType];
    parameters[@"totalmoney"] = [NSString stringWithFormat:@"%0.2f",_totalprice];
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:result.msg];
        if(result.code == 200){
            // 支付成功
            // 返回上一页面
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        [MBProgressHUD showError:@"支付失败"];
    }];
}
@end




































