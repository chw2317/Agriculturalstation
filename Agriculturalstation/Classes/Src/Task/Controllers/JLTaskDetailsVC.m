//
//  JLTaskDetailsVC.m
//  Agriculturalstation
//
//  Created by chw on 17/3/25.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLTaskDetailsVC.h"
#import "SDCycleScrollView.h"
#import "DateUtil.h"
#import "JLTouBiaoPayVC.h"

@interface JLTaskDetailsVC (){
    int regtype;
}

- (IBAction)touBiaoBtnClick:(id)sender;


// 相关图片
@property (strong, nonatomic) IBOutlet SDCycleScrollView *picarr;

// 标题
@property (strong, nonatomic) IBOutlet UILabel *name;

// 内容
@property (strong, nonatomic) IBOutlet UILabel *content;

// 作业面积
@property (strong, nonatomic) IBOutlet UILabel *operatingarea;

// 项目款
@property (strong, nonatomic) IBOutlet UILabel *totalprice;

// 可接星级
@property (strong, nonatomic) IBOutlet UILabel *needstar;

// 要求工期
@property (strong, nonatomic) IBOutlet UILabel *timelimit;

// 参与人数
@property (strong, nonatomic) IBOutlet UILabel *participationnum;

// 截止日期
@property (strong, nonatomic) IBOutlet UILabel *endtime;

// 具体地址
@property (strong, nonatomic) IBOutlet UILabel *detailaddress;

// 参与投标
@property (strong, nonatomic) IBOutlet UIButton *touBiaoBtn;

@property (nonatomic, strong) JLTouBiaoPayVC *toubiaoPayVc;

@end

@implementation JLTaskDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 获取用户uid
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    regtype = [[userDefaults objectForKey:@"regtype"] intValue];
    [self setTaskData];
}

- (void)setTaskData{
    switch (_taskModel.curstatu) {
        case 1: // 竞标中
            [self.touBiaoBtn setTitle:@"参与投标" forState:UIControlStateNormal];
            break;
            
        case 2: // 作业中
            if(regtype == 1){
                [self.touBiaoBtn setTitle:@"支付进度款" forState:UIControlStateNormal];
            }else if (regtype == 2){
                [self.touBiaoBtn setTitle:@"确认支付进度款" forState:UIControlStateNormal];
            }
            break;
            
        case 3: // 已结束
            self.touBiaoBtn.hidden = YES; // 隐藏按钮
            break;
    }
    
    // 相关图片
    self.picarr.imageURLStringsGroup = _taskModel.picarr;
    // 标题
    self.name.text = _taskModel.name;
    // 内容
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithData:[_taskModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.content.attributedText = attrStr;
    // 作业面积
    self.operatingarea.text = [NSString stringWithFormat:@"作业面积：%0.2f亩",_taskModel.operatingarea];
    // 项目款
    self.totalprice.text = [NSString stringWithFormat:@"项目款：￥%0.2f",_taskModel.totalprice];
    // 可接星级
    self.needstar.text = [NSString stringWithFormat:@"%d星及以上用户可接",_taskModel.needstar];
    // 要求工期
    self.timelimit.text = [NSString stringWithFormat:@"要求工期：%d天",_taskModel.timelimit];
    // 参与人数
    self.participationnum.text = [NSString stringWithFormat:@"目前已有%d人参与投标",_taskModel.participationnum];
    // 截止日期
    self.endtime.text = [NSString stringWithFormat:@"截止日期：%@",[DateUtil timestampSwitchTime:_taskModel.endtime andFormatter:@"YYYY-MM-dd"]];
    // 具体地址
    self.detailaddress.text = [NSString stringWithFormat:@"具体地址：%@",_taskModel.detailaddress];
}

// 投标 / 支付进度款 / 确认支付进度款
- (IBAction)touBiaoBtnClick:(id)sender {
    switch (_taskModel.curstatu) {
        case 1: // 竞标中，参与投标
            if(regtype == 1){
                // 农场主不得投标
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"农场主不能进行投标!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else if (regtype == 2){
                // 前往投标支付页面
                self.toubiaoPayVc = [JLTouBiaoPayVC new];
                [self.navigationController pushViewController:_toubiaoPayVc animated:YES];
                _toubiaoPayVc.totalprice = _taskModel.totalprice;
                _toubiaoPayVc.taskid = _taskModel.id;
            }
            break;
            
        case 2: // 作业中
            if(regtype == 1){
                // 支付进度款
            }else if (regtype == 2){
                // 确认支付进度款
            }
            break;
            
        case 3: // 已结束
            self.touBiaoBtn.hidden = YES; // 隐藏按钮
            break;
    }
}
@end
































