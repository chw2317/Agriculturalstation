//
//  JLBBSModel.h
//  Agriculturalstation
//
//  Created by chw on 16/12/17.
//  Copyright © 2016年 chw. All rights reserved.
//

  // 帖子数据模型

#import <Foundation/Foundation.h>

@interface JLBBSModel : NSObject

@property (nonatomic, assign) int ID;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, assign) int views; // 浏览量
@property (nonatomic, copy) NSString *time; // 发布时间
@property (nonatomic, copy) NSString *name;

- (JLBBSModel *)initWithDictionary:(NSDictionary *)dict;
+ (JLBBSModel *)statusWithDictionary:(NSDictionary *)dict;
@end
