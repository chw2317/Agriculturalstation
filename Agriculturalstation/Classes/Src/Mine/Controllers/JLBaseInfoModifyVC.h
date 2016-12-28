//
//  JLBaseInfoModifyVC.h
//  Agriculturalstation
//
//  Created by chw on 16/12/28.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>

// 代理
@protocol JLBaseInfoModifyVCDelegate <NSObject>

- (void)pass:(NSString *)value andIndex:(NSInteger)index;

@end

@interface JLBaseInfoModifyVC : UIViewController

@property (nonatomic, strong) NSString *titleStr; // 标题
@property (nonatomic, strong) NSString *contextStr; // 内容
@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSString *userUid;
@property (nonatomic, weak)id<JLBaseInfoModifyVCDelegate> delegate; // 声明代理

@end
