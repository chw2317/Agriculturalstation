//
//  JLOwnerModel.h
//  Agriculturalstation
//
//  Created by chw on 16/12/17.
//  Copyright © 2016年 chw. All rights reserved.
//

  // 农机手数据模型

#import <Foundation/Foundation.h>

@interface JLOwnerModel : NSObject

@property (nonatomic, assign) int id; // 农机id
@property (nonatomic, copy) NSString *locomaster; // 农机手
@property (nonatomic, copy) NSString *locomotive; // 机车名称
@property (nonatomic, assign) int naturework; // 工作性质
@property (nonatomic, copy) NSString *operatingtime; // 运营时间
@property (nonatomic, assign) int status; // 目前状态
@property (nonatomic, copy) NSString *provinces; // 省份
@property (nonatomic, copy) NSString *city; // 城市
@property (nonatomic, copy) NSString *locopic; // 主图


@end
