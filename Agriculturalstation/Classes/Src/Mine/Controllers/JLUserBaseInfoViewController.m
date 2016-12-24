//
//  JLUserBaseInfoViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/19.
//  Copyright © 2016年 chw. All rights reserved.
//

 // 用户基础信息视图

#import "JLUserBaseInfoViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface JLUserBaseInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSArray *_itemLabelArray;
    NSArray *_itemContentArray;
}


@end

@implementation JLUserBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self sendRequest];
    
    self.title = @"基础信息";
    
    // 拿到xib视图
    NSArray *userInfoXib = [[NSBundle mainBundle]loadNibNamed:@"JLUserBaseInfo" owner:nil options:nil];
    UIView *userInfoView = [userInfoXib firstObject];
    
    // 相关证件一
    UIButton *certificate1 = (UIButton *)[userInfoView viewWithTag:1];
    [certificate1 addTarget:self action:@selector(certificate1BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 相关证件二
    UIButton *certificate2 = (UIButton *)[userInfoView viewWithTag:2];
    [certificate2 addTarget:self action:@selector(certificate2BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _itemContentArray = [NSArray array];
    _itemLabelArray = [NSArray arrayWithObjects:@"用户名",@"用户类型",@"联系电话",@"真实姓名",@"身份证号",@"籍贯",@"详细地址", nil];
    // 创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    headerView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.0];
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = userInfoView;
    
    [self.view addSubview:_tableView];
    // 设置数据源
    _tableView.dataSource = self;
    // 设置代理
    _tableView.delegate = self;
}

- (void)sendRequest{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userDefaults objectForKey:@"uid"];
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-personalinfo-op-get.html"];
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
        [self setUserDatas:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“登录失败”的提示；
        [MBProgressHUD showError:@"加载失败"];
    }];

}

- (void)setUserDatas:(id)responseObject{
    // 用户名
    NSString *userName = NULLString(responseObject[@"username"])?@"未填写":responseObject[@"username"];
    // 用户类型
    NSString *userType = @"";
    switch ([responseObject[@"usertype"] intValue]) {
        case 1:
            userType = @"个人";
            break;
        
        case 2:
            userType = @"公司";
            break;
        
        case 3:
            userType = @"企业";
            break;
    }
    // 联系电话
    NSString *phoneNumber = NULLString(responseObject[@"phone"])?@"未填写":responseObject[@"phone"];
    // 真实姓名
    NSString *realName = NULLString(responseObject[@"realname"])?@"未填写":responseObject[@"realname"];
    // 身份证号
    NSString *idcard = NULLString(responseObject[@"idcard"])?@"未填写":responseObject[@"idcard"];
    // 籍贯
    NSString *nativePlace = NULLString(responseObject[@"province"])?@"未填写":[NSString stringWithFormat:@"%@-%@",responseObject[@"province"],responseObject[@"city"]];
    // 详细地址
    NSString *address = NULLString(responseObject[@"address"])?@"未填写":responseObject[@"address"];
    
    _itemContentArray = @[userName,userType,phoneNumber,realName,idcard,nativePlace,address];
    // 刷新UITableView
    [_tableView reloadData];
}

// 相关证件一
- (void)certificate1BtnAction:(UIButton *)sender{
    NSLog(@"相关证件一");
}

// 相关证件二
- (void)certificate2BtnAction:(UIButton *)sender{
    NSLog(@"相关证件二");
}

#pragma mark - UITableView数据源方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemLabelArray.count;
}

// 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UITableViewIdentifierKey1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _itemLabelArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if(_itemContentArray.count > 0){
        cell.detailTextLabel.text = _itemContentArray[indexPath.row];
    }
//    cell.detailTextLabel.text = @"墨明棋妙";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

// 如果设置header（或者footer）高度是0的话，系统会认为你没设置，然后将其设置为40.0f
// 设置头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001f;
}

// 设置尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}
@end
























































