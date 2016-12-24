//
//  JLMineItem.m
//  Agriculturalstation
//
//  Created by chw on 16/12/13.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLMineItem.h"

@implementation JLMineItem

#pragma mark - 根据字典初始化对象
-(JLMineItem *)initWithDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        self.name = dic[@"name"];
        self.icon = dic[@"icon"];
    }
    return self;
}

#pragma mark - 初始化对象（静态方法）
+(JLMineItem *)statusWithDictionary:(NSDictionary *)dic{
    JLMineItem *mineItem = [[JLMineItem alloc]initWithDictionary:dic];
    return mineItem;
}

@end
