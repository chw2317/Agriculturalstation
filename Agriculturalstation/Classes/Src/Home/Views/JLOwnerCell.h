//
//  JLOwnerCell.h
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLOwnerModel.h"

@interface JLOwnerCell : UITableViewCell

@property(nonatomic,strong)JLOwnerModel *ownerModel;

+(instancetype)ownerCellWithTableView:(UITableView *)tableView;

@end
