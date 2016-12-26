//
//  JLAccountInfoViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

  //  账户信息

#import "JLAccountInfoViewController.h"
#import "RatingBar.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface JLAccountInfoViewController ()<RatingBarDelegate>
// 充值
- (IBAction)chongZhiBtn;
// 提现
- (IBAction)withDrawalBtn;


// 账户余额
@property (strong, nonatomic) IBOutlet UILabel *_balance;
// 我的星级
@property (strong, nonatomic) IBOutlet UIView *_starsView;
// 个人积分
@property (strong, nonatomic) IBOutlet UILabel *_integral;
// 星星
@property (nonatomic, strong) RatingBar *ratingBar;


@end

@implementation JLAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self sendRequest];
}

- (void)sendRequest{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userDefaults objectForKey:@"uid"];
    
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-personalinfo-op-balance.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = uid;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        self._balance.text = [@"￥" stringByAppendingString:responseObject[@"balance"]];
        self._integral.text = responseObject[@"integral"];
        [self initRatingBar:[responseObject[@"accountlevel"] intValue]];
//        [self initRatingBar:5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“加载失败”的提示；
        [MBProgressHUD showError:@"加载失败"];
    }];

}

- (void)initRatingBar:(int)num{
    CGFloat ratingBarW = 30 * num;
    CGFloat ratingBarX = self._starsView.frame.size.width - ratingBarW;
    self.ratingBar = [[RatingBar alloc]initWithFrame:CGRectMake(ratingBarX, 0, ratingBarW, 40)];
    [self._starsView addSubview:self.ratingBar];
    // 是否是指示器
    self.ratingBar.isIndicator = YES;
    // 设置星星的数量
    self.ratingBar.starsNum = num;
    [self.ratingBar setImageDeselected:@"iconfont-xing" halfSelected:@"iconfont-xing" fullSelected:@"iconfont-xing" andDelegate:self];
}

- (IBAction)chongZhiBtn {
}

- (IBAction)withDrawalBtn {
}

#pragma mark - RatingBar delegate
- (void)ratingBar:(RatingBar *)ratingBar ratingChanged:(float)newRating{
    
}
@end






































