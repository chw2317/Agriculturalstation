//
//  JLBaseInfoModifyVC.h
//  Agriculturalstation
//
//  Created by chw on 16/12/28.
//  Copyright © 2016年 chw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLBaseInfoModifyVC : UIViewController

@property (nonatomic, strong) NSString *titleStr; // 标题
@property (nonatomic, strong) NSString *contextStr; // 内容
@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSString *userUid;

@end
