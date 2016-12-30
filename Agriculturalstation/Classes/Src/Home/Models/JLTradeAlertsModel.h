//
//  JLTradeAlertsModel.h
//  Agriculturalstation
//
//  Created by chw on 16/12/17.
//  Copyright © 2016年 chw. All rights reserved.
//

  // 行业快讯的数据模型

#import <Foundation/Foundation.h>

@interface JLTradeAlertsModel : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name; // 标题
@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, assign) int viewnum; // 浏览量
@property (nonatomic, copy) NSString *dateline; // 发布时间
@property (nonatomic, copy) NSString *author; // 发布者


@end
