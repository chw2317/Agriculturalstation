//
//  JLOwnerDetailsCell.h
//  Agriculturalstation
//
//  Created by chw on 17/3/21.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLOwnerListModel.h"

@interface JLOwnerDetailsCell : UITableViewCell

@property(nonatomic, strong) JLOwnerListModel *ownerList;

+ (instancetype)ownerCellWithTableView:(UITableView *)tableView;

@end
