//
//  JLIdentityViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

// 身份认证

#import "JLIdentityViewController.h"

@interface JLIdentityViewController ()
// 身份证正面照
- (IBAction)certificatePositive:(id)sender;
// 身份证反面照
- (IBAction)certificateReverse:(id)sender;
// 提交
- (IBAction)commitBtn;


// 真实姓名
@property (strong, nonatomic) IBOutlet UITextField *_realName;
// 证件号码
@property (strong, nonatomic) IBOutlet UITextField *_certificateID;


@end

@implementation JLIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// 身份证正面照
- (IBAction)certificatePositive:(id)sender {
}

// 身份证反面照
-(IBAction)certificateReverse:(id)sender{
}

// 提交
- (IBAction)commitBtn {
    if(NULLString(self._realName.text) || NULLString(self._certificateID.text)){
        // 创建弹出窗
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请填写完整信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        // 显示
        [alert show];
    }else{
        
    }
}
@end











































