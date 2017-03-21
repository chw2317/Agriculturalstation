//
//  JLOwnerCell.m
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLOwnerCell.h"
#import "UIImageView+WebCache.h"

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

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setOwnerModel:(JLOwnerModel *)ownerModel{
    _ownerModel = ownerModel;
    // 主图片，给一张默认图片，先使用默认图片，当图片加载完成后再替换
    [self.mainImg sd_setImageWithURL:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:ownerModel.avatar]] placeholderImage:[UIImage imageNamed:@"no_pictures.png"]];
    // 农机手
    self.owner.text = [@"农机手：" stringByAppendingString:ownerModel.locomaster];
    // 机车名称
    self.motiveName.text = [@"机车名称：" stringByAppendingString:ownerModel.locomotive];
    // 工作性质
    switch (ownerModel.naturework) {
        case 1:
            self.nature.text = @"工作性质：收割";
            break;
            
        case 2:
            self.nature.text = @"工作性质：灌溉";
            break;
            
        case 3:
            self.nature.text = @"工作性质：运输";
            break;
            
        default:
            break;
    }
    // 运营时间
    self.workTime.text = [@"运营时间：" stringByAppendingString:ownerModel.operatingtime];
}

+ (instancetype)ownerCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"owner";
    JLOwnerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JLOwnerCell" owner:nil options:nil]firstObject];
    }
    return cell;
}
@end




















