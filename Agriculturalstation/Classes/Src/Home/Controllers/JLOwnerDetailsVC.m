//
//  JLOwnerDetailsVC.m
//  Agriculturalstation
//
//  Created by chw on 17/1/6.
//  Copyright © 2017年 chw. All rights reserved.
//

    // 农机手详情

#import "JLOwnerDetailsVC.h"

@interface JLOwnerDetailsVC ()
// 农机手
@property (strong, nonatomic) IBOutlet UILabel *locomaster;

// 机车名称
@property (strong, nonatomic) IBOutlet UILabel *locomotive;

// 工作性质
@property (strong, nonatomic) IBOutlet UILabel *naturework;

// 运营时间
@property (strong, nonatomic) IBOutlet UILabel *operatingtime;

// 目前状态
@property (strong, nonatomic) IBOutlet UILabel *status;



@end

@implementation JLOwnerDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)initView{
    self.locomaster.text = [@"农机手：" stringByAppendingString:[_ownerModel locomaster]];
    
    self.locomotive.text = [@"机车名称：" stringByAppendingString:[_ownerModel locomotive]];
    
    switch ([_ownerModel naturework]) {
        case 1:
            self.naturework.text = [NSString stringWithFormat:@"工作性质：收割"];
            break;
            
        case 2:
            self.naturework.text = [NSString stringWithFormat:@"工作性质：灌溉"];
            break;
            
        case 3:
            self.naturework.text = [NSString stringWithFormat:@"工作性质：耕作"];
            break;
            
        default:
            self.naturework.text = [NSString stringWithFormat:@"工作性质：运输"];
            break;
    }
    
    self.operatingtime.text = [@"运营时间：" stringByAppendingString:[_ownerModel operatingtime]];
    
    switch ([_ownerModel status]) {
        case 1:
            self.operatingtime.text = @"作业中";
            break;
            
        case 2:
            self.operatingtime.text = @"待接单";
            break;
            
        case 3:
            self.operatingtime.text = @"空闲中";
            break;
            
        default:
            break;
    }
    
}

@end













































