//
//  JLHomeHeaderViewTop.m
//  Agriculturalstation
//
//  Created by chw on 17/1/7.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLHomeHeaderViewTop.h"

@interface JLHomeHeaderViewTop()
// 当前位置
@property (strong, nonatomic) IBOutlet UILabel *currentPosition;



@end

@implementation JLHomeHeaderViewTop

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"JLHomeHeaderViewTop" owner:self options:nil].lastObject;
    }
    return self;
}

@end
