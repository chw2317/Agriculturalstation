//
//  JLMineReleaseTaskCell.h
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLReleaseTaskModel.h"

@interface JLMineReleaseTaskCell : UITableViewCell

@property(nonatomic,strong)JLReleaseTaskModel *releaseTaskModel;

+ (instancetype)releaseTaskCellWithTableView:(UITableView *)tableView;

@end
