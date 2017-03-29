//
//  JLEvaluationVC.m
//  Agriculturalstation
//
//  Created by chw on 17/3/29.
//  Copyright © 2017年 chw. All rights reserved.
//

    // 评价

#import "JLEvaluationVC.h"
#import "ServerResult.h"
#import "JLEvaluationModel.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"

@interface JLEvaluationVC (){
    int regtype;
    NSString *uid;
    int level; // 评论等级：1好评（默认）、0中评、-1差评
}
// 好评
- (IBAction)goodBtnClick:(id)sender;

// 中评
- (IBAction)mediumBtnClick:(id)sender;

// 差评
- (IBAction)poorBtnClick:(id)sender;


// 好评
@property (strong, nonatomic) IBOutlet UIButton *goodBtn;
@property (strong, nonatomic) IBOutlet UIButton *goodFontBtn;

// 中评
@property (strong, nonatomic) IBOutlet UIButton *mediumBtn;
@property (strong, nonatomic) IBOutlet UIButton *mediumFontBtn;

// 差评
@property (strong, nonatomic) IBOutlet UIButton *poorBtn;
@property (strong, nonatomic) IBOutlet UIButton *poorFontBtn;

// 我的评论内容
@property (strong, nonatomic) IBOutlet UITextView *mineContent;
// 农场主 / 农机主 的评论
@property (strong, nonatomic) IBOutlet UILabel *otherLabel;
// 等级
@property (strong, nonatomic) IBOutlet UILabel *otherLevel;
// 内容
@property (strong, nonatomic) IBOutlet UILabel *otherContent;


@end

@implementation JLEvaluationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"评价";
    // 设置“提交”按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 24);
    [rightBtn addTarget:self action:@selector(submitEvaluationClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    // 添加
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    uid = [userDefaults objectForKey:@"uid"];
    regtype = [[userDefaults objectForKey:@"regtype"] intValue];
    if(regtype == 1){
        self.otherLabel.text = @"农机主的评论";
    }else{
        self.otherLabel.text = @"农场主的评论";
    }
    level = 1;
    // 获取评价的内容
    [self getEvaluationData];
}

// 获取评价的内容
- (void)getEvaluationData{
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-task-op-getevaluation.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"regtype"] = [NSString stringWithFormat:@"%d",regtype];
    parameters[@"taskid"] = [NSString stringWithFormat:@"%d",_taskid];
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        JLEvaluationModel *evaluationModel = [JLEvaluationModel mj_objectWithKeyValues:responseObject];
        if(regtype == 1){
            [self setFarmerComment:evaluationModel];
        }else if (regtype == 2){
            [self setOwnerComment:evaluationModel];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“加载失败”的提示；
        [MBProgressHUD showError:@"加载失败"];
    }];
}

- (void)setFarmerComment:(JLEvaluationModel *)evaluationModel{
    if(!NULLString(evaluationModel.farmercomment)){
        self.mineContent.text = evaluationModel.farmercomment;
        self.mineContent.editable = NO;
        switch (evaluationModel.fc_level) {
            case 1: // 好评
                [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
                break;
                
            case 0: // 中评
                [self.mediumBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
                break;
                
            case -1: // 差评
                [self.poorBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
                break;
        }
        // 设置不可点击
        self.goodFontBtn.userInteractionEnabled = NO;
        self.mediumFontBtn.userInteractionEnabled = NO;
        self.poorFontBtn.userInteractionEnabled = NO;
    }
    // 如果农机主的评论不为空，则说明农机主已经评论了
    if(!NULLString(evaluationModel.ownercomment)){
        switch (evaluationModel.oc_level) {
            case 1: // 好评
                self.otherLevel.text = @"好评";
                break;
                
            case 0: // 中评
                self.otherLevel.text = @"中评";
                break;
                
            case -1: // 差评
                self.otherLevel.text = @"差评";
                break;
        }
        self.otherContent.text = evaluationModel.ownercomment;
    }else{
        self.otherLevel.text = @"农机主尚未评价";
    }
}

- (void)setOwnerComment:(JLEvaluationModel *)evaluationModel{
    if(!NULLString(evaluationModel.ownercomment)){
        self.mineContent.text = evaluationModel.ownercomment;
        self.mineContent.editable = NO;
        switch (evaluationModel.oc_level) {
            case 1: // 好评
                [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
                break;
                
            case 0: // 中评
                [self.mediumBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
                break;
                
            case -1: // 差评
                [self.poorBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
                break;
        }
        // 设置不可点击
        self.goodFontBtn.userInteractionEnabled = NO;
        self.mediumFontBtn.userInteractionEnabled = NO;
        self.poorFontBtn.userInteractionEnabled = NO;
    }
    // 如果农机主的评论不为空，则说明农机主已经评论了
    if(!NULLString(evaluationModel.farmercomment)){
        switch (evaluationModel.fc_level) {
            case 1: // 好评
                self.otherLevel.text = @"好评";
                break;
                
            case 0: // 中评
                self.otherLevel.text = @"中评";
                break;
                
            case -1: // 差评
                self.otherLevel.text = @"差评";
                break;
        }
        self.otherContent.text = evaluationModel.farmercomment;
    }else{
        self.otherLevel.text = @"农场主尚未评价";
    }
}

// 好评
- (IBAction)goodBtnClick:(id)sender {
    level = 1;
    [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
    [self.mediumBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self.poorBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
}

// 中评
- (IBAction)mediumBtnClick:(id)sender {
    level = 0;
    [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self.mediumBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
    [self.poorBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
}

// 差评
- (IBAction)poorBtnClick:(id)sender {
    level = -1;
    [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self.mediumBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self.poorBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
}

// 提交评论内容
- (void)submitEvaluationClick{
    if(NULLString(self.mineContent.text)){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先填写评论内容" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        // 显示MBProgressHUD
        [MBProgressHUD showMessage:nil];
        // 请求地址
        NSString *url = [REQUEST_URL stringByAppendingString:@"app-task-op-accept.html"];
        // 请求管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        // 拼接请求参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"uid"] = uid;
        parameters[@"regtype"] = [NSString stringWithFormat:@"%d",regtype];
        parameters[@"taskid"] = [NSString stringWithFormat:@"%d",_taskid];
        parameters[@"rating"] = [NSString stringWithFormat:@"%d",level];
        parameters[@"comment"] = self.mineContent.text;
        // 发起请求
        [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            // 隐藏MBProgressHUD
            [MBProgressHUD hideHUD];
            ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
            [MBProgressHUD showSuccess:result.msg];
            // 延迟执行
            [self performSelector:@selector(closeCurrentPage) withObject:nil afterDelay:0.5];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            // 隐藏MBProgressHUD
            [MBProgressHUD hideHUD];
            //同时弹出“加载失败”的提示；
            [MBProgressHUD showError:@"操作失败"];
        }];
    }
}

- (void)closeCurrentPage{
    // 通过代理来实现，返回上一页面并刷新数据
//    [_delegate refreshData];
    // 选标成功，返回上一页面
    [self.navigationController popViewControllerAnimated:YES];
}
@end









































