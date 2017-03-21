//
//  ServerResult.h
//  Agriculturalstation
//
//  Created by chw on 17/3/20.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerResult : NSObject

@property (nonatomic, assign) int code; // 响应状态码
@property (nonatomic, copy) NSString *msg; // 响应消息
@property (nonatomic, copy) id data;

@end
