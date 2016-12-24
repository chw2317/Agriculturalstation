//
//  JLReleaseTaskModel.m
//  Agriculturalstation
//
//  Created by chw on 16/12/17.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLReleaseTaskModel.h"

@implementation JLReleaseTaskModel

- (JLReleaseTaskModel *)initWithDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        // 记录id
        self.ID = [dic[@"id"] intValue];
        // 标题
        self.title = dic[@"title"];
    }
    return self;
}
@end
