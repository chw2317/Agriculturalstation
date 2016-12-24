//
//  JLBBSViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/13.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLBBSViewController.h"
#import "MJRefresh.h"
#import "JLBBSModel.h"
#import "JLBBSTagCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"

@interface JLBBSViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
}
 @property(strong,nonatomic)NSArray *bbsModelArray;
@end

@implementation JLBBSViewController

#pragma mark - 懒加载
- (NSArray *)bbsModelArray{
    if(_bbsModelArray == nil){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"BBSModel.plist" ofType:nil];
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:tempArray.count];
        for(NSDictionary *dict in tempArray){
            JLBBSModel *bbsModel = [JLBBSModel statusWithDictionary:dict];
            [mutArray addObject:bbsModel];
        }
        _bbsModelArray = [mutArray mutableCopy];
    }
    return _bbsModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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
    
    // 创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    // 设置数据源
    _tableView.dataSource = self;
    // 设置代理
    _tableView.delegate = self;
    
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_tableView.mj_header endRefreshing];
        });
        [self sendRequest];
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
}

-(void)rightEditorEvent{
    NSLog(@"编辑...");
}

- (void)sendRequest{
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-forum-op-list.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = @"1";
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"请求成功：%@",responseObject);
        NSArray *bbsArray = [JLBBSModel mj_objectArrayWithKeyValuesArray:responseObject];
        for(JLBBSModel *bbsModel in bbsArray){
            NSLog(@"name=%@",bbsModel.name);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"请求失败:%@", error.description);
    }];
}

#pragma mark - UITableView数据源方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bbsModelArray.count;
}

// 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 创建Cell
    JLBBSTagCell *cell = [JLBBSTagCell bbsTagCellWithTableView:tableView];
    // 2. 获取当前行的模型，设置cell数据
    JLBBSModel *bbsModel = self.bbsModelArray[indexPath.row];
    cell.bbsModel = bbsModel;
    // 3. 返回cell
    return cell;
}

// 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

// 设置头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end














































