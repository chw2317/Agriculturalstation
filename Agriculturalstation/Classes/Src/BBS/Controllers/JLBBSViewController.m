//
//  JLBBSViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/13.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLBBSViewController.h"
#import "JLBBSModel.h"
#import "JLBBSTagCell.h"

#import "MJRefresh.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@interface JLBBSViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSString *userUid;
    int start;
    NSString *perpage;
}

@property(strong,nonatomic) NSMutableArray *bbsModelArray;

@end

@implementation JLBBSViewController

#pragma mark - 懒加载

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    start = 0;
    perpage = @"15";
    self.bbsModelArray = [[NSMutableArray alloc] init];
    
    // 获取用户uid
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userUid = [userDefaults objectForKey:@"uid"];
    
    // 不能改变字体大小
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:nil action:nil];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
    [rightBtn addTarget:self action:@selector(rightEditorEvent) forControlEvents:UIControlEventTouchUpInside];
    // 普通状态
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 高亮状态
    [rightBtn setTitle:@"编辑" forState:UIControlStateHighlighted];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
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
        // 清空数组中的数据
        [self.bbsModelArray removeAllObjects];
        start = 0;
        [self sendRequest:start];
    }];
    
    // 设置自动切换透明度（在导航栏下面自动隐藏）
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self sendRequest:start];
    }];
    
    // 加载数据
    [self sendRequest:start];
}

-(void)rightEditorEvent{
    NSLog(@"编辑...");
}

- (void)sendRequest:(int)startNum{
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-forum-op-list.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = userUid;
    parameters[@"start"] = [NSString stringWithFormat:@"%d",start];
    parameters[@"perpage"] = perpage;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 结束刷新
        [self endRefreshing];
        int count = [JLBBSModel mj_objectArrayWithKeyValuesArray:responseObject].count;
        [self.bbsModelArray addObjectsFromArray:[JLBBSModel mj_objectArrayWithKeyValuesArray:responseObject]];
        start += count;
        if(count < [perpage intValue]){
            [MBProgressHUD showSuccess:@"没有更多数据啦"];
        }
        
        // 刷新UITableView
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 结束刷新
        [self endRefreshing];
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

#pragma mark - UITableView数据源方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bbsModelArray.count;
}

#pragma mark - 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 创建Cell
    JLBBSTagCell *cell = [JLBBSTagCell bbsTagCellWithTableView:tableView];
    // 2. 获取当前行的模型，设置cell数据
    JLBBSModel *bbsModel = self.bbsModelArray[indexPath.row];
    cell.bbsModel = bbsModel;
    // 3. 返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
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














































