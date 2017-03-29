//
//  HomeModel.h
//  Agriculturalstation
//
//  Created by chw on 17/3/28.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLReleaseTaskModel.h"
#import "JLFarmModel.h"
#import "JLOwnerModel.h"

@interface HomeModel : NSObject

@property (nonatomic, assign) NSMutableArray *task;
@property (nonatomic, assign) NSMutableArray *farmer;
@property (nonatomic, assign) NSMutableArray *owner;

@end
