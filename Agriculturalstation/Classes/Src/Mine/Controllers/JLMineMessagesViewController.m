//
//  JLMineMessagesViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

  // 我的消息

#import "JLMineMessagesViewController.h"
#import "JLMineMessageModel.h"
#import "JLMineMsgCell.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface JLMineMessagesViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSString *userUid;
    NSMutableArray *_selectedArray; // 选中的数组
    UIButton *rightBtn;
}

//@property(strong,nonatomic)NSArray *mineMsgModelArray;
@property(strong ,nonatomic)NSMutableArray *mineMsgModelArray;

@end

@implementation JLMineMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 获取用户uid
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userUid = [userDefaults objectForKey:@"uid"];
    
    
    // 设置“编辑”按钮
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
    [rightBtn addTarget:self action:@selector(rightEditorEvent) forControlEvents:UIControlEventTouchUpInside];
    // 普通状态
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 高亮状态
    [rightBtn setTitle:@"编辑" forState:UIControlStateHighlighted];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    // 选中状态
    [rightBtn setTitle:@"删除" forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    // 添加
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
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
    // 初始化选中数组
    _selectedArray = [NSMutableArray array];
}


- (void)sendRequest{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-mynews-op-list.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = userUid;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        self.mineMsgModelArray = [JLMineMessageModel mj_objectArrayWithKeyValuesArray:responseObject];
        // 刷新UITableView
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“加载失败”的提示；
        [MBProgressHUD showError:@"加载失败"];
    }];
}

// “编辑”按钮事件
- (void)rightEditorEvent{
    NSLog(@"编辑...");
    BOOL flag = _tableView.editing;
    if(flag){
        // 删除的操作
        // 得到删除的item索引
        NSMutableArray *indexArray = [NSMutableArray array];
        for(JLMineMessageModel *mineMsgModel in _selectedArray){
            NSInteger num = [_mineMsgModelArray indexOfObject:mineMsgModel];
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:num inSection:0];
            [indexArray addObject:path];
        }
        // 修改数据模型
        [_mineMsgModelArray removeObjectsInArray:_selectedArray];
        [_selectedArray removeAllObjects];
        
        // 刷新
        [_tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        // tableView的编辑状态
        _tableView.editing = NO;
        // 编辑按钮的选中状态
        rightBtn.selected = NO;
        
    }else{
        // 开始选择行
        [_selectedArray removeAllObjects];
        // tableView的编辑状态
        _tableView.editing = YES;
        // 编辑按钮的选中状态
        rightBtn.selected = YES;
    }
}

#pragma mark - UITableView数据源方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mineMsgModelArray.count;
}

#pragma mark - 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.创建Cell
    JLMineMsgCell *cell = [JLMineMsgCell mineMsgCellWithTableView:tableView];
    // 2.获取当前行的模型，设置cell数据
    JLMineMessageModel *mineMsgModel = self.mineMsgModelArray[indexPath.row];
    cell.mineMsgModel = mineMsgModel;
    // 3.返回cell
    return cell;
}

#pragma mark - 返回编辑模式，默认为删除模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - 选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_tableView.editing){
        return;
    }
    JLMineMessageModel *mineMsgModel = [_mineMsgModelArray objectAtIndex:indexPath.row];
    if(![_selectedArray containsObject:mineMsgModel]){
        [_selectedArray addObject:mineMsgModel];
    }
}

#pragma mnark - 取消选中行
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_tableView.editing){
        return;
    }
    JLMineMessageModel *mineMsgModel = [_mineMsgModelArray objectAtIndex:indexPath.row];
    if([_selectedArray containsObject:mineMsgModel]){
        [_selectedArray removeObject:mineMsgModel];
    }
}

#pragma mark - 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
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






















































