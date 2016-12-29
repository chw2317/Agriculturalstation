//
//  JLMineMsgCell.m
//  Agriculturalstation
//
//  Created by chw on 16/12/27.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLMineMsgCell.h"

@interface JLMineMsgCell()
// 标题
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
// 时间
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
// 内容
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation JLMineMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setMineMsgModel:(JLMineMessageModel *)mineMsgModel{
    _mineMsgModel = mineMsgModel;
    // 标题
    self.titleLabel.text = mineMsgModel.title;
    // 时间
    self.timeLabel.text = mineMsgModel.dateline;
    // 内容
    self.contentLabel.text = mineMsgModel.content;
}


+ (instancetype)mineMsgCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"msg";
    JLMineMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JLMineMsgCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

@end












































