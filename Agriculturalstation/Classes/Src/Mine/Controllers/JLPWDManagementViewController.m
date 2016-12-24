//
//  JLPWDManagementViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

// 密码管理

#import "JLPWDManagementViewController.h"

@interface JLPWDManagementViewController ()
// 确认修改
- (IBAction)confirmModify;


// 原始密码
@property (strong, nonatomic) IBOutlet UITextField *_oldPassWord;
// 新密码
@property (strong, nonatomic) IBOutlet UITextField *_passWord;
// 确认新密码
@property (strong, nonatomic) IBOutlet UITextField *_confirmPassWord;

@end

@implementation JLPWDManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// 确认修改
- (IBAction)confirmModify {
    if(NULLString(self._oldPassWord.text) || NULLString(self._passWord.text) || NULLString(self._confirmPassWord.text)){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请填写完整信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
    }
}
@end












































