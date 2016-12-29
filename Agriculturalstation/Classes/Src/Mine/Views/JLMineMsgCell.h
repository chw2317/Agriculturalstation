//
//  JLMineMsgCell.h
//  Agriculturalstation
//
//  Created by chw on 16/12/27.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLMineMessageModel.h"

@interface JLMineMsgCell : UITableViewCell

@property(nonatomic, strong)JLMineMessageModel *mineMsgModel;

// 把加载数据（使用xib创建Cell的内容细节进行封装）
+(instancetype)mineMsgCellWithTableView:(UITableView *)tableView;


@end
