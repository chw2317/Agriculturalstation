//
//  JLPayStagesCell.m
//  Agriculturalstation
//
//  Created by chw on 17/3/30.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLPayStagesCell.h"

@interface JLPayStagesCell()
- (IBAction)payBtnClick:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *qiNum;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UIButton *payBtn;

@end

@implementation JLPayStagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStagesPayModel:(JLStagesPayModel *)stagesPayModel{
    _stagesPayModel = stagesPayModel;
}

- (void)setTitle:(int)num andPrice:(double)price andStatus:(int)status andRegtype:(int)regtype{
    self.qiNum.text = [NSString stringWithFormat:@"第%d期",num];
    self.priceLabel.text = [NSString stringWithFormat:@"%0.2f",price];
    self.payBtn.userInteractionEnabled = NO;
    switch (status) {
        case 0:
            if(regtype == 1){
                [self.payBtn setTitle:@"支付" forState:UIControlStateNormal];
                self.payBtn.userInteractionEnabled = YES;
            }else if (regtype == 2){
                [self.payBtn setTitle:@"未付清" forState:UIControlStateNormal];
            }
            break;
            
        case 1:
            [self.payBtn setTitle:@"已付清" forState:UIControlStateNormal];
            break;
            
        case 2:
            if(regtype == 1){
                [self.payBtn setTitle:@"未到期" forState:UIControlStateNormal];
            }else if (regtype == 2){
                [self.payBtn setTitle:@"未付清" forState:UIControlStateNormal];
            }
            break;
    }
}

- (IBAction)payBtnClick:(id)sender {
    JLLog(@"payBtnClick -- payBtnClick");
    if([self.delegate respondsToSelector:@selector(payBtnEventClick:)]){
        [self.delegate payBtnEventClick:_stagesPayModel];
    }
}
@end









































