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

static NSString *ID = @"homeCollectionViewCell";

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
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 600) collectionViewLayout:layout];
        [collectionView registerClass:[JLHomeHeaderCollectionViewCell class] forCellWithReuseIdentifier:ID];
        collectionView.backgroundColor = [UIColor lightGrayColor];
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

@end
