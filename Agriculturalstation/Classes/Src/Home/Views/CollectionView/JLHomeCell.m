//
//  JLHomeCell.m
//  Agriculturalstation
//
//  Created by chw on 17/1/5.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLHomeCell.h"

@interface JLHomeCell()
@property (strong, nonatomic) IBOutlet UIImageView *farmImage;
@property (strong, nonatomic) IBOutlet UILabel *farmName;
@property (strong, nonatomic) IBOutlet UILabel *farmer;

@end

@implementation JLHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
