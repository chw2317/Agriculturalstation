//
//  JLLoginViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/13.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLLoginViewController.h"
#import "JLRegisterViewController.h"
#import "JLForgetPWDViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface JLLoginViewController (){
    UIImageView *_loginLogoLeft; // 左侧Logo
    UIImageView *_loginLogoRight; // 右侧Logo
    UITextField *_userName; // 用户名
    UITextField *_passWord; // 密码
    UIButton *_loginBtn; // 登录
    UIButton *_forgetPWD; // 忘记密码
    UIButton *_registerBtn; // 注册账号
}

@end

@implementation JLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    self.title = @"登 录";
    // 设置self.title的字体大小以及颜色
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
}

// 初始化视图
-(void)initView{
    // 设置View的背景图片
    UIImageView *parentViewbg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg.png"]];
    parentViewbg.frame = self.view.bounds;
    parentViewbg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:parentViewbg atIndex:0];
    
    CGFloat logoW = 80;
    CGFloat logoH = logoW;
    CGFloat logoX = (SCREEN_WIDTH - (logoW * 3 + 10)) * 0.5;
    CGFloat logoY = SCREEN_HEIGHT * 0.05;
    CGRect leftLogoRect = CGRectMake(logoX, logoY, logoW, logoH);
    // 左侧Logo
    _loginLogoLeft = [[UIImageView alloc]initWithFrame:leftLogoRect];
    _loginLogoLeft.image = [UIImage imageNamed:@"login_logo_left.png"];
    [self.view addSubview:_loginLogoLeft];
    // 右侧Logo
    CGRect rightLogoRect = CGRectMake((logoX + logoW + 10), (logoY + 20), (logoW * 2), (logoH - 20));
    _loginLogoRight = [[UIImageView alloc]initWithFrame:rightLogoRect];
    _loginLogoRight.image = [UIImage imageNamed:@"login_logo_right.png"];
    [self.view addSubview:_loginLogoRight];
    
    // 用户名和密码的背景框
    CGFloat inputW = logoW * 3 + 50;
    CGFloat inputH = 80;
    CGFloat inputX = (SCREEN_WIDTH - inputW) * 0.5;
    CGFloat inputY = logoY + logoH + 100;
    CGRect inputRect = CGRectMake(inputX, inputY, inputW, inputH);
    // 设置用户名和密码背景颜色
    UIView *inputView = [[UIView alloc]initWithFrame:inputRect];
    // 圆角
    inputView.layer.cornerRadius = 5.0;
    // border
    inputView.layer.borderWidth = 1;
    inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [inputView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:inputView];
    
    // 用户名和密码中间的分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(inputX, (inputY + (inputH * 0.5)), inputW, 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:line];
    
    // 用户名
    CGRect userNameRect = CGRectMake(20, 0, (inputW - 20), 40);
    _userName = [[UITextField alloc]initWithFrame:userNameRect];
    _userName.placeholder = @"用户名";
    // 左侧小图标
    UIImageView *userNameImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
    userNameImg.image = [UIImage imageNamed:@"login_username.png"];
    _userName.leftView = userNameImg;
    _userName.leftViewMode = UITextFieldViewModeAlways;
    // 设置内容垂直居中
    _userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [inputView addSubview:_userName];
    // 密码
    CGRect pwdRect = CGRectMake(20, 41, (inputW - 20), 39);
    _passWord = [[UITextField alloc]initWithFrame:pwdRect];
    _passWord.placeholder = @"请输入密码";
    // 左侧小图标
    UIImageView *pwdImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    pwdImg.image = [UIImage imageNamed:@"login_password.png"];
    _passWord.leftView = pwdImg;
    _passWord.leftViewMode = UITextFieldViewModeAlways;
    // 设置内容垂直居中
    _passWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [inputView addSubview:_passWord];
    
    // 登录按钮
    CGFloat loginBtnH = 40;
    _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(inputX, (inputY + inputH + 30), inputW, loginBtnH)];
    // 正常状态
    [_loginBtn setTitle:@"登   录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.backgroundColor = [UIColor greenColor];
    _loginBtn.layer.cornerRadius = 5.0;
    // 添加按钮点击事件
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    // 忘记密码
    _forgetPWD = [[UIButton alloc]initWithFrame:CGRectMake(inputX, (inputY + inputH + loginBtnH + 50), 100, 30)];
    [_forgetPWD setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPWD setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _forgetPWD.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _forgetPWD.titleLabel.font = [UIFont systemFontOfSize:12];
    // 添加按钮点击事件
    [_forgetPWD addTarget:self action:@selector(toForgetPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPWD];
    
    // 注册账户
    _registerBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - inputX - 100), (inputY + inputH + loginBtnH + 50), 100, 30)];
    [_registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    // 添加按钮点击事件
    [_registerBtn addTarget:self action:@selector(toRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
}

// 发送数据到服务器进行登录
-(void)login{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:@"正在登录..."];
    // 请求地址
    NSString *url = @"http://rifeng.weixinbm.com/app-login-op-login.html";
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = _userName.text;
    parameters[@"password"] = _passWord.text;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSDictionary *resultArray = responseObject;
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        if([resultArray[@"result"] intValue] == 1){ // 登录成功
            //弹出“登录成功”的提示；
            [MBProgressHUD showSuccess:@"登录成功"];
            // 记录用户登录状态
            // 获取NSUserDefault单例
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            // 登录成功后把用户相关信息存储到userDefault
            [userDefaults setObject:resultArray[@"uid"] forKey:@"uid"]; // uid
            [userDefaults setObject:resultArray[@"username"] forKey:@"username"]; // 用户名
            [userDefaults setObject:resultArray[@"phone"] forKey:@"phone"]; // 手机号
            [userDefaults setObject:resultArray[@"avatar"] forKey:@"avatar"]; // 头像
            [userDefaults setObject:resultArray[@"regtype"] forKey:@"regtype"]; // 注册类型，农场主 1/农机主 2
            [userDefaults synchronize];
            
            // 登录成功，返回上一页面
            [self.navigationController popViewControllerAnimated:YES];
        }else{ // 登录失败
            //弹出“登录失败”的提示；
            [MBProgressHUD showError:resultArray[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“登录失败”的提示；
        [MBProgressHUD showError:@"登录失败"];
    }];
}

// 跳转到忘记密码界面
-(void)toForgetPassWord{
    [self.navigationController pushViewController:[[JLForgetPWDViewController alloc]init] animated:YES];
}
// 跳转到注册账户界面
-(void)toRegister{
    [self.navigationController pushViewController:[[JLRegisterViewController alloc]init] animated:YES];
}

@end




































