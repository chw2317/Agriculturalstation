//
//  JLHomeHeaderView.m
//  Agriculturalstation
//
//  Created by chw on 17/1/5.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLHomeHeaderView.h"
#import "JLHomeHeaderCollectionViewCell.h"
#import "JLHomeLayout.h"
#import "JLHomeHeaderViewTop.h"

static NSString *ID = @"homeCollectionViewCell";
static NSString *headerID = @"headerID";

@interface JLHomeHeaderView()<UICollectionViewDelegate, UICollectionViewDataSource>


@end

@implementation JLHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.collectionView.showsVerticalScrollIndicator = NO;
        layout.collectionView.showsHorizontalScrollIndicator = NO;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, 115);
        // 行间距
        layout.minimumLineSpacing = 1;
        
        //添加UICollectionView
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 700) collectionViewLayout:layout];
        [collectionView registerClass:[JLHomeHeaderCollectionViewCell class] forCellWithReuseIdentifier:ID];
        // 注册UICollectionReusableView即headerView(切记要添加headerView一定要先注册)
        [collectionView registerClass:[JLHomeHeaderViewTop class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
        collectionView.backgroundColor = RGB(246.0, 246.0, 246.0);
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self addSubview:collectionView];
        
        
    }
    return self;
}

#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLHomeHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath--->%d",indexPath.row);
}

// 添加headerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath-->%d",indexPath.section);
    
        JLHomeHeaderViewTop *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
    
        // 判断上面注册的UICollectionReusableView类型
        if(kind == UICollectionElementKindSectionHeader){
            NSLog(@"headerView........");
            return headerView;
        }else{
            NSLog(@"nil........");
            return nil;
        }
}

// 设置headerView的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 210);
}

@end



























