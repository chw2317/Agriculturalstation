//
//  JLHomeHeaderCollectionViewCell.h
//  Agriculturalstation
//
//  Created by chw on 17/1/5.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLReleaseTaskModel.h"

@interface JLHomeHeaderCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) JLReleaseTaskModel *releaseModel;

+ (instancetype)releaseCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(nonnull NSIndexPath *)indexPath;

@end
