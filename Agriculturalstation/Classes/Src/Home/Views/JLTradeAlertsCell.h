//
//  JLTradeAlertsCell.h
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLTradeAlertsModel.h"

@interface JLTradeAlertsCell : UITableViewCell

@property(nonatomic, strong)JLTradeAlertsModel *tradeAlertsModel;

+ (instancetype)tradeAlertsCellWithTableView:(UITableView *)tableView;

@end
