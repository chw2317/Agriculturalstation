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

@property (nonatomic, assign) int id; // 任务id
@property (nonatomic, copy) NSString *name; // 任务名称（标题）
@property (nonatomic, copy) NSString *content; // 主要农作物
@property (nonatomic, copy) NSString *operatingarea; // 作业面积
@property (nonatomic, copy) NSString *totalprice; // 总价、项目款
@property (nonatomic, copy) NSString *meetuser; // 承接类型、可接用户
@property (nonatomic, copy) NSString *timelimit; // 预计工期
@property (nonatomic, copy) NSString *detailaddress; // 具体地址
@property (nonatomic, assign) int participationnum; // 已参与人数
@property (nonatomic, assign) long long endtime; // 截止时间
@property (nonatomic, assign) int curstatu; // 当前状态，1 竞标中  2 作业中  3 已结束
@property (nonatomic, copy) NSString *picfilepath; // 主图片
@property (nonatomic, copy) NSString *provinces; // 所在省份
@property (nonatomic, copy) NSString *city; // 所在城市


- (JLReleaseTaskModel *)initWithDictionary:(NSDictionary *)dic;

+ (JLReleaseTaskModel *)statusWithDictionary:(NSDictionary *)dic;

@end
