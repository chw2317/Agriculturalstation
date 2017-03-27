//
//  JLImgGridCell.h
//  Agriculturalstation
//
//  Created by chw on 17/3/27.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLImgGridCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *gifLable;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;

@end
