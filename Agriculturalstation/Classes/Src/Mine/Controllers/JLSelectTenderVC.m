//
//  JLSelectTenderVC.m
//  Agriculturalstation
//
//  Created by chw on 17/3/23.
//  Copyright © 2017年 chw. All rights reserved.
//

    // 选标界面

#import "JLSelectTenderVC.h"
#import "JLSelectTenderLayout.h"
#import "JLSelectTenderCell.h"
#import "ServerResult.h"
#import "JLUserBaseInfoViewController.h"

#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

static NSString *ID = @"collectionViewCell";

@interface JLSelectTenderVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SelectTenderDelegate,UserInfoDelegate,UIAlertViewDelegate>{
    int start;
    NSString *perpage;
}

@property (nonatomic, strong) NSMutableArray *userModelArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) int userid;
@property (nonatomic, strong) JLUserBaseInfoViewController *userInfoVc;

@end

@implementation JLSelectTenderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    start = 0;
    perpage = @"10";
    self.userModelArray = [[NSMutableArray alloc] init];
    self.title = @"选标";
    
    // 添加collectionView
    [self.view addSubview:self.collectionView];
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 清空数组
        [self.userModelArray removeAllObjects];
        start = 0;
        [self getTenderList:start];
    }];
    
    // 设置自动切换透明度（在导航栏下面自动隐藏）
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getTenderList:start];
    }];
    
    // 加载数据
    [self getTenderList:start];
}

// 懒加载collectionView
- (UICollectionView *)collectionView{
    if(!_collectionView){
        CGRect collectionViewFrame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT - STATUS_HEIGHT - NAV_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:[[JLSelectTenderLayout alloc] init]];
        _collectionView.backgroundColor = [UIColor colorWithRed:238 green:238 blue:238 alpha:1.0];
        
        // 注册cell
        [_collectionView registerClass:[JLSelectTenderCell class] forCellWithReuseIdentifier:ID];
        
        // 注册UICollectionReusableView即headerView（切记要添加headerView一定要先注册）
//        [_collectionView registerNib:nil forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (void)getTenderList:(int)startNum{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-joinowner-op-list.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"taskid"] = [NSString stringWithFormat:@"%d", _taskid];
    parameters[@"start"] = [NSString stringWithFormat:@"%d",startNum];
    parameters[@"perpage"] = perpage;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 结束刷新
        [self endRefreshing];
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        int count = [JLUserModel mj_objectArrayWithKeyValuesArray:responseObject].count;
        [self.userModelArray addObjectsFromArray:[JLUserModel mj_objectArrayWithKeyValuesArray:responseObject]];
        
        start += count;
        
        if(count < [perpage intValue]){
            [MBProgressHUD showSuccess:@"没有更多数据啦"];
        }
        
        // 刷新collectionView
        [self.collectionView reloadData];
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
    if([self.collectionView.mj_header isRefreshing]){
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];
    }
    if([self.collectionView.mj_footer isRefreshing]){
        // 结束刷新
        [self.collectionView.mj_footer endRefreshing];
    }
}

#pragma mark - UICollectionView DataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.userModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    JLSelectTenderCell *cell = [JLSelectTenderCell userCellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.userModel = self.userModelArray[indexPath.row];
    cell.tenderDelegate = self;
    cell.infoDelegate = self;
//    JLSelectTenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark ---UICollectionViewDelegateFlowLayout

//设置collectionView的cell上、左、下、右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 10, 5);
}

#pragma mark - SelectTenderDelegate
- (void)selectTender:(int)userid{
    self.userid = userid;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定选择该用户吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - UserInfoDelegate
- (void)userInfoClick:(JLUserModel *)userModel{
    self.userInfoVc = [JLUserBaseInfoViewController new];
    // 跳转到用户信息界面
    [self.navigationController pushViewController:_userInfoVc animated:YES];
    _userInfoVc.userModel = userModel;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    JLLog(@"index == %d",buttonIndex);
    if(buttonIndex == 1){ // 确定
        [self selectionUser];
    }
}

- (void)selectionUser{
    JLLog(@"uid == %d, taskid == %d", self.userid, _taskid);
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-joinowner-op-selection.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = [NSString stringWithFormat:@"%d", self.userid];
    parameters[@"taskid"] = [NSString stringWithFormat:@"%d", _taskid];
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 结束刷新
        [self endRefreshing];
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
        
        if(result.code == 200){
            [MBProgressHUD showSuccess:result.msg];
            [self performSelector:@selector(closeCurrentPage) withObject:nil afterDelay:0.5];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 结束刷新
        [self endRefreshing];
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        // 弹出“选标失败”的提示；
        [MBProgressHUD showError:@"选标失败"];
    }];
}

- (void)closeCurrentPage{
    // 通过代理来实现，返回上一页面并刷新数据
    [_delegate refreshData];
    // 选标成功，返回上一页面
    [self.navigationController popViewControllerAnimated:YES];
}
@end



































