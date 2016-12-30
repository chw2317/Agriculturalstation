//
//  JLOwnerCell.m
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLOwnerCell.h"

@interface JLOwnerCell()
// 主图片
@property (strong, nonatomic) IBOutlet UIImageView *mainImg;
// 农机手
@property (strong, nonatomic) IBOutlet UILabel *owner;
// 机车名称
@property (strong, nonatomic) IBOutlet UILabel *motiveName;
// 工作性质
@property (strong, nonatomic) IBOutlet UILabel *nature;
// 运营时间
@property (strong, nonatomic) IBOutlet UILabel *workTime;

@end


@implementation JLOwnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
