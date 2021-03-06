//
//  AddOwnerViewController.m
//  Agriculturalstation
//
//  Created by chw on 17/1/3.
//  Copyright © 2017年 chw. All rights reserved.
//

    // 添加农机

#import "AddOwnerViewController.h"
#import "CityChooseViewController.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "UIView+Layout.h"
#import "LxGridViewFlowLayout.h"
#import "JLImgGridCell.h"
#import "ServerResult.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "DateUtil.h"
#import "BLDatePickerView.h"

@interface AddOwnerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,BLDatePickerViewDelegate>{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    
    CGFloat _itemWH;
    CGFloat _margin;
    NSString *uid;
    // 记录滚轮是否滑动
    NSString *_guildStr;
    NSString *_selectStr;
    NSArray *_natureWorkArray; // 工作性质
    UIButton *_bgButton;
}
// 购买时间
- (IBAction)buyTimeAction;
// 所在区域
- (IBAction)areaAction;
// 工作性质
- (IBAction)natureWorkClick:(id)sender;


// 机车名称
@property (strong, nonatomic) IBOutlet UITextField *locomotive;
// 车主
@property (strong, nonatomic) IBOutlet UITextField *locomaster;
// 购买时间
@property (strong, nonatomic) IBOutlet UIButton *buytime;
// 运营时间
@property (strong, nonatomic) IBOutlet UITextField *operatingtime;
// 所在区域
@property (strong, nonatomic) IBOutlet UIButton *area;
// 工作性质
@property (strong, nonatomic) IBOutlet UIButton *naturework;
// 农机图片
@property (strong, nonatomic) IBOutlet UIView *imgGridView;

/**
 * 选中的省份
 */
@property (nonatomic, strong)NSString *selectedProvince;
/**
 * 选中的城市
 */
@property (nonatomic, strong)NSString *selectedCity;

// 城市选择
@property (nonatomic, strong) CityChooseViewController *cityVc;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
// 日期选择器
@property (nonatomic, strong) BLDatePickerView *datePickerView;

@end

@implementation AddOwnerViewController

- (UIImagePickerController *)imagePickerVc{
    if(_imagePickerVc == nil){
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *jlBarItem, *BarItem;
        if(iOS9Later){
            jlBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        }else{
            jlBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"添加农机";
    // 城市选择
    self.cityVc = [CityChooseViewController new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 日期选择器
    self.datePickerView = [[BLDatePickerView alloc] init];
    uid = [userDefaults objectForKey:@"uid"];
    _natureWorkArray = [NSArray arrayWithObjects:@"耕作",@"收割",@"灌溉",@"运输", nil];
    // 设置“提交”按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 24);
    [rightBtn addTarget:self action:@selector(submitDataClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    // 添加
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self configCollectionView];
}

- (void)configCollectionView{
    // 如果不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (SCREEN_WIDTH - 3 * _margin - 5) / 4 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.imgGridView.tz_height - 0) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.imgGridView addSubview:_collectionView];
    [_collectionView registerClass:[JLImgGridCell class] forCellWithReuseIdentifier:@"JLImgGridCell"];
}

// 购买时间
- (IBAction)buyTimeAction {
    int year = [DateUtil getTimeByFormatter:@"yyyy"];
    int month = [DateUtil getTimeByFormatter:@"MM"];
    int day = [DateUtil getTimeByFormatter:@"dd"];
    [self.datePickerView bl_setUpDefaultDateWithYear:year month:month day:day];
    [self.datePickerView bl_show];
    self.datePickerView.pickViewDelegate = self;
}

- (void)bl_selectedDateResultWithYear:(NSString *)year
                                month:(NSString *)month
                                  day:(NSString *)day{
    [self.buytime setTitle:[NSString stringWithFormat:@"%@-%@-%@",year, month, day] forState:UIControlStateNormal];
};

// 所在区域
- (IBAction)areaAction {
    // 选择以后的回调
    [self.cityVc returnCityInfo:^(NSString *province, NSString *area) {
        self.selectedProvince = province;
        self.selectedCity = area;
        [self.area setTitle:[NSString stringWithFormat:@"%@-%@", province, area] forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:self.cityVc animated:YES];
}

// 工作性质
- (IBAction)natureWorkClick:(id)sender {
    [self showPickerView];
}

// 提交数据
- (void)submitDataClick{
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-locomotive-op-addloco.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = uid;
    parameters[@"count"] = [NSString stringWithFormat:@"%d",_selectedPhotos.count];
    parameters[@"locomotive"] = self.locomotive.text;
    parameters[@"locomaster"] = self.locomaster.text;
    parameters[@"locobuytime"] = [NSString stringWithFormat:@"%d",[DateUtil timeSwitchTimestamp:self.area.titleLabel.text andFormatter:@"yyyy-MM-dd"]];
    parameters[@"operatingtime"] = self.operatingtime.text;
    parameters[@"provinces"] = _selectedProvince;
    parameters[@"city"] = _selectedCity;
    parameters[@"naturework"] = [NSString stringWithFormat:@"%d",[_guildStr intValue] + 1];
    // 发起请求
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData){
        
        // 获取当前系统时间
        NSDate *date = [NSDate date];
        // 使用日期格式化工具
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 指定日期格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateStr = [formatter stringFromDate:date];
        
        for(int i = 0; i < _selectedPhotos.count; i++){
            UIImage *image = _selectedPhotos[i];
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            // 使用系统时间生成一个文件名
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",dateStr,i+1];
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"uploadfile%d",i] fileName:fileName mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress *_Nonnull uploadProgress){
        // 上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject){
        // 上传成功
        
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        ServerResult *result = [ServerResult mj_objectWithKeyValues:responseObject];
        [MBProgressHUD showSuccess:result.msg];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){
        // 上传失败
        
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        // 同时弹出“提交失败”的提示；
        [MBProgressHUD showError:@"提交失败"];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    JLImgGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLImgGridCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    cell.gifLable.hidden = YES;
    if(indexPath.row == _selectedPhotos.count){
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
    }else{
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row == _selectedPhotos.count){
        // 拍照按钮放在内部
        [self pushImagePickerController];
    }else{
        // 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.maxImagesCount = 9;
        //        imagePickerVc.allowPickingOriginalPhoto = YES;
        //        imagePickerVc.isSelectOriginalPhoto =
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            //            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            //            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    }
}

#pragma mark - LxGridViewDataSource
// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath{
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath{
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    // 可以通过block或者代理，来得到用户选择的照片
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        [_collectionView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (void)deleteBtnClick:(UIButton *)sender{
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished){
        [_collectionView reloadData];
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if([picker isKindOfClass:[UIImagePickerController class]]){
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
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
    titleLabel.text = @"工作性质";
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
        _selectStr = [NSString stringWithFormat:@"%@",_natureWorkArray[0]];
    }
    [self.naturework setTitle:_selectStr forState:UIControlStateNormal];
    [_bgButton removeFromSuperview];
}

#pragma mark - UIPickerView代理方法
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _natureWorkArray.count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_WIDTH - 85 * 2;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //    _guildStr = @"1";
    _guildStr = [NSString stringWithFormat:@"%d",row];
    _selectStr = [NSString stringWithFormat:@"%@",[_natureWorkArray objectAtIndex:row]];
}

// 返回当前行的内容，此处是将数组中的数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_natureWorkArray objectAtIndex:row];
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

































