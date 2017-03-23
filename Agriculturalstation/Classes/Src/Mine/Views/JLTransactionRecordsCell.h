//
//  JLTransactionRecordsCell.h
//  Agriculturalstation
//
//  Created by chw on 17/3/23.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLRecordsModel.h"

@interface JLTransactionRecordsCell : UITableViewCell

@property(nonatomic, strong) JLRecordsModel *recordsList;

+ (instancetype)recordsCellWithTableView:(UITableView *)tableView;

@end
