//
//  JLEvaluationModel.h
//  Agriculturalstation
//
//  Created by chw on 17/3/29.
//  Copyright © 2017年 chw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLEvaluationModel : NSObject

@property (nonatomic, assign) int oc_level;
@property (nonatomic, assign) int fc_level;
@property (nonatomic, copy) NSString *ownercomment;
@property (nonatomic, copy) NSString *farmercomment;

@end
