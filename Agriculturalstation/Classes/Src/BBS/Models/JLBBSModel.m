//
//  JLBBSModel.m
//  Agriculturalstation
//
//  Created by chw on 16/12/17.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLBBSModel.h"

@implementation JLBBSModel

#pragma mark - 根据字典初始化对象
-(JLBBSModel *)initWithDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        // 记录的id
        self.ID = [dic[@"id"] intValue];
        // 标题
        self.title = dic[@"title"];
        // 内容
        self.content = dic[@"content"];
        // 浏览量
        self.views = [dic[@"views"] intValue];
        // 时间
        self.time = dic[@"time"];
        // 类型
        self.type = [dic[@"type"] intValue];
    }
    return self;
    
}

#pragma mark - 初始化对象（静态方法）
+(JLBBSModel *)statusWithDictionary:(NSDictionary *)dic{
    JLBBSModel *bbsModel = [[JLBBSModel alloc]initWithDictionary:dic];
    return bbsModel;
}

@end
