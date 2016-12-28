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

@property (nonatomic, assign) int id; // 记录的id
@property (nonatomic, assign) int type; // 帖子类型  置顶/热帖
@property (nonatomic, copy) NSString *name; // 标题
@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, assign) int viewnum; // 浏览量
@property (nonatomic, copy) NSString *dateline; // 发布时间

- (JLBBSModel *)initWithDictionary:(NSDictionary *)dict;
+ (JLBBSModel *)statusWithDictionary:(NSDictionary *)dict;
@end
