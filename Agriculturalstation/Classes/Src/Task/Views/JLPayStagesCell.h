//
//  JLPayStagesCell.h
//  Agriculturalstation
//
//  Created by chw on 17/3/30.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLStagesPayModel.h"

// 通过代理实现点击Cell中的一个Button，在Controller中实现逻辑
@protocol ActivityCellDelegate;

@interface JLPayStagesCell : UITableViewCell{
    __unsafe_unretained id<ActivityCellDelegate> delegate;
}

@property (nonatomic, assign) id<ActivityCellDelegate> delegate;

@property(nonatomic,strong) JLStagesPayModel *stagesPayModel;

- (void)setTitle:(int)num andPrice:(double)price andStatus:(int)status andRegtype:(int)regtype;

@end

// 通过代理实现点击Cell中的一个Button，在Controller中实现逻辑
@protocol ActivityCellDelegate <NSObject>

- (void)payBtnEventClick:(JLStagesPayModel *)stagesPayModel;

@end
