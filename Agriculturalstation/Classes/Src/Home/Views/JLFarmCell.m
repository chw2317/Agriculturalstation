//
//  JLFarmCell.m
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLFarmCell.h"
#import "UIImageView+WebCache.h"

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

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setFarmModel:(JLFarmModel *)farmModel{
    _farmModel = farmModel;
    // 主图片，给一张默认图片，先使用默认图片，当图片加载完成后再替换
    [self.mainImg sd_setImageWithURL:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:farmModel.avatar]] placeholderImage:[UIImage imageNamed:@"no_pictures.png"]];
    // 用户名
    self.name.text = farmModel.username;
    // 农场主
    self.farmer.text = [@"农场主：" stringByAppendingString:farmModel.farmer];
    // 农场面积
    self.area.text = [NSString stringWithFormat:@"农场面积：%0.2f亩",farmModel.floorspace];
    // 主要农作物
    self.crops.text = [@"主要农作物：" stringByAppendingString:farmModel.mainproduct];
    // 农场地址
    self.address.text = [@"农场所在地：" stringByAppendingFormat:@"%@%@",farmModel.provinces,farmModel.city];
}

+ (instancetype)farmCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"farm";
    JLFarmCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JLFarmCell" owner:nil options:nil]firstObject];
    }
    return cell;
}
@end
















