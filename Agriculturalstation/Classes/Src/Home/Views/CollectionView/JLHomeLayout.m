//
//  JLHomeLayout.m
//  Agriculturalstation
//
//  Created by chw on 17/1/4.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLHomeLayout.h"

@implementation JLHomeLayout

// 准备布局
- (void)prepareLayout{
    [super prepareLayout];
    
    // 设置item尺寸
    CGFloat itemWH = (self.collectionView.frame.size.width - 1) / 2;
//    self.itemSize = CGSizeMake(itemWH, itemWH + 20);
    self.itemSize = CGSizeMake(100, 100);
    // 设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 设置最小间距
    self.minimumLineSpacing = 1;
    self.minimumInteritemSpacing = 1;
    
    // 隐藏水平滚动条
//    self.collectionView.showsHorizontalScrollIndicator = NO;
}
@end
