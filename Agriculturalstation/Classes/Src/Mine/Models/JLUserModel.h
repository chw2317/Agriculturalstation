//
//  JLUserModel.h
//  Agriculturalstation
//
//  Created by chw on 17/3/21.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLUserModel : NSObject

@property (nonatomic, assign) int uid; // 用户id
@property (nonatomic, copy) NSString *avatar; // 用户头像
@property (nonatomic, assign) int usertype; // 用户类型
@property (nonatomic, copy) NSString *realname; // 真实名字
@property (nonatomic, copy) NSString *username; // 用户名
@property (nonatomic, copy) NSString *phone; // 联系号码
@property (nonatomic, copy) NSString *idcard; // 身份证号
@property (nonatomic, copy) NSString *resideprovince; // 省份
@property (nonatomic, copy) NSString *residecity; // 城市
@property (nonatomic, copy) NSString *resideaddress; // 地址
@property (nonatomic, copy) NSString *certificate; // 证件一
@property (nonatomic, copy) NSString *certificate1; // 证件二

@end
