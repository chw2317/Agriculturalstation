//
//  JLMineItemViewModel.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLMineItemViewModel.h"

@implementation JLMineItemViewModel

+(instancetype)initTitle:(NSString *)title controllerClass:(Class)controllerClass{
    JLMineItemViewModel *viewModel = [[self alloc]init];
    viewModel.title = title;
    viewModel.controllerClass = controllerClass;
    return viewModel;
}
@end
