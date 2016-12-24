//
//  JLUserBaseInfoModel.h
//  Agriculturalstation
//
//  Created by chw on 16/12/24.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLUserBaseInfoModel : NSObject

// 标题
@property (nonatomic, copy) NSString *title;
// 内容
@property (nonatomic, copy) NSString *content;

-(JLUserBaseInfoModel *)initWithDictionary:(NSDictionary *)dic;

+(JLUserBaseInfoModel *)statusWithDictionary:(NSDictionary *)dic;

@end
