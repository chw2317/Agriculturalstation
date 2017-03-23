//
//  JLPWDManagementViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

// 密码管理

#import "JLPWDManagementViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "ServerResult.h"
#import "MJExtension.h"

@interface JLPWDManagementViewController ()
// 确认修改
- (IBAction)confirmModify;


// 原始密码
@property (strong, nonatomic) IBOutlet UITextField *_oldPassWord;
// 新密码
@property (strong, nonatomic) IBOutlet UITextField *_passWord;
// 确认新密码
@property (strong, nonatomic) IBOutlet UITextField *_confirmPassWord;

@end

@implementation JLPWDManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// 确认修改
- (IBAction)confirmModify {
    if(NULLString(self._oldPassWord.text) || NULLString(self._passWord.text) || NULLString(self._confirmPassWord.text)){
        [self showAlert:@"请填写完整信息"];
    }else if(![self._passWord.text isEqualToString:self._confirmPassWord.text]){
        [self showAlert:@"两次密码输入不一致"];
    }else{
        // 获取userDefaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // 获取用户的uid
        NSString *uid = [userDefaults objectForKey:@"uid"];
        // 显示MBProgressHUD
        [MBProgressHUD showMessage:nil];
        // 请求地址
        NSString *url = [REQUEST_URL stringByAppendingString:@"app-personalinfo-op-password.html"];
        // 请求管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        // 拼接请求参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"uid"] = uid;
        parameters[@"oldpwd"] = self._oldPassWord.text;
        parameters[@"newpwd"] = self._passWord.text;
        // 发起请求
        [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            // 隐藏MBProgressHUD
            [MBProgressHUD hideHUD];
            
            ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
            if(result.code == 200){
                // 弹出服务器返回的提示；
                [MBProgressHUD showSuccess:result.msg];
                // 修改成功，返回上一页面
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            // 隐藏MBProgressHUD
            [MBProgressHUD hideHUD];
            //同时弹出“修改失败”的提示；
            [MBProgressHUD showError:@"修改失败"];
        }];
    }
}

- (void)showAlert:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}
@end












































