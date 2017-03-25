//
//  JLSelectTenderCell.h
//  Agriculturalstation
//
//  Created by chw on 17/3/24.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLUserModel.h"

@protocol SelectTenderDelegate;
@protocol UserInfoDelegate;

@interface JLSelectTenderCell : UICollectionViewCell{
    __unsafe_unretained id<SelectTenderDelegate> tenderDelegate;
    __unsafe_unretained id<UserInfoDelegate> infoDelegate;
}

@property (nonatomic, assign) id<SelectTenderDelegate> tenderDelegate;
@property (nonatomic, assign) id<UserInfoDelegate> infoDelegate;


@property (nonatomic,strong) JLUserModel *userModel;

+ (instancetype)userCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(nonnull NSIndexPath *)indexPath;

@end

@protocol SelectTenderDelegate <NSObject>

- (void)selectTender:(int)userid;

@end

@protocol UserInfoDelegate <NSObject>

- (void)userInfoClick:(JLUserModel *)userModel;

@end









