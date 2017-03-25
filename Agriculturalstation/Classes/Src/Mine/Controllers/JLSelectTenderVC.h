//
//  JLSelectTenderVC.h
//  Agriculturalstation
//
//  Created by chw on 17/3/23.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>

// 代理
@protocol JLSelectTenderVcDelegate <NSObject>

- (void)refreshData;

@end

@interface JLSelectTenderVC : UIViewController

@property (nonatomic, assign) int taskid; // 任务id
@property (nonatomic, assign) id<JLSelectTenderVcDelegate> delegate; // 声明代理

@end
