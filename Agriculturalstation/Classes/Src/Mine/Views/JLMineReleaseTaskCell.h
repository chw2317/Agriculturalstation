//
//  JLMineReleaseTaskCell.h
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLReleaseTaskModel.h"

// 通过代理实现点击Cell中的一个Button，在Controller中实现逻辑
@protocol ActivityCellDelegate;

@interface JLMineReleaseTaskCell : UITableViewCell{
    __unsafe_unretained id<ActivityCellDelegate> delegate;
}

@property (nonatomic, assign) id<ActivityCellDelegate> delegate;

@property(nonatomic,strong)JLReleaseTaskModel *releaseTaskModel;

+ (instancetype)releaseTaskCellWithTableView:(UITableView *)tableView;

@end


// 通过代理实现点击Cell中的一个Button，在Controller中实现逻辑
@protocol ActivityCellDelegate <NSObject>

- (void)selectTenderClick;

@end
