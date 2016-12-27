//
//  JLRechargeViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/26.
//  Copyright © 2016年 chw. All rights reserved.
//

  // 充值界面

#import "JLRechargeViewController.h"

@interface JLRechargeViewController ()
// 清空按钮
- (IBAction)emptyBtn;
// 支付宝
- (IBAction)alipayBtn:(id)sender;
// 银联
- (IBAction)unionBtn:(id)sender;
// 微信
- (IBAction)weixinBtn:(id)sender;
// 财付通
- (IBAction)tenpayBtn:(id)sender;
// 下一步
- (IBAction)nextBtn:(id)sender;


// 充值金额
@property (strong, nonatomic) IBOutlet UITextField *_rechargeAmount;
@property (strong, nonatomic) IBOutlet UIButton *_weixin;
// 支付宝CheckBox
@property (strong, nonatomic) IBOutlet UIButton *_alipayCB;
// 银联CheckBox
@property (strong, nonatomic) IBOutlet UIButton *_unionCB;
// 微信CheckBox
@property (strong, nonatomic) IBOutlet UIButton *_weixinCB;
// 财付通CheckBox
@property (strong, nonatomic) IBOutlet UIButton *_tenpayCB;
// 下一步
@property (strong, nonatomic) IBOutlet UIButton *_next;



@end

@implementation JLRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self._next.enabled = NULLString(self._rechargeAmount.text)?NO:YES;
    // 实时监听UITextField内容的变化
    [self._rechargeAmount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)theTextField{
    NSLog(@"text changed:%@",theTextField.text);
    self._next.enabled = NULLString(theTextField.text)?NO:YES;
}

// 清空
- (IBAction)emptyBtn {
    self._rechargeAmount.text = nil;
    self._next.enabled = NULLString(self._rechargeAmount.text)?NO:YES;
}

// 支付宝
- (IBAction)alipayBtn:(id)sender {
    [self._alipayCB setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
    [self._unionCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self._weixinCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self._tenpayCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
}

// 银联
- (IBAction)unionBtn:(id)sender {
    [self._alipayCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self._unionCB setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
    [self._weixinCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self._tenpayCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
}

// 微信
- (IBAction)weixinBtn:(id)sender {
    [self._alipayCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self._unionCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self._weixinCB setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
    [self._tenpayCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
}

// 财付通
- (IBAction)tenpayBtn:(id)sender {
    [self._alipayCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self._unionCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self._weixinCB setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self._tenpayCB setBackgroundImage:[UIImage imageNamed:@"checkbox_focus"] forState:UIControlStateNormal];
}

// 下一步
- (IBAction)nextBtn:(id)sender {
//    self._rechargeAmount.text
}

@end























































