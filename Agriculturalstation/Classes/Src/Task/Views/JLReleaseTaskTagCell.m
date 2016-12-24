//
//  JLReleaseTaskTagCell.m
//  Agriculturalstation
//
//  Created by chw on 16/12/20.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLReleaseTaskTagCell.h"

@interface JLReleaseTaskTagCell()
// 主图片
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
// 标题
@property (strong, nonatomic) IBOutlet UILabel *taskTitle;
// 主要作物
@property (strong, nonatomic) IBOutlet UILabel *taskCrops;
// 面积
@property (strong, nonatomic) IBOutlet UILabel *taskArea;
// 项目款
@property (strong, nonatomic) IBOutlet UILabel *taskPrice;
// 可接类型
@property (strong, nonatomic) IBOutlet UILabel *acceptType;
// 截止日期
@property (strong, nonatomic) IBOutlet UILabel *endTime;


@end

@implementation JLReleaseTaskTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setReleaseTaskModel:(JLReleaseTaskModel *)releaseTaskModel{
    _releaseTaskModel = releaseTaskModel;
    // 主图片
    self.mainImage.image = [UIImage imageNamed:releaseTaskModel.mainImage];
    // 标题
    self.taskTitle.text = releaseTaskModel.title;
    // 主要作物
    self.taskCrops.text = releaseTaskModel.crops;
    // 面积
    self.taskArea.text = releaseTaskModel.area;
    // 项目款
    self.taskPrice.text = releaseTaskModel.totalPrice;
    // 可接类型
    self.acceptType.text = releaseTaskModel.undertakeType;
    // 截止日期
    self.endTime.text = releaseTaskModel.endTime;
    
}


@end









































