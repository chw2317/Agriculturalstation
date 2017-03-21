//
//  JLFarmDetailsViewController.m
//  Agriculturalstation
//
//  Created by chw on 17/1/6.
//  Copyright © 2017年 chw. All rights reserved.
//

    // 农场信息

#import "JLFarmDetailsViewController.h"
#import "JLFarmListModel.h"
#import "JLFarmDetailCell.h"
#import "ServerResult.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface JLFarmDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    int start;
    NSString *perpage;
    UILabel *commentLabel; // 最新评论
    UIView *headerView;
}

@property(strong, nonatomic) NSMutableArray *farmDetailArray;

@end

@implementation JLFarmDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"农场信息";
    start = 0;
    perpage = @"5";
    self.farmDetailArray = [[NSMutableArray alloc] init];
    
    // HeaderView
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    // 最新评论
    commentLabel = [[UILabel alloc] initWithFrame:(CGRect){16, 40, SCREEN_WIDTH, 20}];
    commentLabel.text = @"最新评论：";
    commentLabel.textColor = [UIColor redColor];
    [headerView addSubview:commentLabel];
    // 用户名
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:(CGRect){16, 16, SCREEN_WIDTH, 20}];
    userNameLabel.text = self.username;
    userNameLabel.textColor = [UIColor redColor];
    [headerView addSubview:userNameLabel];
    
    CGRect tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT - STATUS_HEIGHT - NAV_HEIGHT);
    // 创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = headerView;
    
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
        [self.farmDetailArray removeAllObjects];
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
//    JLLog(@"线程一：%@",[NSThread currentThread]);
    // 获取最新评论
    [self getLatestComment];
    
    // 加载数据
    [self sendRequest:start];
}

// 获取最新评论
- (void)getLatestComment{
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-myfarm-op-ownercomment.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = [NSString stringWithFormat:@"%d",self.farmerUid];
    parameters[@"type"] = @"farmer";
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
//        JLLog(@"线程二：%@",[NSThread currentThread]);
        if(!NULLString(result.msg)){
            commentLabel.text = [@"最新评论：" stringByAppendingString:result.msg];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
    }];
}

- (void)sendRequest:(int)startNum{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-myfarm-op-farmdetails.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = [NSString stringWithFormat:@"%d",self.farmerUid];
//    parameters[@"source"] = @"ios";
    parameters[@"start"] = [NSString stringWithFormat:@"%d",startNum];
    parameters[@"perpage"] = perpage;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 结束刷新
        [self endRefreshing];
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        int count = [JLFarmListModel mj_objectArrayWithKeyValuesArray:responseObject].count;
        [self.farmDetailArray addObjectsFromArray:[JLFarmListModel mj_objectArrayWithKeyValuesArray:responseObject]];
        
        // 将图片路径拼接到图片名中
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for(JLFarmListModel *farmListModel in self.farmDetailArray){
            for(NSString *picPath in farmListModel.picarr){
                if(![picPath hasPrefix:@"http://"]){
                    NSString *tempPath = [IMAGE_URL stringByAppendingString:picPath];
                    [tempArray addObject:tempPath];
                }else{
                    [tempArray addObject:picPath];
                }
            }
            farmListModel.picarr = tempArray;
            [tempArray removeAllObjects];
        }
        JLLog(@"img == %@", [self.farmDetailArray[0] picarr][0]);
        
        
        JLLog(@"count=%d",self.farmDetailArray.count);
        start += count;
        
        if(count < [perpage intValue]){
            [MBProgressHUD showSuccess:@"没有更多数据啦"];
        }
        
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

#pragma mark - UITableView数据源方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.farmDetailArray.count;
}

#pragma mark - 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 创建Cell
    JLFarmDetailCell *cell = [JLFarmDetailCell farmCellWithTableView:tableView];
    // 2. 获取当前行的模型，设置cell数据
    JLFarmListModel *farmList = self.farmDetailArray[indexPath.row];
    cell.farmList = farmList;
    // 3. 返回cell
    return cell;
}

#pragma mark - 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300.0f;
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






























