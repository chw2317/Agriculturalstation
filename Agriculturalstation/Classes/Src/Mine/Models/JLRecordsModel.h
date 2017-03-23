//
//  JLRecordsModel.h
//  Agriculturalstation
//
//  Created by chw on 17/3/23.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLRecordsModel : NSObject

@property (nonatomic, assign) int id; // 记录id
@property (nonatomic, assign) int uid; // 用户id
@property (nonatomic, copy) NSString *designation; // 标题
@property (nonatomic, copy) NSString *operation; // 操作
@property (nonatomic, assign) int dateline; // 时间
@property (nonatomic, assign) double money; // 金额
@property (nonatomic, copy) NSString *orderid; // 订单id
@property (nonatomic, copy) NSString *recipient; // 接收人
@property (nonatomic, assign) int state; // 交易状态

@end
