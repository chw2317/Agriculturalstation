//
//  JLFarmViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

    // 农场

#import "JLFarmViewController.h"
#import "JLFarmModel.h"
#import "JLFarmCell.h"
#import "AddFarmViewController.h"
#import "JLFarmDetailsViewController.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface JLFarmViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    int start;
    NSString *perpage;
}

@property(strong, nonatomic) NSMutableArray *farmModelArray;

@end

@implementation JLFarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    start = 0;
    perpage = @"10";
    self.farmModelArray = [[NSMutableArray alloc] init];
    
    self.title = @"我的农场";
    // 设置“添加”按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn addTarget:self action:@selector(rightAddFarmEvent) forControlEvents:UIControlEventTouchUpInside];
    // 普通状态
    [rightBtn setImage:[UIImage imageNamed:@"add_farm_right.png"] forState:UIControlStateNormal];
    // 添加
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
    CGRect tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT - STATUS_HEIGHT - NAV_HEIGHT);
    // 创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    // 设置数据源
    _tableView.dataSource = self;
    // 设置代理
    _tableView.delegate = self;
    
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [_tableView.mj_header endRefreshing];
//        });
        // 清空数组
        [self.farmModelArray removeAllObjects];
        start = 0;
        [self sendRequest:start];
    }];
    
    // 设置自动切换透明度（在导航栏下面自动隐藏）
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [_tableView.mj_footer endRefreshing];
//        });
        [self sendRequest:start];
    }];
    
    // 加载数据
    [self sendRequest:start];
}

- (void)sendRequest:(int)startNum{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-myfarm-op-all.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"uid"] = userUid;
    parameters[@"start"] = [NSString stringWithFormat:@"%d",startNum];
    parameters[@"perpage"] = perpage;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 结束刷新
        [self endRefreshing];
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        int count = [JLFarmModel mj_objectArrayWithKeyValuesArray:responseObject].count;
        [self.farmModelArray addObjectsFromArray:[JLFarmModel mj_objectArrayWithKeyValuesArray:responseObject]];

        JLLog(@"count=%d",self.farmModelArray.count);
        start += count;
        
        if(count < [perpage intValue]){
            [MBProgressHUD showSuccess:@"没有更多数据啦"];
        }
        
//        for(JLFarmModel *farmer in self.farmModelArray){
//            JLLog(@"username=%@",farmer.username);
//        }
        // 刷新UITableView
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 结束刷新
        [self endRefreshing];
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“加载失败”的提示；
        [MBProgressHUD showError:@"加载失败"];
    }];
}

- (void)endRefreshing{
    if([_tableView.mj_header isRefreshing]){
        // 结束刷新
        [_tableView.mj_header endRefreshing];
    }
    if([_tableView.mj_footer isRefreshing]){
        // 结束刷新
        [_tableView.mj_footer endRefreshing];
    }
}

// 添加农场
- (void)rightAddFarmEvent{
    [self.navigationController pushViewController:[[AddFarmViewController alloc]init] animated:YES];
}

#pragma mark - UITableView数据源方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.farmModelArray.count;
}

#pragma mark - 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 创建Cell
    JLFarmCell *cell = [JLFarmCell farmCellWithTableView:tableView];
    // 2. 获取当前行的模型，设置cell数据
    JLFarmModel *farmModel = self.farmModelArray[indexPath.row];
    cell.farmModel = farmModel;
    // 3. 返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JLFarmDetailsViewController *farmDetails = [JLFarmDetailsViewController new];
    farmDetails.farmerUid = [self.farmModelArray[indexPath.row] uid];
    farmDetails.username = [self.farmModelArray[indexPath.row] username];
    [self.navigationController pushViewController:farmDetails animated:YES];
}

#pragma mark - 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0f;
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






























