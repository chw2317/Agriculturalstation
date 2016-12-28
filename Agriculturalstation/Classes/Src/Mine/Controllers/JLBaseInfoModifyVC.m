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

@interface JLBaseInfoModifyVC ()
- (IBAction)deleteBtn;


@property (strong, nonatomic) IBOutlet UILabel *_titleLabel; // 标题
@property (strong, nonatomic) IBOutlet UITextField *_content; // 内容
@property (strong, nonatomic) NSString *key;



@end

@implementation JLBaseInfoModifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

// 清空按钮
- (IBAction)deleteBtn {
    self._content.text = nil;
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
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //弹出“保存成功”的提示；
        [MBProgressHUD showSuccess:@"保存失败"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
        
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //弹出“保存成功”的提示；
        [MBProgressHUD showSuccess:@"保存成功"];
        // 代理传值
        [_delegate pass:self._content.text andIndex:_index];
        // 保存成功，返回上一页面
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
@end














































