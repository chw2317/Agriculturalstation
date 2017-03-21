//
//  JLFarmDetailsViewController.h
//  Agriculturalstation
//
//  Created by chw on 17/1/6.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLFarmListModel.h"

@interface JLFarmDetailsViewController : UIViewController

@property (nonatomic, strong) JLFarmListModel *farmList;
@property (nonatomic, assign) int farmerUid;
@property (nonatomic, copy) NSString *username;

@end
