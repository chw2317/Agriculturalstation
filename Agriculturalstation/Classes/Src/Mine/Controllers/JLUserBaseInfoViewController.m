//
//  JLUserBaseInfoViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/19.
//  Copyright © 2016年 chw. All rights reserved.
//

 // 用户基础信息视图

#import "JLUserBaseInfoViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "JLBaseInfoModifyVC.h"

@interface JLUserBaseInfoViewController ()<UITableViewDelegate,UITableViewDataSource,JLBaseInfoModifyVCDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    // 记录滚轮是否滚动
    NSString *_guildStr;
    NSString *_selectStr;
    NSString *_type; // 用于判断是用户类型还是城市选择
    NSArray *_userTypeArray; // 用户类型
    UIButton *_bgButton;
    
    UITableView *_tableView;
    NSMutableArray *_itemLabelArray;
    NSMutableArray *_itemContentArray;
    NSString *userUid;
}

@property(nonatomic, strong)JLBaseInfoModifyVC *modifyVC;
/**
 * plist对应的字典
 */
@property (nonatomic, strong)NSDictionary *cityNames;
/**
 * 省份
 */
@property (nonatomic, strong)NSArray *provinces;
/**
 * 城市
 */
@property (nonatomic, strong)NSArray *cities;
/**
 * 选中的省份
 */
@property (nonatomic, strong)NSString *selectedProvince;
/**
 * 选中的城市
 */
@property (nonatomic, strong)NSString *selectedCity;

@end

@implementation JLUserBaseInfoViewController

/**
 * 懒加载plist
 *
 * @return plist对应的字典
 */
- (NSDictionary *)cityNames{
    if(_cityNames == nil){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
        _cityNames = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _cityNames;
}

/**
 * 懒加载省份
 *
 * @return 省份对应的数组
 */
- (NSArray *)provinces{
    if(_provinces == nil){
        // 将省份保存到数组中，但是字典保存的是无序的，所以读出来的省份也是无序的
        _provinces = [self.cityNames allKeys];
    }
    return _provinces;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userUid = [userDefaults objectForKey:@"uid"];
    [self sendRequest];
    
    self.title = @"基础信息";
    
    // 拿到xib视图
    NSArray *userInfoXib = [[NSBundle mainBundle]loadNibNamed:@"JLUserBaseInfo" owner:nil options:nil];
    UIView *userInfoView = [userInfoXib firstObject];
    
    // 相关证件一
    UIButton *certificate1 = (UIButton *)[userInfoView viewWithTag:1];
    [certificate1 addTarget:self action:@selector(certificate1BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 相关证件二
    UIButton *certificate2 = (UIButton *)[userInfoView viewWithTag:2];
    [certificate2 addTarget:self action:@selector(certificate2BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 用户类型
    _userTypeArray = [NSArray arrayWithObjects:@"个人",@"公司",@"企业", nil];

    _itemLabelArray = [NSMutableArray arrayWithObjects:@"用户名",@"用户类型",@"联系电话",@"真实姓名",@"身份证号",@"籍贯",@"详细地址", nil];
    // 创建一个分组样式的UITableView
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    headerView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.0];
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = userInfoView;
    
    [self.view addSubview:_tableView];
    // 设置数据源
    _tableView.dataSource = self;
    // 设置代理
    _tableView.delegate = self;
    
    // 设置默认选中的省份是provinces中的第一个元素
    self.selectedProvince = self.provinces[0];
}

- (void)sendRequest{
    
    // 显示MBProgressHUD
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-personalinfo-op-get.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = userUid;
    // 发起请求
    [manager POST:url parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        [self setUserDatas:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        //同时弹出“登录失败”的提示；
        [MBProgressHUD showError:@"加载失败"];
    }];

}

- (void)setUserDatas:(id)responseObject{
    // 用户名
    NSString *userName = NULLString(responseObject[@"username"])?@"未填写":responseObject[@"username"];
    // 用户类型
    NSString *userType = @"";
    switch ([responseObject[@"usertype"] intValue]) {
        case 1:
            userType = @"个人";
            break;
        
        case 2:
            userType = @"公司";
            break;
        
        case 3:
            userType = @"企业";
            break;
    }
    // 联系电话
    NSString *phoneNumber = NULLString(responseObject[@"phone"])?@"未填写":responseObject[@"phone"];
    // 真实姓名
    NSString *realName = NULLString(responseObject[@"realname"])?@"未填写":responseObject[@"realname"];
    // 身份证号
    NSString *idcard = NULLString(responseObject[@"idcard"])?@"未填写":responseObject[@"idcard"];
    // 籍贯
    NSString *nativePlace = NULLString(responseObject[@"province"])?@"未填写":[NSString stringWithFormat:@"%@-%@",responseObject[@"province"],responseObject[@"city"]];
    // 详细地址
    NSString *address = NULLString(responseObject[@"address"])?@"未填写":responseObject[@"address"];
    
    _itemContentArray = [NSMutableArray arrayWithObjects:userName,userType,phoneNumber,realName,idcard,nativePlace,address, nil];
    // 刷新UITableView
    [_tableView reloadData];
}

#pragma mark - 实现代理方法，接收传过来的内容
- (void)pass:(NSString *)value andIndex:(NSInteger)index{
    NSLog(@"value = %@     index = %d",value,index);
    [_itemContentArray replaceObjectAtIndex:index withObject:value];
    NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationLeft];
}

// 相关证件一
- (void)certificate1BtnAction:(UIButton *)sender{
    NSLog(@"相关证件一");
}

// 相关证件二
- (void)certificate2BtnAction:(UIButton *)sender{
    NSLog(@"相关证件二");
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
    if([type isEqualToString:@"userType"]){
        titleLabel.text = @"选择用户类型";
    }else if([type isEqualToString:@"area"]){
        titleLabel.text = @"选择籍贯";
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
    if([_type isEqualToString:@"area"]){
        if([_guildStr isEqualToString:@"0"]){
            self.selectedProvince = self.provinces[0];
            self.selectedCity = self.cities[0];
        }
        // 刷新tableview
        [_itemContentArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%@-%@",self.selectedProvince,self.selectedCity]];
        NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:5 inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationLeft];
        [_bgButton removeFromSuperview];
    }else{
        if([_guildStr isEqualToString:@"0"]){
            _selectStr = [NSString stringWithFormat:@"%@",_userTypeArray[0]];
        }
        // 刷新tableview
        [_itemContentArray replaceObjectAtIndex:1 withObject:_selectStr];
        NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:1 inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationLeft];
        [_bgButton removeFromSuperview];
    }
}

#pragma mark - UITableView数据源方法
// 返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemLabelArray.count;
}

#pragma mark - 返回每行单元格Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UITableViewIdentifierKey1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _itemLabelArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if(_itemContentArray.count > 0){
        cell.detailTextLabel.text = _itemContentArray[indexPath.row];
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

#pragma mark - 行的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = indexPath.row;
    switch (index) {
        case 1: // 用户类型
            _type = @"userType";
            [self showPickerView:_type];
            break;
            
        case 5: // 籍贯
            _type = @"area";
            [self showPickerView:_type];
            break;
            
        default:
            self.modifyVC = [JLBaseInfoModifyVC new];
            [self.navigationController pushViewController:_modifyVC animated:YES];
            _modifyVC.titleStr = _itemLabelArray[index];
            _modifyVC.contextStr = _itemContentArray[index];
            _modifyVC.index = index;
            _modifyVC.userUid = userUid;
            // 指定代理
            _modifyVC.delegate = self;
            break;
    }
}

#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

// 如果设置header（或者footer）高度是0的话，系统会认为你没设置，然后将其设置为40.0f
#pragma mark - 设置头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001f;
}

#pragma mark - 设置尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}


#pragma mark - UIPickerView代理方法
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if([_type isEqualToString:@"area"]){
        return 2;
    }
    return 1;
}

// 返回每一列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([_type isEqualToString:@"area"]){
        if(component == 0){
            return self.provinces.count;
        }else{
            self.cities = [self.cityNames valueForKey:_selectedProvince];
            return self.cities.count;
        }
    }else{
        return _userTypeArray.count;
    }
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_WIDTH - 85 * 2;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //    _guildStr = @"1";
    if([_type isEqualToString:@"area"]){
        if(component == 0){
            // 选中的省份
            self.selectedProvince = self.provinces[row];
            // 重新加载第二列的数据
            [pickerView reloadComponent:1];
            // 让第二列归为
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }else{
            // 选中的城市
            self.selectedCity = self.cities[row];
        }
    }else{
        
        _selectStr = [NSString stringWithFormat:@"%@",[_userTypeArray objectAtIndex:row]];
    }
    _guildStr = [NSString stringWithFormat:@"%d",row];
}

// 返回当前行的内容，此处是将数组中的数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([_type isEqualToString:@"area"]){
        // 第一列返回所有的省份
        if(component == 0){
            return self.provinces[row];
        }else{
            self.cities = [self.cityNames valueForKey:self.selectedProvince];
            return self.cities[row];
        }
    }else{
        return [_userTypeArray objectAtIndex:row];
    }
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
    
    UIView *lineLabel1 = [[UIView alloc]initWithFrame:CGRectMake(45, 55, SCREEN_WIDTH - 45 * 2, 1.5)];
    lineLabel1.backgroundColor = [UIColor orangeColor];
    [pickerView addSubview:lineLabel1];
    
    UIView *lineLabel2 = [[UIView alloc]initWithFrame:CGRectMake(45, 82, SCREEN_WIDTH - 45 * 2, 1.5)];
    lineLabel2.backgroundColor = [UIColor orangeColor];
    [pickerView addSubview:lineLabel2];
    
    return pickerLabel;
}

@end
























































