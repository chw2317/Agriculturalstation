//
//  JLTransactionRecordsCell.m
//  Agriculturalstation
//
//  Created by chw on 17/3/23.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLTransactionRecordsCell.h"
#import "DateUtil.h"

@interface JLTransactionRecordsCell()




// 标题
@property (strong, nonatomic) IBOutlet UILabel *designation;
// 时间
@property (strong, nonatomic) IBOutlet UILabel *dateline;
// 操作
@property (strong, nonatomic) IBOutlet UILabel *operation;
// 金额
@property (strong, nonatomic) IBOutlet UILabel *money;
// 交易状态
@property (strong, nonatomic) IBOutlet UILabel *state;

@end


@implementation JLTransactionRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setRecordsList:(JLRecordsModel *)recordsList{
    _recordsList = recordsList;
    // 标题
    self.designation.text = recordsList.designation;
    // 时间
    self.dateline.text = [DateUtil timestampSwitchTime:recordsList.dateline andFormatter:@"YYYY-MM-dd"];
    // 操作
    self.operation.text = [@"操作：" stringByAppendingString:recordsList.operation];
    // 金额
    self.money.text = [NSString stringWithFormat:@"%0.2f",recordsList.money];
    // 交易状态
    switch (recordsList.state) {
        case 0:
            self.state.text = @"未付款";
            break;
            
        default:
            self.state.text = @"已付款";
            break;
    }
}

+ (instancetype)recordsCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"identifierCell";
    JLTransactionRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JLTransactionRecordsCell" owner:nil options:nil] firstObject];
    }
    return cell;
}


@end
