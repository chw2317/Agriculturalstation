//
//  JLGrabViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/13.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLGrabViewController.h"
#import "JLReleaseTaskModel.h"
#import "JLReleaseTaskTagCell.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface JLGrabViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    int start;
    NSString *perpage;
    BOOL flag;
}

@property(strong, nonatomic) NSMutableArray *releaseTaskModelArray;

@end

@implementation JLGrabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    start = 0;
    perpage = @"8";
    self.releaseTaskModelArray = [[NSMutableArray alloc] init];
    flag = false;
    
    // 创建一个分组样式的UITableView
    CGRect tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT - STATUS_HEIGHT - NAV_HEIGHT);
    _tableView= [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    // 设置委托
    _tableView.delegate = self;
    // 设置数据源
    _tableView.dataSource = self;
    
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        flag = true;
        // 清空数组中的数据
        [self.releaseTaskModelArray removeAllObjects];
        start = 0;
        [self sendRequest:start];
    }];
    
    // 设置自动切换透明度（在导航栏下面自动隐藏）
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        flag = true;
        [self sendRequest:start];
    }];
    
    // 加载数据
    [self sendRequest:start];
}

- (void)sendRequest:(int)startNum{
    if(flag){
        [MBProgressHUD showMessage:nil];
    }
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-task-op-all.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"start"] = [NSString stringWithFormat:@"%d", start];
    parameters[@"perpage"] = perpage;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [MBProgressHUD hideHUD];
        // 结束刷新
        [self endRefreshing];
        int count = [JLReleaseTaskModel mj_objectArrayWithKeyValuesArray:responseObject].count;
        [self.releaseTaskModelArray addObjectsFromArray:[JLReleaseTaskModel mj_objectArrayWithKeyValuesArray:responseObject]];
        start += count;
        if(flag){
            if(count < [perpage intValue]){
                [MBProgressHUD showSuccess:@"没有更多数据啦"];
            }
        }
        
        // 刷新UITableView
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 结束刷新
        [self endRefreshing];
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


#pragma mark - UITableView代理方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.releaseTaskModelArray.count;
}

#pragma mark - 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 创建Cell
    JLReleaseTaskTagCell *cell = [JLReleaseTaskTagCell releaseTaskTagCellWithTableView:tableView];
    // 2. 获取当前行的模型，设置cell数据
    JLReleaseTaskModel *releaseTaskModel = self.releaseTaskModelArray[indexPath.row];
    cell.releaseTaskModel = releaseTaskModel;
    // 3.返回cell
    return cell;
}

#pragma mark - 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.0f;
}

#pragma mark - 设置头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark - 设置尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 重写状态栏样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
































