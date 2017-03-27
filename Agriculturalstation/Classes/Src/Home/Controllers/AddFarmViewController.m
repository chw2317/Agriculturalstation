//
//  AddFarmViewController.m
//  Agriculturalstation
//
//  Created by chw on 17/1/3.
//  Copyright © 2017年 chw. All rights reserved.
//

    // 添加农场

#import "AddFarmViewController.h"
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

@interface AddFarmViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    
    CGFloat _itemWH;
    CGFloat _margin;
    NSString *uid;
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

@property (strong, nonatomic) IBOutlet UIView *imgGirdView;

/**
 * 选中的省份
 */
@property (nonatomic, strong) NSString *selectedProvince;
/**
 * 选中的城市
 */
@property (nonatomic, strong) NSString *selectedCity;
// 城市选择
@property (nonatomic, strong) CityChooseViewController *cityVc;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation AddFarmViewController

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
    
    self.title = @"添加农场";
    // 城市选择
    self.cityVc = [CityChooseViewController new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    uid = [userDefaults objectForKey:@"uid"];
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.imgGirdView.tz_height - 0) collectionViewLayout:layout];
//    JLLog(@"imgGirdView.width === %f ----- view.width = %f ---- SCREEN_WIDTH == %f", self.imgGirdView.tz_width, self.view.tz_width, SCREEN_WIDTH);
//    CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = YES;
//    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.imgGirdView addSubview:_collectionView];
    [_collectionView registerClass:[JLImgGridCell class] forCellWithReuseIdentifier:@"JLImgGridCell"];
}

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

// 提交数据
- (void)submitDataClick{
    [MBProgressHUD showMessage:nil];
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-myfarm-op-addfarm.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"uid"] = uid;
    parameters[@"count"] = [NSString stringWithFormat:@"%d",_selectedPhotos.count];
    parameters[@"name"] = self.name.text;
    parameters[@"farmer"] = self.farmer.text;
    parameters[@"floorspace"] = self.floorspace.text;
    parameters[@"mainproduct"] = self.mainproduct.text;
    parameters[@"provinces"] = _selectedProvince;
    parameters[@"city"] = _selectedCity;
    parameters[@"farmaddress"] = self.farmaddress.text;
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
        JLLog(@"---- success ----");
        [MBProgressHUD showSuccess:result.msg];

    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){
        // 上传失败
        
        // 隐藏MBProgressHUD
        [MBProgressHUD hideHUD];
        // 同时弹出“提交失败”的提示；
        [MBProgressHUD showError:@"提交失败"];
    }];
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
@end



































