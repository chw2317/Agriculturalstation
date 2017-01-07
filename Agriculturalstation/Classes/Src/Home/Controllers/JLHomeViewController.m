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

static NSString *ID = @"homeCollectionViewCell";
static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";
static NSString *footerID = @"footerID";

@interface JLHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView{
    [super loadView];
    
    // 添加collectionView
    [self.view addSubview:self.collectionView];
}

// 懒加载collectionView
- (UICollectionView *)collectionView{
    if(!_collectionView){
        CGRect collectionViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - STATUS_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:[[JLHomeLayout alloc] init]];
        _collectionView.backgroundColor = RGB(246.0, 246.0, 246.0);;
        
        // 注册cell
        [_collectionView registerClass:[JLHomeCell class] forCellWithReuseIdentifier:ID];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
        
        // 注册UICollectionReusableView即headerView(切记要添加headerView一定要先注册)
        [_collectionView registerClass:[JLHomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
//        [_collectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

#pragma mark - UIConllectionView数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor orangeColor];
        return cell;
    }else if (indexPath.section == 1){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blueColor];
        return cell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = indexPath.section%2?[UIColor redColor]:[UIColor cyanColor];
    return cell;
//    JLHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
//    NSLog(@"cellForItemAtIndexPath........");
//    return cell;
}

// 添加headerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath-->%d",indexPath.section);
    
//    JLHomeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
//
//    // 判断上面注册的UICollectionReusableView类型
//    if(kind == UICollectionElementKindSectionHeader){
//        NSLog(@"headerView........");
//        return headerView;
//    }else{
//        NSLog(@"nil........");
//        return nil;
//    }
    
    // 如果是头视图
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
        // 此处的header可能会产生复用，所以在使用之前要将其中的原有的子视图移除掉
        for(UIView *view in header.subviews){
            [view removeFromSuperview];
        }
        
        // 添加头视图的内容
        if(indexPath.section == 0){
            JLHomeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
            return headerView;
        }else{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 100)];
            view.backgroundColor = [UIColor blueColor];
            // 头视图添加View
            [header addSubview:view];
        }
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
// 设置headerView的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return CGSizeMake(self.view.bounds.size.width, 700);
    }
    return CGSizeMake(self.view.bounds.size.width, 100);;
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 设置collectionView的上、下、左、右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(14, 0, 0, 0);
    return UIEdgeInsetsMake(14, 10, 10, 10);
}

@end










































