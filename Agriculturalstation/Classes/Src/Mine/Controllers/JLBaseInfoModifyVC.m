//
//  JLBaseInfoModifyVC.m
//  Agriculturalstation
//
//  Created by chw on 16/12/28.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLBaseInfoModifyVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"

#import "ServerResult.h"


@interface JLBaseInfoModifyVC ()

@property (strong, nonatomic) IBOutlet UILabel *_titleLabel; // 标题
@property (strong, nonatomic) IBOutlet UITextField *_content; // 内容
@property (strong, nonatomic) NSString *key;
@property (nonatomic, strong) NSUserDefaults *userDefaults;


@end

@implementation JLBaseInfoModifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 获取NSUserDefault单例
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
    [rightBtn addTarget:self action:@selector(rightSaveEvent) forControlEvents:UIControlEventTouchUpInside];
    // 普通状态
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 高亮状态
    [rightBtn setTitle:@"保存" forState:UIControlStateHighlighted];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self._titleLabel.text = _titleStr;
    self._content.text = _contextStr;
    switch (_index) {
        case 0:
            self.key = @"username";
            break;
            
        case 2:
            self.key = @"phone";
            break;
            
        case 3:
            self.key = @"realname";
            break;
            
        case 4:
            self.key = @"idcard";
            break;
            
        case 6:
            self.key = @"resideaddress";
            break;
    }
}

// 保存
- (void)rightSaveEvent{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-personalinfo-op-change.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = _userUid;
    parameters[@"key"] = self.key;
    parameters[@"value"] = self._content.text;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
        if(result.code == 200){
            // 隐藏MBProgressHUD
            [MBProgressHUD hideHUD];
            //弹出“保存成功”的提示；
            [MBProgressHUD showSuccess:result.msg];
            
            // 更新用户信息
            if([self.key isEqualToString:@"username"]){
                [self.userDefaults setObject:self._content.text forKey:self.key];
            }else if ([self.key isEqualToString:@"phone"]){
                [self.userDefaults setObject:self._content.text forKey:self.key];
            }
            
            // 代理传值
            [_delegate pass:self._content.text andIndex:_index];
            // 保存成功，返回上一页面
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //弹出“保存失败”的提示；
        [MBProgressHUD showSuccess:@"保存失败"];
    }];
}
@end














































