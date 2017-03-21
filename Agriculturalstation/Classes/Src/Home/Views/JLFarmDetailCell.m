//
//  JLFarmDetailCell.m
//  Agriculturalstation
//
//  Created by chw on 17/3/20.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLFarmDetailCell.h"
#import "SDCycleScrollView.h"

@interface JLFarmDetailCell()
// 农场名称
@property (strong, nonatomic) IBOutlet UILabel *name;
// 农场面积
@property (strong, nonatomic) IBOutlet UILabel *area;
// 主要农作物
@property (strong, nonatomic) IBOutlet UILabel *mainproduct;
// 农场所在地
@property (strong, nonatomic) IBOutlet UILabel *farmaddress;
// 相关图片view
@property (strong, nonatomic) IBOutlet SDCycleScrollView *bannerView;


@end

@implementation JLFarmDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setFarmList:(JLFarmListModel *)farmList{
    _farmList = farmList;
    // 农场名称
    self.name.text = [@"农场名称：" stringByAppendingString:farmList.name];
    // 农场面积
    self.area.text = [@"农场面积：" stringByAppendingFormat:@"%0.2f亩",farmList.floorspace];
    // 主要农作物
    self.mainproduct.text = [@"主要农作物：" stringByAppendingString:farmList.mainproduct];
    // 农场所在地
    self.farmaddress.text = [@"农场所在地：" stringByAppendingString:farmList.farmaddress];
    // 相关图片
    self.bannerView.imageURLStringsGroup = farmList.picarr;
    
}

+ (instancetype)farmCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"farm";
    JLFarmDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JLFarmDetailCell" owner:nil options:nil] firstObject];
    }
    return cell;
}
@end




























