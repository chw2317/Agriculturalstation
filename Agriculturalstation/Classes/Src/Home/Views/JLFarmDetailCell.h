//
//  JLFarmDetailCell.h
//  Agriculturalstation
//
//  Created by chw on 17/3/20.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLFarmListModel.h"

@interface JLFarmDetailCell : UITableViewCell

@property(nonatomic, strong) JLFarmListModel *farmList;

+ (instancetype)farmCellWithTableView:(UITableView *)tableView;

@end
