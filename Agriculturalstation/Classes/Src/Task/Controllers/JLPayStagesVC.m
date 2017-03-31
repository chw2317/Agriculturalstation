//
//  JLPayStagesVC.m
//  Agriculturalstation
//
//  Created by chw on 17/3/30.
//  Copyright © 2017年 chw. All rights reserved.
//
    // 支付分期款

#import "JLPayStagesVC.h"
#import "JLPayStagesCell.h"
#import "JLStagesPayModel.h"
#import "ServerResult.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"

@interface JLPayStagesVC ()<UITableViewDelegate,UITableViewDataSource,ActivityCellDelegate,UIAlertViewDelegate>{
    int regtype;
    NSString *uid;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JLStagesPayModel *stagesPay;

@end

@implementation JLPayStagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    regtype = [[userDefaults objectForKey:@"regtype"] intValue];
    uid = [userDefaults objectForKey:@"uid"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _stagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JLStagesPayModel *stagesPayModel = _stagesArray[indexPath.row];
    static NSString *Id = @"JLPayStagesCell";
    JLPayStagesCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JLPayStagesCell" owner:nil options:nil] firstObject];
    }
    cell.stagesPayModel = stagesPayModel;
    [cell setTitle:stagesPayModel.stages andPrice:stagesPayModel.money andStatus:stagesPayModel.status andRegtype:regtype];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark - lazy
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - ActivityCellDelegate
- (void)payBtnEventClick:(JLStagesPayModel *)stagesPayModel{
    self.stagesPay = stagesPayModel;
    NSString *priceStr = [NSString stringWithFormat:@"需支付金额：%0.2f￥",stagesPayModel.money];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付进度款" message:priceStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"支付宝", @"微信支付", @"账户余额", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1: // 支付宝
        {
//            [self payFenQi:@"1"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"很抱歉！尚未开通此功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }

            break;
            
        case 2: // 微信支付
        {
//            [self payFenQi:@"2"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"很抱歉！尚未开通此功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
            
            break;
            
        case 3: // 账户余额
            [self payFenQi:@"3"];
            break;
    }
}

- (void)payFenQi:(NSString *)payWay{
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-task-op-stagespay.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"stagesid"] = [NSString stringWithFormat:@"%d", self.stagesPay.id];
    parameters[@"uid"] = uid;
    parameters[@"taskid"] = [NSString stringWithFormat:@"%d", self.stagesPay.taskid];
    parameters[@"paytype"] = payWay;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [MBProgressHUD hideHUD];
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
        [MBProgressHUD showSuccess:result.msg];
        if(result.code == 200){
            // 支付成功
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"操作失败"];
    }];
}
@end



















































