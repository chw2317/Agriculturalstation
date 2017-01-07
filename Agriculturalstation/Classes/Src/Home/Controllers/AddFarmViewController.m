//
//  AddFarmViewController.m
//  Agriculturalstation
//
//  Created by chw on 17/1/3.
//  Copyright © 2017年 chw. All rights reserved.
//

    // 添加农场

#import "AddFarmViewController.h"

@interface AddFarmViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    // 记录滚轮是否滚动
    NSString *_guildStr;
    NSString *_selectStr;
    UIButton *_bgButton;
}
// 所在区域
- (IBAction)areaAction;


// 农场名称
@property (strong, nonatomic) IBOutlet UITextField *name;

// 农场所有者
@property (strong, nonatomic) IBOutlet UITextField *farmer;

// 农场面积
@property (strong, nonatomic) IBOutlet UITextField *floorspace;

// 主要农作物
@property (strong, nonatomic) IBOutlet UITextField *mainproduct;

// 所在区域
@property (strong, nonatomic) IBOutlet UIButton *area;

// 农场所在地
@property (strong, nonatomic) IBOutlet UITextField *farmaddress;


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

@implementation AddFarmViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"添加农场";
    
    CGColorRef colorRef = CGColorCreate(CGColorSpaceCreateDeviceRGB(),(CGFloat[]){170.0/255.0,170.0/255.0,170.0/255.0,1});
    [self.area.layer setBorderColor:colorRef];
    
    // 设置默认选中的省份是provinces中的第一个元素
    self.selectedProvince = self.provinces[0];
}

// 所在区域
- (IBAction)areaAction {
    [self showPickerView];
}

// 弹框
- (void)showPickerView{
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
    titleLabel.text = @"所在区域";
    
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
        self.selectedProvince = self.provinces[0];
        self.selectedCity = self.cities[0];
    }
    [self.area setTitle:[NSString stringWithFormat:@"  %@-%@",self.selectedProvince,self.selectedCity] forState:UIControlStateNormal];
    [_bgButton removeFromSuperview];
}

#pragma mark - UIPickerView代理方法
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// 返回每一列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        return self.provinces.count;
    }else{
        self.cities = [self.cityNames valueForKey:_selectedProvince];
        return self.cities.count;
    }
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_WIDTH - 85 * 2;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //    _guildStr = @"1";
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
    _guildStr = [NSString stringWithFormat:@"%d",row];
}

// 返回当前行的内容，此处是将数组中的数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    // 第一列返回所有的省份
    if(component == 0){
        return self.provinces[row];
    }else{
        self.cities = [self.cityNames valueForKey:self.selectedProvince];
        return self.cities[row];
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

































