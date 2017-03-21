//
//  JLFarmListModel.h
//  Agriculturalstation
//
//  Created by chw on 17/3/20.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLFarmListModel : NSObject

@property (nonatomic, assign) int id; // 农场id
@property (nonatomic, copy) NSString *name; // 农场名称
@property (nonatomic, copy) NSString *farmer; // 农场主
@property (nonatomic, assign) double floorspace; // 农场面积
@property (nonatomic, copy) NSString *mainproduct; // 主要农作物
@property (nonatomic, copy) NSString *farmaddress; // 农场地址
@property (nonatomic, copy) NSString *provinces; // 所在省份
@property (nonatomic, copy) NSString *city; // 所在城市
@property (nonatomic, copy) NSMutableArray *picarr; // 相关图片

@end
