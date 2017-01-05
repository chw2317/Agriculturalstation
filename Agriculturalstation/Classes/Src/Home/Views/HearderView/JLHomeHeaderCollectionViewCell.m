//
//  JLHomeHeaderCollectionViewCell.m
//  Agriculturalstation
//
//  Created by chw on 17/1/5.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLHomeHeaderCollectionViewCell.h"

@interface JLHomeHeaderCollectionViewCell ()
// 主图片
@property (strong, nonatomic) IBOutlet UIImageView *picfilepath;

// 任务标题
@property (strong, nonatomic) IBOutlet UILabel *name;

// 主要作物
@property (strong, nonatomic) IBOutlet UILabel *content;

// 作业面积
@property (strong, nonatomic) IBOutlet UILabel *operatingarea;

// 项目款
@property (strong, nonatomic) IBOutlet UILabel *totalprice;

// 可接类型
@property (strong, nonatomic) IBOutlet UILabel *meetuser;

// 竞标截止日期
@property (strong, nonatomic) IBOutlet UILabel *endtime;


@end

@implementation JLHomeHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"JLHomeHeaderCollectionViewCell" owner:self options:nil].lastObject;
    }
    return self;
}


@end
