//
//  JLFarmCell.h
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLFarmModel.h"

@interface JLFarmCell : UITableViewCell

@property(nonatomic, strong)JLFarmModel *farmModel;

+ (instancetype)farmCellWithTableView:(UITableView *)tableView;

@end
