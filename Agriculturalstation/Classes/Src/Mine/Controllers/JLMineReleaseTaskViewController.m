//
//  JLMineReleaseTaskViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

    // 发布的任务 / 参与的任务

#import "JLMineReleaseTaskViewController.h"
#import "JLMineReleaseTaskCell.h"
#import "JLReleaseTaskModel.h"
#import "JLSelectTenderVC.h"
#import "JLTaskDetailsVC.h"
#import "JLReleaseTaskVC.h"
#import "ServerResult.h"
#import "JLEvaluationVC.h"

#import "MJRefresh.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface JLMineReleaseTaskViewController ()<UITableViewDelegate,UITableViewDataSource,ActivityCellDelegate,JLSelectTenderVcDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSString *userUid;
    int start;
    NSString *perpage;
    int regtype; // 注册类型：1农场主、2农机主
}

@property (strong, nonatomic) NSMutableArray *mineReleaseTaskModelArray;
@property (nonatomic, strong) JLSelectTenderVC *selectTenderVc; // 选标
@property (nonatomic, strong) JLTaskDetailsVC *taskDetailsVc; // 任务详情
@property (nonatomic, strong) JLEvaluationVC *evaluationVc; // 评论
@property (nonatomic, strong) JLReleaseTaskModel *taskModel;

@end

@implementation JLMineReleaseTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    start = 0;
    perpage = @"10";
    self.mineReleaseTaskModelArray = [[NSMutableArray alloc] init];
    // 获取用户uid
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userUid = [userDefaults objectForKey:@"uid"];
    regtype = [[userDefaults objectForKey:@"regtype"] intValue];
    
    if(regtype == 1){ // 农场主 ---> 可发布任务
        // 设置“添加”按钮
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 25, 25);
        [rightBtn addTarget:self action:@selector(rightAddTaskEvent) forControlEvents:UIControlEventTouchUpInside];
        // 普通状态
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"add_farm_right.png"] forState:UIControlStateNormal];
        //    [rightBtn setImage:[UIImage imageNamed:@"add_farm_right.png"] forState:UIControlStateNormal];
        // 添加
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    
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
        [self.mineReleaseTaskModelArray removeAllObjects];
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

- (void)rightAddTaskEvent{
    [self.navigationController pushViewController:[JLReleaseTaskVC new] animated:YES];
}

- (void)sendRequest:(int)startNum{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = @"";
    if(regtype == 1){
        url = [REQUEST_URL stringByAppendingString:@"app-task-op-mytask.html"];
    }else {
        url = [REQUEST_URL stringByAppendingString:@"app-task-op-jointask.html"];
        start = 1;
    }
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
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        
        int count = [JLReleaseTaskModel mj_objectArrayWithKeyValuesArray:responseObject].count;
        [self.mineReleaseTaskModelArray addObjectsFromArray:[JLReleaseTaskModel mj_objectArrayWithKeyValuesArray:responseObject]];
        start += count;
        
        // 将图片路径拼接到图片名中
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for(JLReleaseTaskModel *taskModel in self.mineReleaseTaskModelArray){
            for(NSString *picPath in taskModel.picarr){
                if(![picPath hasPrefix:@"http://"]){
                    NSString *tempPath = [IMAGE_URL stringByAppendingString:picPath];
                    [tempArray addObject:tempPath];
                }else{
                    [tempArray addObject:picPath];
                }
            }
            taskModel.picarr = tempArray;
            [tempArray removeAllObjects];
        }
        
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

#pragma mark - UITableView代理方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mineReleaseTaskModelArray.count;
}

#pragma mark - 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 创建Cell
    JLMineReleaseTaskCell *cell = [JLMineReleaseTaskCell releaseTaskCellWithTableView:tableView];
    // 2. 获取当前行的模型，设置cell数据
    JLReleaseTaskModel *releaseTaskModel = self.mineReleaseTaskModelArray[indexPath.row];
    cell.releaseTaskModel = releaseTaskModel;
    cell.delegate = self;
    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.taskDetailsVc = [JLTaskDetailsVC new];
    [self.navigationController pushViewController:_taskDetailsVc animated:YES];
    _taskDetailsVc.taskModel = self.mineReleaseTaskModelArray[indexPath.row];
}

#pragma mark - 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170.0f;
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

#pragma mark - ActivityCellDelegate
- (void)selectTenderClick:(JLReleaseTaskModel *)taskModel{
    switch (taskModel.curstatu) {
        case 1: // 竞标中
            // 选标
            if(regtype == 1){
                JLLog(@"CHW -----> 选标");
                self.selectTenderVc = [JLSelectTenderVC new];
                // 跳转到选标界面
                [self.navigationController pushViewController:_selectTenderVc animated:YES];
                _selectTenderVc.taskid = taskModel.id;
                // 指定代理
                _selectTenderVc.delegate = self;
            }
            break;
            
        case 2: // 作业中
            // 完成项目
            if(regtype == 2){
                self.taskModel = taskModel;
                JLLog(@"CHW -----> 完成项目");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本操作不可恢复，确认操作？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 2;
                [alert show];
            }
            break;
            
        case 3: // 已结束
            NULLString(taskModel.comment) ? JLLog(@"CHW -----> 待评价") : JLLog(@"CHW -----> 已评价");
            _evaluationVc = [JLEvaluationVC new];
            [self.navigationController pushViewController:_evaluationVc animated:YES];
            _evaluationVc.taskid = taskModel.id;
            break;
            
        case 4: // 待接单
            if(regtype == 2){
                JLLog(@"CHW -----> 接下项目");
                [self acceptTask:taskModel];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - JLSelectTenderVcDelegate
- (void)refreshData{
    // 通过代理来实现，返回上一页面并刷新数据
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 2){ // 完成项目
        if(buttonIndex == 1){ // 确定
            [self finishProject:self.taskModel];
        }
    }
}

// 完成项目
- (void)finishProject:(JLReleaseTaskModel *)taskModel{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-task-op-finish.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"taskid"] = [NSString stringWithFormat:@"%d",taskModel.id];
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
        [MBProgressHUD showSuccess:result.msg];
//        taskModel.curstatu = 3;
        // 重新请求数据
        [_tableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“加载失败”的提示；
        [MBProgressHUD showError:@"操作失败"];
    }];
}

// 接下项目
- (void)acceptTask:(JLReleaseTaskModel *)taskModel{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-task-op-accept.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"taskid"] = [NSString stringWithFormat:@"%d",taskModel.id];
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
        [MBProgressHUD showSuccess:result.msg];
        //        taskModel.curstatu = 2;
        // 重新请求数据
        [_tableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“加载失败”的提示；
        [MBProgressHUD showError:@"操作失败"];
    }];
}
@end








































