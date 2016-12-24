//
//  JLUserBaseInfoModel.m
//  Agriculturalstation
//
//  Created by chw on 16/12/24.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLUserBaseInfoModel.h"

@implementation JLUserBaseInfoModel

-(JLUserBaseInfoModel *)initWithDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        self.title = dic[@"title"];
        self.content = dic[@"content"];
    }
    return self;
}

+(JLUserBaseInfoModel *)statusWithDictionary:(NSDictionary *)dic{
    JLUserBaseInfoModel *userBaseInfoModel = [[JLUserBaseInfoModel alloc]initWithDictionary:dic];
    return userBaseInfoModel;
}

@end
