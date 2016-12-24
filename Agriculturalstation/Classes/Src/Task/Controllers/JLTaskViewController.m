//
//  JLTaskViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/13.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLTaskViewController.h"
#import "JLReleaseTaskTagCell.h"

@interface JLTaskViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
}

@end

@implementation JLTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView= [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    // 设置代理
    _tableView.delegate = self;
    // 设置数据源
    _tableView.dataSource = self;
}

#pragma mark - UITableView代理方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

// 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 创建Cell
    JLReleaseTaskTagCell *cell = [JLReleaseTaskTagCell releaseTaskTagCellWithTableView:tableView];
    // 2. 获取当前行的模型，设置cell数据
    
    // 3.返回cell
    return cell;
}

// 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160.0f;
}

#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end














































