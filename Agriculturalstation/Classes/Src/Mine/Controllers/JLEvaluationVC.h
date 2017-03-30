//
//  JLEvaluationVC.h
//  Agriculturalstation
//
//  Created by chw on 17/3/29.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>

// 代理
@protocol JLSelectTenderVcDelegate <NSObject>

- (void)refreshData;

@end

@interface JLEvaluationVC : UIViewController

@property (nonatomic, assign) id<JLSelectTenderVcDelegate> delegate; // 声明代理

@property (nonatomic, assign) int taskid;

@end
