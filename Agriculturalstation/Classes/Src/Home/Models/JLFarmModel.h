//
//  JLFarmModel.h
//  Agriculturalstation
//
//  Created by chw on 16/12/17.
//  Copyright © 2016年 chw. All rights reserved.
//

  // 农场信息数据模型

#import <Foundation/Foundation.h>

@interface JLFarmModel : NSObject

@property (nonatomic, assign) int uid; // 农场id
@property (nonatomic, copy) NSString *username; // 用户名
@property (nonatomic, copy) NSString *farmer; // 农场主
@property (nonatomic, copy) NSString *avatar; // 用户头像
@property (nonatomic, assign) double floorspace; // 农场面积
@property (nonatomic, copy) NSString *mainproduct; // 主要作物
@property (nonatomic, copy) NSString *provinces; // 省份
@property (nonatomic, copy) NSString *city; // 城市

@end
