//
//  JLUserModel.h
//  Agriculturalstation
//
//  Created by chw on 16/12/17.
//  Copyright © 2016年 chw. All rights reserved.
//

  // 用户信息数据模型

#import <Foundation/Foundation.h>

@interface JLUserModel : NSObject

@property (nonatomic, assign) int uid; // 用户id
@property (nonatomic, assign) NSString *avatar; // 头像
@property (nonatomic, assign) int usertype; // 用户类型
@property (nonatomic, copy) NSString *realName; // 真实名字
@property (nonatomic, copy) NSString *username; // 用户名
@property (nonatomic, copy) NSString *phone; // 联系号码
@property (nonatomic, copy) NSString *idcard; // 身份证号
@property (nonatomic, copy) NSString *province; // 省份
@property (nonatomic, copy) NSString *city; // 城市
@property (nonatomic, copy) NSString *address; // 地址

@end
