//
//  JLHomeFooterViewCell.m
//  Agriculturalstation
//
//  Created by chw on 17/1/12.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLHomeFooterViewCell.h"

@interface JLHomeFooterViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *mainImg;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation JLHomeFooterViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"JLHomeFooterViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

@end
