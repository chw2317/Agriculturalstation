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

@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, assign) int views; // 浏览量
@property (nonatomic, copy) NSString *time; // 发布时间
@property (nonatomic, copy) NSString *author; // 发布者


@end
