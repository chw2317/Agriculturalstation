//
//  JLMineItem.h
//  Agriculturalstation
//
//  Created by chw on 16/12/13.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLMineItem : NSObject

#pragma mark - 属性
// 标题
@property (nonatomic, copy)NSString *name;
// 图标
@property (nonatomic, copy)NSString *icon;

#pragma mark - 方法
// 根据字典初始化对象
-(JLMineItem *)initWithDictionary:(NSDictionary *)dic;
// 初始化对象（静态方法）
+(JLMineItem *)statusWithDictionary:(NSDictionary *)dic;

@end
