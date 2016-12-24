//
//  JLRegisterViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/13.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLRegisterViewController.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width) // 屏幕宽度
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height) // 屏幕高度

@interface JLRegisterViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    // 记录滚轮是否滑动
    NSString *_guildStr;
    NSString *_selectStr;
    // 记录用户点击的是注册类型还是用户类型
    NSString *_type;
    NSArray *_regTypeArray; // 注册类型  农场主，农机手
    NSArray *_userTypeArray; // 用户类型
    UIButton *_bgButton;
}
// 注册类型
- (IBAction)selectedRegisterType;
// 用户类型
- (IBAction)selectedUserType;
// 获取验证码
- (IBAction)getPhoneCode;
// 接受服务协议
- (IBAction)checkBoxClick:(UIButton *)sender;
// 注册
- (IBAction)registerBtn;
// 去登录
- (IBAction)goToLogin;


// 用户名
@property (strong, nonatomic) IBOutlet UITextField *_userName;
// 密码
@property (strong, nonatomic) IBOutlet UITextField *_passWord;
// 确认密码
@property (strong, nonatomic) IBOutlet UITextField *_confirmPWD;
// 手机号码
@property (strong, nonatomic) IBOutlet UITextField *_phoneNumber;
// 手机验证码
@property (strong, nonatomic) IBOutlet UITextField *_phoneCode;
// checkBox按钮
@property (strong, nonatomic) IBOutlet UIButton *_checkBoxBtn;
// 注册类型
@property (strong, nonatomic) IBOutlet UIButton *_regTypeBen;
// 用户类型
@property (strong, nonatomic) IBOutlet UIButton *_userTypeBtn;
// 注册按钮
@property (strong, nonatomic) IBOutlet UIButton *_registerBtn;
// 获取验证码
@property (strong, nonatomic) IBOutlet UIButton *_phoneCodeBtn;



@end

@implementation JLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注 册";
    _regTypeArray = [NSArray arrayWithObjects:@"农场主",@"农机主", nil];
    _userTypeArray = [NSArray arrayWithObjects:@"个人",@"公司",@"企业", nil];
    // 设置self.title的字体大小以及颜色
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
}


// 选择注册类型
- (IBAction)selectedRegisterType {
    _type = @"regType";
    [self showPickerView:_type];
}

// 选择用户类型
- (IBAction)selectedUserType {
    _type = @"userType";
    [self showPickerView:_type];
}

// 获取手机验证码
- (IBAction)getPhoneCode {
    __block int timeOut = 120; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行
    
    dispatch_source_set_event_handler(_timer,^{
        if(timeOut <= 0){ // 倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示，根据自己需求设置（倒计时结束后调用）
                [self._phoneCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                [self._phoneCodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                // 设置可以点击
                self._phoneCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            // 这个是用来测试多于60秒时计算分钟的
//            int minutes = timeOut / 60;
//            int seconds = timeOut % 60;
//            NSString *strTime = [NSString stringWithFormat:@"重新获取(%d分%d秒)",minutes, seconds];
            NSString *strTime = [NSString stringWithFormat:@"重新获取(%ds)",timeOut];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示，根据自己需求设置
//                NSLog(@"_________%@",strTime);
                [self._phoneCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [self._phoneCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                // 设置不可点击
                self._phoneCodeBtn.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

// 注册
- (IBAction)registerBtn {
    
    if(NULLString(self._userName.text) || NULLString(self._passWord.text) || NULLString(self._confirmPWD.text) || NULLString(self._phoneNumber.text) || NULLString(self._phoneCode.text)){
        // 创建弹出窗口
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请填写完整信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        // 显示窗口
        [alert show];
    }else{
        // 提交注册信息到服务器
    }
}

// 去登录
- (IBAction)goToLogin {
    // 返回上一页面
    [self.navigationController popViewControllerAnimated:YES];
}

// 接受服务协议
- (IBAction)checkBoxClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self._registerBtn.enabled = sender.selected;
}

// 弹框
- (void)showPickerView:(NSString *)type{
    _guildStr = @"0";
    _bgButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    _bgButton.backgroundColor = [UIColor orangeColor];
    _bgButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [_bgButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgButton];
    
    UIView *cycanView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 240, SCREEN_WIDTH, 40)];
    cycanView.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:cycanView];
    [_bgButton addSubview:cycanView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cycanView.frame.size.height)];
    if([type isEqualToString:@"regType"]){
        titleLabel.text = @"选择注册类型";
    }else if([type isEqualToString:@"userType"]){
        titleLabel.text = @"选择用户类型";
    }
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cycanView addSubview:titleLabel];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, cycanView.frame.size.height)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cycanView addSubview:cancelButton];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 48, 0, 48, cycanView.frame.size.height)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cycanView addSubview:confirmButton];
    
    // UIPickerView
    UIPickerView *selectPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 140)];
    // 显示选中框
    selectPickerView.showsSelectionIndicator = NO;
    selectPickerView.backgroundColor = [UIColor whiteColor];
    // 设置委托
    selectPickerView.delegate = self;
    selectPickerView.dataSource = self;
    // 设置宽度自适应
    selectPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:selectPickerView];
    [_bgButton addSubview:selectPickerView];
}

// 隐藏弹出框
- (void)cancelButtonAction:(UIButton *)sender{
//    [self.view removeFromSuperview];
    [_bgButton removeFromSuperview];
}

// 弹框确定按钮
- (void)confirmButtonAction:(UIButton *)sender{
    if([_guildStr isEqualToString:@"0"]){
        if([_type isEqualToString:@"regType"]){
            _selectStr = [NSString stringWithFormat:@"%@",_regTypeArray[0]];
        }else{
            _selectStr = [NSString stringWithFormat:@"%@",_userTypeArray[0]];
        }
        
    }
    if([_type isEqualToString:@"regType"]){
        [self._regTypeBen setTitle:_selectStr forState:UIControlStateNormal];
    }else{
        [self._userTypeBtn setTitle:_selectStr forState:UIControlStateNormal];
    }
    NSLog(@"选择了---->%@",_selectStr);
//    [self.view removeFromSuperview];
    [_bgButton removeFromSuperview];
}

#pragma mark - UIPickerView代理方法
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([_type isEqualToString:@"regType"]){
        return _regTypeArray.count;
    }
    return _userTypeArray.count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_WIDTH - 85 * 2;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _guildStr = @"1";
    if([_type isEqualToString:@"regType"]){
        _selectStr = [NSString stringWithFormat:@"%@",[_regTypeArray objectAtIndex:row]];
    }else{
        _selectStr = [NSString stringWithFormat:@"%@",[_userTypeArray objectAtIndex:row]];
    }
    NSLog(@"selectStr:%@",_selectStr);
}

// 返回当前行的内容，此处是将数组中的数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([_type isEqualToString:@"regType"]){
        return [_regTypeArray objectAtIndex:row];
    }
    return [_userTypeArray objectAtIndex:row];
}

// 重写方法，自定义样式，该变系统样式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel *)view;
    if(!pickerLabel){
        pickerLabel = [[UILabel alloc]init];
        pickerLabel.font = [UIFont systemFontOfSize:17];
        pickerLabel.textColor = [UIColor blackColor];
        pickerLabel.textAlignment = 1;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    // 在该代理方法里添加以下两行代码删除掉上下的黑线
    [[pickerView.subviews objectAtIndex:1] setHidden:YES];
    [[pickerView.subviews objectAtIndex:2] setHidden:YES];
    
    UIView *lineLabel1 = [[UIView alloc]initWithFrame:CGRectMake(85, 55, SCREEN_WIDTH - 85 * 2, 1.5)];
    lineLabel1.backgroundColor = [UIColor orangeColor];
    [pickerView addSubview:lineLabel1];
    
    UIView *lineLabel2 = [[UIView alloc]initWithFrame:CGRectMake(85, 82, SCREEN_WIDTH - 85 * 2, 1.5)];
    lineLabel2.backgroundColor = [UIColor orangeColor];
    [pickerView addSubview:lineLabel2];
    
    return pickerLabel;
}
@end









































