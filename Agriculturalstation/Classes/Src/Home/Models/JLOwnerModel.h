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

@property (nonatomic, assign) int ID; // 农机id
@property (nonatomic, copy) NSString *name; // 农机手
@property (nonatomic, copy) NSString *owner; // 机车名称
@property (nonatomic, assign) int nature; // 工作性质
@property (nonatomic, copy) NSString *time; // 运营时间
@property (nonatomic, assign) int status; // 目前状态
@property (nonatomic, copy) NSString *province; // 省份
@property (nonatomic, copy) NSString *city; // 城市
@property (nonatomic, assign) NSString *mainImg; // 主图


@end
