//
//  JLOwnerListModel.h
//  Agriculturalstation
//
//  Created by chw on 17/3/21.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLOwnerListModel : NSObject

@property (nonatomic, assign) int id; // 农机id
@property (nonatomic, copy) NSString *username; // 用户名
@property (nonatomic, copy) NSString *locomaster; // 农机手
@property (nonatomic, copy) NSString *locomotive; // 机车名称
@property (nonatomic, assign) int naturework; // 工作性质
@property (nonatomic, copy) NSString *operatingtime; // 运营时间
@property (nonatomic, assign) int status; // 目前状态
@property (nonatomic, copy) NSString *provinces; // 省份
@property (nonatomic, copy) NSString *city; // 城市
@property (nonatomic, copy) NSMutableArray *picarr; // 相关图片

@end
