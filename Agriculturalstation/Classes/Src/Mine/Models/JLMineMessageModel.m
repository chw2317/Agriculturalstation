//
//  JLMineMessageModel.m
//  Agriculturalstation
//
//  Created by chw on 16/12/17.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLMineMessageModel.h"

@implementation JLMineMessageModel

#pragma mark - 根据字典初始化对象
- (JLMineMessageModel *)initWithDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        // 记录id
        self.id = [dict[@"id"] intValue];
        // 标题
        self.title = dict[@"title"];
        // 时间
        self.dateline = dict[@"dateline"];
        // 内容
        self.content = dict[@"content"];
    }
    return self;
}

#pragma mark - 初始化对象（静态方法）
+ (JLMineMessageModel *)statusWithDictionay:(NSDictionary *)dict{
    JLMineMessageModel *mineMsgModel = [[JLMineMessageModel alloc]initWithDictionary:dict];
    return mineMsgModel;
}
@end
