//
//  JLFenQiPriceCell.m
//  Agriculturalstation
//
//  Created by chw on 17/3/30.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLFenQiPriceCell.h"
#import "UITextField+IndexPath.h"

@interface JLFenQiPriceCell()
@property (strong, nonatomic) IBOutlet UILabel *number;
@property (strong, nonatomic) IBOutlet UITextField *priceTF;

@end

@implementation JLFenQiPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleString:(NSString *)string andDataString:(NSString *)dataString andIndexPath:(NSIndexPath *)indexPath{
    // 核心代码
    self.priceTF.indexPath = indexPath;
    self.priceTF.text = dataString;
    self.number.text = [NSString stringWithFormat:@"第%@期",string];
}

@end
