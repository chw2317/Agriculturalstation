//
//  JLFenQiPriceVC.m
//  Agriculturalstation
//
//  Created by chw on 17/3/30.
//  Copyright © 2017年 chw. All rights reserved.
//

    // 设置分期金额

#import "JLFenQiPriceVC.h"
#import "JLFenQiPriceCell.h"
#import "UITextField+IndexPath.h"
#import "ServerResult.h"

#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"

@interface JLFenQiPriceVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayDataSource;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation JLFenQiPriceVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.footerView;
    [self.footerView addSubview:self.completeBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.view addSubview:self.leftLabel];
    [self.view addSubview:self.rightLabel];
}

- (void)textFieldDidChanged:(NSNotification *)noti{
    UITextField *textField = noti.object;
    NSIndexPath *indexPath = textField.indexPath;
    [self.arrayDataSource replaceObjectAtIndex:indexPath.row withObject:textField.text];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_fenQiNum integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Id = @"JLFenQiPriceCell";
    JLFenQiPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JLFenQiPriceCell" owner:nil options:nil] firstObject];
    }
    [cell setTitleString:[NSString stringWithFormat:@"%ld",(indexPath.row + 1)] andDataString:self.arrayDataSource[indexPath.row] andIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

- (void)completeBtnClick{
    [self.arrayDataSource enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        NSString *string = (NSString *)obj;
        if(string.length == 0){
            JLLog(@"第%lu个位置元素为空", (unsigned long)idx);
        }else{
            JLLog(@"%@", obj);
        }
    }];
    
    JLLog(@"CHW == %@", [_arrayDataSource mj_JSONString]);
//    [self stagesSubmit];
}

- (void)stagesSubmit{
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-task-op-stages.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"taskid"] = [NSString stringWithFormat:@"%d", _taskid];
    parameters[@"stages"] = [_arrayDataSource mj_JSONString];
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [MBProgressHUD hideHUD];
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
        [MBProgressHUD showSuccess:result.msg];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"保存失败"];
    }];
}

#pragma mark - lazy
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_HEIGHT - NAV_HEIGHT - 46) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UILabel *)leftLabel{
    if(!_leftLabel){
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH * 0.5 - 8, 30)];
        _leftLabel.text = @"期数";
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _leftLabel.textColor = [UIColor blackColor];
        _leftLabel.backgroundColor = [UIColor grayColor];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if(!_rightLabel){
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 + 8, 8, SCREEN_WIDTH * 0.5 - 16, 30)];
        _rightLabel.text = @"进度金额";
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.backgroundColor = [UIColor grayColor];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}

- (UIView *)footerView{
    if(!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    }
    return _footerView;
}

- (NSMutableArray *)arrayDataSource{
    if(!_arrayDataSource){
        _arrayDataSource = [NSMutableArray array];
        for(int i = 0; i < [_fenQiNum intValue]; i++){
            [_arrayDataSource addObject:@""];
        }
    }
    return _arrayDataSource;
}

- (UIButton *)completeBtn{
    if(!_completeBtn){
        _completeBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width * 0.5 - 100), 0, 200, 40)];
        [_completeBtn setTitle:@"保存" forState:UIControlStateNormal];
        _completeBtn.backgroundColor = [UIColor cyanColor];
        [_completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}
@end


















































