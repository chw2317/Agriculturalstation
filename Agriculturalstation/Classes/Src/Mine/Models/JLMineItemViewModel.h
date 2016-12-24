//
//  JLMineItemViewModel.h
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLMineItemViewModel : NSObject

@property (nonatomic, copy) NSString *title; // 描述该类的title
@property (nonatomic, assign) Class controllerClass; // 跳转到的controller

// 初始化title和controller（静态方法）
+(instancetype)initTitle:(NSString *)title controllerClass:(Class)controllerClass;

@end
