//
//  JLMineMessageModel.h
//  Agriculturalstation
//
//  Created by chw on 16/12/17.
//  Copyright © 2016年 chw. All rights reserved.
//

 // 我的消息数据模型

#import <Foundation/Foundation.h>

@interface JLMineMessageModel : NSObject

@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *time; // 时间
@property (nonatomic, copy) NSString *content; // 内容


@end
