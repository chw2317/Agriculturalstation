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

@property (nonatomic, assign) int uid; // 用户id
@property (nonatomic, copy) NSString *username; // 用户名
@property (nonatomic, copy) NSString *avatar; // 用户头像
@property (nonatomic, copy) NSString *locomaster; // 农机手
@property (nonatomic, copy) NSString *locomotive; // 机车名称
@property (nonatomic, assign) int naturework; // 工作性质
@property (nonatomic, copy) NSString *operatingtime; // 运营时间

@end
