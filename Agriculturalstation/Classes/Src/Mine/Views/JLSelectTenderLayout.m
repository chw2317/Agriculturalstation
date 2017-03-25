//
//  JLSelectTenderLayout.m
//  Agriculturalstation
//
//  Created by chw on 17/3/24.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLSelectTenderLayout.h"

@implementation JLSelectTenderLayout

// 准备布局
- (void)prepareLayout{
    [super prepareLayout];
    
    // 设置item尺寸
    CGFloat itemWH = (SCREEN_WIDTH - 30) * 0.5;
    self.itemSize = CGSizeMake(itemWH, 200);
    // 设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 设置最小间距
    self.minimumLineSpacing = 15;
    self.minimumInteritemSpacing = 1;
    
    // 隐藏水平滚动条
//    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end
