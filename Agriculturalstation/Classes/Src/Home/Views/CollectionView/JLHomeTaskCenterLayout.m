//
//  JLHomeTaskCenterLayout.m
//  Agriculturalstation
//
//  Created by chw on 17/1/12.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLHomeTaskCenterLayout.h"

@implementation JLHomeTaskCenterLayout

// 准备布局
- (void)prepareLayout{
    [super prepareLayout];
    
    
    // 设置item尺寸
    CGFloat itemWH = self.collectionView.frame.size.width / 2 - 10;
    //    self.itemSize = CGSizeMake(itemWH, itemWH + 20);
    self.itemSize = CGSizeMake(SCREEN_WIDTH, 160);
    // 设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 设置最小间距
    self.minimumLineSpacing = 1;
    
    // 隐藏水平滚动条
    //    self.collectionView.showsHorizontalScrollIndicator = NO;
    //    self.collectionView.showsVerticalScrollIndicator = NO;
}

@end
