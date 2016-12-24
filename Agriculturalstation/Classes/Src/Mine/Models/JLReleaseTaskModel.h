//
//  JLReleaseTaskModel.h
//  Agriculturalstation
//
//  Created by chw on 16/12/17.
//  Copyright © 2016年 chw. All rights reserved.
//

 // 发布的任务数据模型

#import <Foundation/Foundation.h>

@interface JLReleaseTaskModel : NSObject

@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *title; // 任务名称（标题）
@property (nonatomic, copy) NSString *crops; // 主要农作物
@property (nonatomic, copy) NSString *area; // 作业面积
@property (nonatomic, copy) NSString *limitedPrice; // 竞标最高限价
@property (nonatomic, copy) NSString *totalPrice; // 总价、项目款
@property (nonatomic, copy) NSString *schedule; // 预计工期
@property (nonatomic, copy) NSString *startWorkTime; // 开工时间
@property (nonatomic, copy) NSString *undertakeType; // 承接类型、可接用户
@property (nonatomic, copy) NSString *endTime; // 截止时间
@property (nonatomic, assign) int curStatus; // 当前状态，1 竞标中  2 作业中  3 已结束
@property (nonatomic, assign) int participationnum; // 参与人数
@property (nonatomic, copy) NSString *provinces; // 所在省份
@property (nonatomic, copy) NSString *city; // 所在城市
@property (nonatomic, assign) NSString *mainImage;


- (JLReleaseTaskModel *)initWithDictionary:(NSDictionary *)dic;

+ (JLReleaseTaskModel *)statusWithDictionary:(NSDictionary *)dic;

@end
