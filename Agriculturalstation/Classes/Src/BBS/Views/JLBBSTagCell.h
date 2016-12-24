//
//  JLBBSTagCell.h
//  Agriculturalstation
//
//  Created by chw on 16/12/20.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLBBSModel.h"

@interface JLBBSTagCell : UITableViewCell

@property(nonatomic,strong)JLBBSModel *bbsModel;

// 把加载数据（使用xib创建cell的内部细节进行封装）
+(instancetype)bbsTagCellWithTableView:(UITableView *)tableView;

@end
