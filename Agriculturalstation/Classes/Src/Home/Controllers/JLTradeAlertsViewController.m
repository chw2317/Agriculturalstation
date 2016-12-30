//
//  JLTradeAlertsViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

    // 行业快讯

#import "JLTradeAlertsViewController.h"
#import "JLTradeAlertsModel.h"
#import "JLTradeAlertsCell.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface JLTradeAlertsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
}

@property(strong, nonatomic)NSMutableArray *tradeAlertsModelArray;

@end

@implementation JLTradeAlertsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT - STATUS_HEIGHT - NAV_HEIGHT);
    // 创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    // 设置数据源
    _tableView.dataSource = self;
    // 设置委托
    _tableView.delegate = self;
    
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_tableView.mj_header endRefreshing];
        });
    }];
    
    // 设置自动切换透明度（在导航栏下面自动隐藏）
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_tableView.mj_footer endRefreshing];
        });
    }];
    
    // 加载数据
    [self sendRequest];
}

- (void)sendRequest{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-tradealerts-op-list.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"uid"] = userUid;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        self.tradeAlertsModelArray = [JLTradeAlertsModel mj_objectArrayWithKeyValuesArray:responseObject];
        // 刷新UITableView
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“加载失败”的提示；
        [MBProgressHUD showError:@"加载失败"];
    }];

}

#pragma mark - UITableView数据源方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tradeAlertsModelArray.count;
}

#pragma mark - 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 创建Cell
    JLTradeAlertsCell *cell = [JLTradeAlertsCell tradeAlertsCellWithTableView:tableView];
    // 2. 获取当前行的模型，设置cell数据
    JLTradeAlertsModel *tradeAlertsModel = self.tradeAlertsModelArray[indexPath.row];
    cell.tradeAlertsModel = tradeAlertsModel;
    // 3. 返回cell
    return cell;
}

#pragma mark - 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

#pragma mark - 设置头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark - 设置尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

@end









































