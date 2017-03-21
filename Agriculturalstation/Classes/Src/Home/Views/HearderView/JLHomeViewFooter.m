//
//  JLHomeViewFooter.m
//  Agriculturalstation
//
//  Created by chw on 17/1/12.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLHomeViewFooter.h"
#import "JLHomeFooterViewCell.h"
#import "JLHomeTaskCenterFooter.h"

static NSString *cellID = @"JLHomeFooterViewCell";
static NSString *headerID = @"JLHomeTaskCenterFooter";

@interface JLHomeViewFooter()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation JLHomeViewFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.collectionView.showsVerticalScrollIndicator = NO;
        layout.collectionView.showsHorizontalScrollIndicator = NO;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - 5, 160);
    
        // 行间距
        layout.minimumLineSpacing = 1;
        
        //添加UICollectionView
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 900) collectionViewLayout:layout];
        [collectionView registerClass:[JLHomeFooterViewCell class] forCellWithReuseIdentifier:cellID];
        
        // footer
        [collectionView registerClass:[JLHomeTaskCenterFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
        
//        // 注册UICollectionReusableView即headerView(切记要添加headerView一定要先注册)
//        [collectionView registerClass:[JLHomeHeaderViewTop class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
//        // footer
//        [collectionView registerClass:[JLHomeTaskCenterFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:withReuseIdentifier:headerID];
        collectionView.backgroundColor = RGB(246.0, 246.0, 246.0);
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self addSubview:collectionView];
        
        
    }
    return self;
}

#pragma mark - UIConllectionView数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    JLHomeFooterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    return cell;
}

// 添加headerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath-->%d",indexPath.section);
    JLHomeTaskCenterFooter *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
//    JLHomeTaskCenterFooter *footer = [[JLHomeTaskCenterFooter alloc]init];
    
    // 判断上面注册的UICollectionReusableView类型
    if(kind == UICollectionElementKindSectionHeader){
        return headerView;
    }else{
        return nil;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    //    if(section == 0){
    //        return CGSizeMake(self.view.bounds.size.width, 210);
    //    }
    //    return CGSizeMake(self.view.bounds.size.width, 100);
    
    return CGSizeMake(SCREEN_WIDTH, 86);
    //    return CGSizeMake(self.view.bounds.size.width, 790);
}

@end
































