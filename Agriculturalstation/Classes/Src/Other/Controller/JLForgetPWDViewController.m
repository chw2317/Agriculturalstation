//
//  JLForgetPWDViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/14.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLForgetPWDViewController.h"

@interface JLForgetPWDViewController ()
// 获取验证码
- (IBAction)getPhoneCode:(UIButton *)sender;
// 确认修改
- (IBAction)confirmModify;


// 手机号码
@property (strong, nonatomic) IBOutlet UITextField *_phoneNumber;
// 验证码
@property (strong, nonatomic) IBOutlet UITextField *_phoneCode;
// 新密码
@property (strong, nonatomic) IBOutlet UITextField *_passWord;
// 确认新密码
@property (strong, nonatomic) IBOutlet UITextField *_confirmNewPWD;
// 获取验证码
@property (strong, nonatomic) IBOutlet UIButton *_PhoneCodeBtn;



@end

@implementation JLForgetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"忘记密码";
    // 设置self.title的字体大小以及颜色
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
}

// 获取验证码
- (IBAction)getPhoneCode:(UIButton *)sender {
    __block int timeOut = 120; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut <= 0){ // 倒计时结束，关闭
            dispatch_source_cancel(_timer);
            // 设置界面的按钮显示，根据自己需求设置（倒计时结束后调用）
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                // 设置可以点击
                sender.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"重新获取(%ds)",timeOut];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示
                [sender setTitle:strTime forState:UIControlStateNormal];
                [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                // 设置不可点击
                sender.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

// 确认修改
- (IBAction)confirmModify {
    if(NULLString(self._phoneNumber.text) || NULLString(self._phoneCode.text) || NULLString(self._passWord.text) || NULLString(self._confirmNewPWD.text)){
        // 创建弹出窗口
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请填写完整信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        // 显示窗口
        [alert show];
    }else{
        
    }
}
@end



































































