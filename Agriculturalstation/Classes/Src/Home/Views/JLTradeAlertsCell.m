//
//  JLTradeAlertsCell.m
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLTradeAlertsCell.h"

@interface JLTradeAlertsCell()
// 标题
@property (strong, nonatomic) IBOutlet UILabel *title;
// 浏览量
@property (strong, nonatomic) IBOutlet UILabel *viewNum;
// 时间
@property (strong, nonatomic) IBOutlet UILabel *time;
// 内容
@property (strong, nonatomic) IBOutlet UILabel *content;


@end


@implementation JLTradeAlertsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setTradeAlertsModel:(JLTradeAlertsModel *)tradeAlertsModel{
    _tradeAlertsModel = tradeAlertsModel;
    // 标题
    self.title.text = tradeAlertsModel.name;
    // 浏览量
    self.viewNum.text = [NSString stringWithFormat:@"%d",tradeAlertsModel.viewnum];
    // 发布时间
    self.time.text = tradeAlertsModel.dateline;
    // 内容
    self.content.text = tradeAlertsModel.content;
}

+ (instancetype)tradeAlertsCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"trade";
    JLTradeAlertsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JLTradeAlertsCell" owner:nil options:nil]firstObject];
    }
    return cell;
}

@end



























