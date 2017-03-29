//
//  JLHomeViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/13.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLHomeViewController.h"
#import "JLHomeLayout.h"
#import "JLHomeCell.h"
#import "JLHomeHeaderView.h"
#import "ReusableView.h"
#import "JLHomeViewFooter.h"
//#import "JLHomeFooterViewCell.h"
#import "JLHomeHeaderCollectionViewCell.h"
#import "JLHomeHeaderViewTop.h"
#import "JLHomeTaskCenterLayout.h"
#import "HomeModel.h"

#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"


//static NSString *ID = @"JLHomeFooterViewCell";
static NSString *cellID = @"collectionViewCell";
static NSString *headerID = @"headerID";
static NSString *footerID = @"footerID";

@interface JLHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *releaseTaskModelArray;

@end

@implementation JLHomeViewController

// 懒加载collectionView
- (UICollectionView *)collectionView{
    if(!_collectionView){
        CGRect collectionViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - STATUS_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:[[JLHomeTaskCenterLayout alloc] init]];
        _collectionView.backgroundColor = RGB(246.0, 246.0, 246.0);;
        
        // 注册cell
//        [_collectionView registerClass:[JLHomeFooterViewCell class] forCellWithReuseIdentifier:ID];
        [_collectionView registerClass:[JLHomeHeaderCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        
        // 注册UICollectionReusableView即headerView(切记要添加headerView一定要先注册)
        // header
        [_collectionView registerClass:[JLHomeHeaderViewTop class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
        // footer
        [_collectionView registerClass:[JLHomeViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerID];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.releaseTaskModelArray = [[NSMutableArray alloc] init];
    [self getReleaseList];
}

- (void)loadView{
    [super loadView];
    // 添加collectionView
    [self.view addSubview:self.collectionView];
}

- (void)getReleaseList{
    // 请求地址
    NSString *url = [REQUEST_URL stringByAppendingString:@"app-homeinfo-op-home.html"];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    // 发起请求
    [manager POST:url parameters:nil progress:^(NSProgress *_Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        HomeModel *homeModel = [HomeModel mj_objectWithKeyValues:responseObject];
        [self.releaseTaskModelArray addObjectsFromArray:[JLReleaseTaskModel mj_objectArrayWithKeyValuesArray:homeModel.task]];
        
        // 将图片路径拼接到图片名中
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for(JLReleaseTaskModel *taskModel in self.releaseTaskModelArray){
            for(NSString *picPath in taskModel.picarr){
                if(![picPath hasPrefix:@"http://"]){
                    NSString *tempPath = [IMAGE_URL stringByAppendingString:picPath];
                    [tempArray addObject:tempPath];
                }else{
                    [tempArray addObject:picPath];
                }
            }
            taskModel.picarr = tempArray;
            [tempArray removeAllObjects];
        }
        
        // 刷新UITableView
//        [_collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        //同时弹出“加载失败”的提示；
        [MBProgressHUD showError:@"加载失败"];
    }];
}

#pragma mark - UIConllectionView数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.releaseTaskModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    JLHomeHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    JLHomeHeaderCollectionViewCell *cell = [JLHomeHeaderCollectionViewCell releaseCellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.releaseModel = self.releaseTaskModelArray[indexPath.row];
    return cell;
}

// 添加headerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath-->%d",indexPath.section);
    JLHomeViewFooter *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerID forIndexPath:indexPath];
    JLHomeHeaderViewTop *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];

    // 判断上面注册的UICollectionReusableView类型
    if(kind == UICollectionElementKindSectionHeader){
        return headerView;
    }else if(kind == UICollectionElementKindSectionFooter){
        return footerView;
    }else{
        return nil;
    }
}

#pragma mark - UICollectionViewDelegate
// 设置headerView的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.bounds.size.width, 210);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.view.bounds.size.width, 900);
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 返回每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, 125);
}

// 设置collectionView的上、下、左、右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


@end










































