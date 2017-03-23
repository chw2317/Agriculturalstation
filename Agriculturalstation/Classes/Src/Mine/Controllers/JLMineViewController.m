//
//  JLMineViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/13.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLMineViewController.h"
#import "JLMineItem.h"
#import "JLLoginViewController.h"
#import "JLMineItemViewModel.h"
#import "JLPersonalInfoViewController.h"
#import "JLMineReleaseTaskViewController.h"
#import "JLAccountInfoViewController.h"
#import "JLIdentityViewController.h"
#import "JLUserBaseInfoViewController.h"
#import "JLBalancePayViewController.h"
#import "JLPWDManagementViewController.h"
#import "JLMineMessagesViewController.h"
#import "JLRewardsSystemViewController.h"
#import "UIImageView+WebCache.h"

@interface JLMineViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    BOOL _isLogin; // 记录用户是否登陆了 true 登录了 false 未登录
    NSArray *_viewModelIndex; // 存放要跳转的Controller
    UIImageView *avatarImg; // 头像
    UILabel *userNameLabel; // 用户名
    UILabel *phoneNumberLabel; // 手机号码
    UIButton *avatarBtn; // 头像
    UIButton *goLoginBtn; // 去登录
    NSUserDefaults *userDefaults;
    
}
@property (nonatomic, strong)NSArray *mineArray;
@end

@implementation JLMineViewController

// 懒加载（重写get方法）
-(NSArray *)mineArray{
    if(!_mineArray){
        // 从mainBundle加载
        NSString *path = [[NSBundle mainBundle]pathForResource:@"MineItem" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        // 将数组转换成模型
        // 1.遍历数组，将数组中的字典一次转换成MineItem对象，添加到一个临时数组
        NSMutableArray *tempArray = [NSMutableArray array];
        for(NSDictionary *dic in array){
            // 用字典来实例化对象的工厂方法
            [tempArray addObject:[JLMineItem statusWithDictionary:dic]];
        }
        _mineArray = tempArray;
    }
    return _mineArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取userDefaults
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userNameStr = [userDefaults objectForKey:@"username"];
    NSString *phoneStr = @"";
    NSString *avatarStr = @"";
    if(NULLString(userNameStr)){
        _isLogin = false;
    }else{
        _isLogin = true;
        phoneStr = [userDefaults objectForKey:@"phone"];
        avatarStr = [userDefaults objectForKey:@"avatar"];
    }
    
    // 拿出xib视图
    NSArray *mineInfoXib = [[NSBundle mainBundle]loadNibNamed:@"JLMineInfo" owner:nil options:nil];
    UIView *mineInfoView = [mineInfoXib firstObject];
    
    // 头像
    avatarImg = (UIImageView *)[mineInfoView viewWithTag:1];
    
    // 用户名
    userNameLabel = (UILabel *)[mineInfoView viewWithTag:2];
    
    // 手机号码
    phoneNumberLabel = (UILabel *)[mineInfoView viewWithTag:3];
    
    // 头像
    avatarBtn = (UIButton *)[mineInfoView viewWithTag:4];
    [avatarBtn addTarget:self action:@selector(personalInfo) forControlEvents:UIControlEventTouchUpInside];
    
    // 去登陆 / 注册
    goLoginBtn = (UIButton *)[mineInfoView viewWithTag:5];
    
    
    CGRect tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT - STATUS_HEIGHT - NAV_HEIGHT);
    // 创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = mineInfoView;
    
    [self.view addSubview:_tableView];
    // 设置数据源，注意：必须实现对应的UITableViewDataSource协议
    _tableView.dataSource = self;
    // 设置代理
    _tableView.delegate = self;
    
    // 初始化要跳转的Controller
    [self initViewController];
}

-(void)initViewController{
    JLMineItemViewModel *viewModel1 = [JLMineItemViewModel initTitle:@"个人信息" controllerClass:[JLPersonalInfoViewController class]];
    JLMineItemViewModel *viewModel2 = [JLMineItemViewModel initTitle:@"发布的任务" controllerClass:[JLMineReleaseTaskViewController class]];
    JLMineItemViewModel *viewModel3 = [JLMineItemViewModel initTitle:@"账户信息" controllerClass:[JLAccountInfoViewController class]];
    JLMineItemViewModel *viewModel4 = [JLMineItemViewModel initTitle:@"身份认证" controllerClass:[JLIdentityViewController class]];
    JLMineItemViewModel *viewModel5 = [JLMineItemViewModel initTitle:@"收支明细" controllerClass:[JLBalancePayViewController class]];
    JLMineItemViewModel *viewModel6 = [JLMineItemViewModel initTitle:@"密码管理" controllerClass:[JLPWDManagementViewController class]];
    JLMineItemViewModel *viewModel7 = [JLMineItemViewModel initTitle:@"我的消息" controllerClass:[JLMineMessagesViewController class]];
    JLMineItemViewModel *viewModel8 = [JLMineItemViewModel initTitle:@"奖罚制度" controllerClass:[JLRewardsSystemViewController class]];
    _viewModelIndex = @[viewModel1,viewModel2,viewModel3,viewModel4,viewModel5,viewModel6,viewModel7,viewModel8];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"我被执行了，我是viewWillAppear...");
    NSString *userNameStr = [userDefaults objectForKey:@"username"];
    NSString *phoneStr = @"";
    NSString *avatarStr = @"";
    if(NULLString(userNameStr)){
        _isLogin = false;
    }else{
        _isLogin = true;
        phoneStr = [userDefaults objectForKey:@"phone"];
        avatarStr = [userDefaults objectForKey:@"avatar"];
    }
    // 头像，给一张默认图片，先使用默认图片，当图片加载完成后再替换
    [avatarImg sd_setImageWithURL:[NSURL URLWithString:[REQUEST_URL stringByAppendingString:avatarStr]] placeholderImage:[UIImage imageNamed:@"user_avatar.png"]];
//    avatarImg.image = [UIImage imageNamed:@"user_avatar.png"];
    // 用户名
    userNameLabel.text = [@"用户名：" stringByAppendingString:NULLString(userNameStr)?@"":userNameStr];
    userNameLabel.hidden = !_isLogin;
    
    // 手机号码
    phoneNumberLabel.text = phoneStr;
    phoneNumberLabel.hidden = !_isLogin;
    
    // 去登录
    goLoginBtn.hidden = _isLogin;
    [goLoginBtn addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
}

// 前往个人信息页面
- (void)personalInfo{
    if(_isLogin){
        // 跳转到个人信息页面
        [self.navigationController pushViewController:[[JLUserBaseInfoViewController alloc] init] animated:YES];
    }
}

// 跳转到登陆界面
-(void)goToLogin{
    NSLog(@"去登录");
    // 跳转到登陆界面
    [self.navigationController pushViewController:[[JLLoginViewController alloc]init] animated:NO];
}

#pragma mark - UITableView数据源方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


#pragma mark - 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.mineArray.count;
}

#pragma mark - 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JLMineItem *mineItem = _mineArray[indexPath.row];
    // 由于此方法调用十分频繁，cell的标示声明成静态变量有利于性能优化
    static NSString *cellIdentifier = @"UITableViewCellIdentifierKey1";
    // 首先根据标识去缓存池取
    // 如果缓存池没有取到则重新创建并放到缓存池中
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
   /**
     * accessoryType 是一个枚举类型，具体含义如下：
     *   UITableViewCellAccessoryNone  不显示任何图标
     *   UITableViewCellAccessoryDisclosureIndicator  跳转指示图标
     *   UITableViewCellAccessoryDetailDisclosureButton  内容详情图标和跳转指示图标
     *   UITableViewCellAccessoryCheckmark  勾选图标
     *   UITableViewCellAccessoryDetailButton  内容详情图标
     *
     */
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    // 文本
    cell.textLabel.text = mineItem.name;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    // 图标
    cell.imageView.image = [UIImage imageNamed:mineItem.icon];
    // 修改图标的大小
    CGSize imageSize = CGSizeMake(20, 20);
    // 获得用来处理图形上下文。利用该上下文，就可以在其上进行绘图，并生成图片，三个参数含义是设置大小、透明度（NO为不透明）、缩放（0代表不缩放）
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    /**
     常用的图片缩放方式这三种:
     UIGraphicsBeginImageContext // 一个基于位图的上下文（context）,并将其设置为当前上下文(context)。
     UIGraphicsGetImageFromCurrentImageContext // 把当前context的内容输出成一个UIImage图片
     UIGraphicsEndImageContext // 关闭图形上下文
     思路
     调用UIGraphicsBeginImageContextWithOptions获得用来处理图片的图形上下文。
     利用该上下文，就可在上面进行绘图操作而生成图片。
     调用UIGraphicsGetImageFromCurrentImageContext可当前上下文中获取一个UIImage对象。
     在所有的绘图操作后记住要调用UIGraphicsEndImageContext关闭图形上下文。
     */
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(indexPath.row < _viewModelIndex.count){
        // 1.取出模型
        JLMineItemViewModel *viewModel = _viewModelIndex[indexPath.row];
        // 2.创建控制器
        UIViewController *vc = [[viewModel.controllerClass alloc]init];
        vc.title = viewModel.title;
        // 3.跳转
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"安全退出...");
        // 移除userDefault中存储的用户信息
//        userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"uid"];
        [userDefaults removeObjectForKey:@"username"];
        [userDefaults removeObjectForKey:@"phone"];
        [userDefaults removeObjectForKey:@"avatar"];
        [userDefaults removeObjectForKey:@"regtype"];
        [userDefaults synchronize];
        [self.navigationController pushViewController:[[JLLoginViewController alloc]init] animated:YES];
    }
}

#pragma mark - 代理方法
#pragma mark - 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 0;
}

@end














































