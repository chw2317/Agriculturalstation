//
//  JLStagesPayModel.h
//  Agriculturalstation
//
//  Created by chw on 17/3/30.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLStagesPayModel : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int taskid;
@property (nonatomic, assign) int owneruid;
@property (nonatomic, assign) int farmeruid;
@property (nonatomic, assign) int stages;
@property (nonatomic, assign) double money;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int dateline;

@end
