//
//  JLHomeTaskCenterFooter.m
//  Agriculturalstation
//
//  Created by chw on 17/1/12.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLHomeTaskCenterFooter.h"

@interface JLHomeTaskCenterFooter()
- (IBAction)moreBtnAction;


@property (strong, nonatomic) IBOutlet UILabel *sectionTitle;

@end

@implementation JLHomeTaskCenterFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"JLHomeTaskCenterFooter" owner:self options:nil].lastObject;
    }
    return self;
}

- (IBAction)moreBtnAction {
}
@end
