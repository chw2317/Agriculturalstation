//
//  JLOwnerDetailsCell.m
//  Agriculturalstation
//
//  Created by chw on 17/3/21.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLOwnerDetailsCell.h"
#import "SDCycleScrollView.h"

@interface JLOwnerDetailsCell()
// 机车名称
@property (strong, nonatomic) IBOutlet UILabel *locomotive;
// 工作性质
@property (strong, nonatomic) IBOutlet UILabel *naturework;
// 运营时间
@property (strong, nonatomic) IBOutlet UILabel *operatingtime;
// 目前状态
@property (strong, nonatomic) IBOutlet UILabel *status;
// 相关图片
@property (strong, nonatomic) IBOutlet SDCycleScrollView *bannerView;


@end

@implementation JLOwnerDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setOwnerList:(JLOwnerListModel *)ownerList{
    _ownerList = ownerList;
    // 机车名称
    self.locomotive.text = [@"机车名称：" stringByAppendingString:ownerList.locomotive];
    // 工作性质
    switch (ownerList.naturework) {
        case 1:
            self.naturework.text = @"工作性质：收割";
            break;
            
        case 2:
            self.naturework.text = @"工作性质：灌溉";
            break;
            
        case 3:
            self.naturework.text = @"工作性质：耕作";
            break;
            
        case 4:
            self.naturework.text = @"工作性质：运输";
            break;
    }
    // 运营时间
    self.operatingtime.text = [@"运营时间：" stringByAppendingString:ownerList.operatingtime];
    // 目前状态
    self.status.text = [@"目前状态：" stringByAppendingString:ownerList.status == 1 ? @"作业中" : @"待接单"];
    // 相关图片
    self.bannerView.imageURLStringsGroup = ownerList.picarr;
    
}

+ (instancetype)ownerCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"identifierCell";
    JLOwnerDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JLOwnerDetailsCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

@end



















