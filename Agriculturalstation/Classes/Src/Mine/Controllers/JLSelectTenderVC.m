//
//  JLSelectTenderVC.m
//  Agriculturalstation
//
//  Created by chw on 17/3/23.
//  Copyright © 2017年 chw. All rights reserved.
//

    // 选标界面

#import "JLSelectTenderVC.h"

#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

@interface JLSelectTenderVC ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    int start;
    NSString *perpage;
}

@property (nonatomic, strong) NSMutableArray *userModelArray;

@end

@implementation JLSelectTenderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    start = 0;
    perpage = @"10";
    self.userModelArray = [[NSMutableArray alloc] init];
    self.title = @"选标";
}

@end






















