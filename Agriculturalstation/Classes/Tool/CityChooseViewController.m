//
//  CityChooseViewController.m
//  yoyo
//
//  Created by YoYo on 16/5/12.
//  Copyright © 2016年 cn.yoyoy.mw. All rights reserved.
//

#import "CityChooseViewController.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

@interface CityChooseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *mainTableView; //主
@property (strong, nonatomic) UITableView *subTableView; //次
@property (strong, nonatomic) NSArray *cityList; //城市列表
@property (assign, nonatomic) NSInteger selIndex;//主列表当前选中的行
@property (assign, nonatomic) NSIndexPath *subSelIndex;//子列表当前选中的行
@property (assign, nonatomic) BOOL clickRefresh;//是否是点击主列表刷新子列表,系统刚开始默认为NO
@property (copy, nonatomic) NSString *province; //选中的省
@property (copy, nonatomic) NSString *area; //选中的地区
@property (strong, nonatomic) UIButton *sureBtn;//push过来的时候，右上角的确定按钮

@property (nonatomic, strong) NSDictionary *cityNames; // plist对应的字典
@property (nonatomic, strong) NSArray *provinces; // 省份
@property (nonatomic, strong) NSArray *cityies; // 城市

@end

@implementation CityChooseViewController

/**
 
 懒加载plist
 
 */
- (NSDictionary *)cityNames{
    if(_cityNames == nil){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
        _cityNames = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _cityNames;
}

/**
 
 懒加载省份
 
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
    [self addTableView];
}

//赋值
- (void)returnCityInfo:(CityBlock)block {
    _cityInfo = block;
}

#pragma mark 创建两个tableView
- (void)addTableView {
    self.title = @"城市";
    self.view.backgroundColor = [UIColor whiteColor];
    // 刚开始，默认选中第一行
    _selIndex = 0;
    _province = self.provinces[0]; //赋值
    // _mainTableView
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width / 3 + 1, screen_height - STATUS_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    [_mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone]; // 默认省份选中第一行
    [self.view addSubview:_mainTableView];
    // _subTableView
    _subTableView = [[UITableView alloc] initWithFrame:CGRectMake(screen_width / 3, 0, screen_width * 3 / 4, SCREEN_HEIGHT - STATUS_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
    _subTableView.dataSource = self;
    _subTableView.delegate = self;
    [self.view addSubview:_subTableView];
    if (self.navigationController != nil) { // push过来这个页面的时候
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
//        _sureBtn.hidden = YES; // 隐藏确定按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_sureBtn];
    }
}
#pragma mark 确认选择
-(void) sureAction {
    if (_cityInfo != nil && _province != nil && _area != nil) {
        _cityInfo(_province, _area);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_mainTableView]) { // 省
        return self.provinces.count;
    }else { // 市
        self.cityies = [self.cityNames valueForKey:_province];
        return self.cityies.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_mainTableView]) { // 省
        static NSString *mainCellId = @"mainCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainCellId];
        }
        cell.textLabel.text = self.provinces[indexPath.row];
        return cell;
    }else { // 市
        static NSString *subCellId = @"subCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subCellId];
        }
        cell.textLabel.text = self.cityies[indexPath.row];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_mainTableView]) { // 省
        _province = self.provinces[indexPath.row]; //赋值
        _selIndex = indexPath.row; // 主列表当前选中的行
        [_subTableView reloadData];
    }else {
        _area = self.cityies[indexPath.row]; //赋值
    }
}

@end
