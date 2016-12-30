//
//  JLFarmCell.m
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLFarmCell.h"

@interface JLFarmCell()
// 主图片
@property (strong, nonatomic) IBOutlet UIImageView *mainImg;
// 农场名
@property (strong, nonatomic) IBOutlet UILabel *name;
// 农场主
@property (strong, nonatomic) IBOutlet UILabel *farmer;
// 农场面积
@property (strong, nonatomic) IBOutlet UILabel *area;
// 主要农作物
@property (strong, nonatomic) IBOutlet UILabel *crops;
// 农场所在地
@property (strong, nonatomic) IBOutlet UILabel *address;


@end



@implementation JLFarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
