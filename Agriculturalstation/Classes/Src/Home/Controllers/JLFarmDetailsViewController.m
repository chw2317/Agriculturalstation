//
//  JLFarmDetailsViewController.m
//  Agriculturalstation
//
//  Created by chw on 17/1/6.
//  Copyright © 2017年 chw. All rights reserved.
//

    // 农场详情

#import "JLFarmDetailsViewController.h"

@interface JLFarmDetailsViewController ()

@property (strong, nonatomic) UILabel *name; // 农场名称
@property (strong, nonatomic) UILabel *farmer; // 农场主
@property (strong, nonatomic) UILabel *floorspace; // 农场面积
@property (strong, nonatomic) UILabel *mainproduct; // 主要农作物
@property (strong, nonatomic) UILabel *farmaddress; // 农场所在地

@end

@implementation JLFarmDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void)initView{
    NSString *str1 = @"方是否撒发生发生大发大发沙发沙发上暗示法萨芬士大夫撒飞洒的范德萨发撒飞洒地方的萨芬撒的范德萨范德萨发生撒飞洒地方撒发生大法师的萨芬撒飞洒地方撒发生的飞洒发阿萨德飞洒地方萨芬撒飞洒的";
    
    NSString *str2 = @"发送飞洒发三个地方规定规范的风格的风格的鬼地方个";
    
    CGFloat distanceX = 8.0;
    CGFloat distanceY = 16.0;
    CGFloat commonH = 20.0;
    
    // 农场主
    self.farmer = [[UILabel alloc]initWithFrame:CGRectMake(distanceX, distanceY, SCREEN_WIDTH - distanceX, commonH)];
    self.farmer.textColor = [UIColor orangeColor];
//    self.farmer.text = @"农场主：墨明棋妙";
    self.farmer.text = [@"农场主：" stringByAppendingString:[_farmModel farmer]]; // 赋值
    [self.view addSubview:self.farmer];
    
    // 农场名称
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(distanceX, distanceY + commonH + 8, SCREEN_WIDTH - distanceX, commonH)];
//    self.name.textColor = [UIColor colorWithRed:59.0/255.0 green:135.0/255.0 blue:146.0/255.0 alpha:0.0];
    self.name.textColor = RGB(59.0, 135.0, 146.0);
    self.name.font = [UIFont systemFontOfSize:16.0];
//    self.name.text = @"农场名称：西林农厂";
    self.name.text = [@"农场名称：" stringByAppendingString:[_farmModel name]]; // 赋值
    [self.view addSubview:self.name];
    
    // 农场面积
    self.floorspace = [[UILabel alloc]initWithFrame:CGRectMake(distanceX, distanceY + 2 * commonH + 2 * 8, SCREEN_WIDTH - distanceX, commonH)];
    self.floorspace.textColor = [UIColor lightGrayColor];
    self.floorspace.font = [UIFont systemFontOfSize:15.0];
//    self.floorspace.text = @"农场面积：123456.00亩";
    self.floorspace.text = [@"农场面积：" stringByAppendingString:[_farmModel floorspace]]; // 赋值
    [self.view addSubview:self.floorspace];
    
    // 主要农作物
    CGFloat farmaddressW = 100.0;
    self.mainproduct = [[UILabel alloc]initWithFrame:CGRectMake(distanceX, distanceY + 3 * commonH + 3 * 8, farmaddressW, commonH)];
    self.mainproduct.textColor = [UIColor lightGrayColor];
    self.mainproduct.font = [UIFont systemFontOfSize:15.0];
    self.mainproduct.text = @"主要农作物：";
    [self.view addSubview:self.mainproduct];
    
    
    // 动态计算主要农作物的高度
//    UILabel *farmaddressContent = [[UILabel alloc]initWithFrame:CGRectMake(farmaddressW, distanceY + 3 * commonH + 3 * 8, SCREEN_WIDTH - farmaddressW, commonH)];
    UILabel *farmaddressContent = [[UILabel alloc]init];
    [self.view addSubview:farmaddressContent];
    farmaddressContent.textColor = [UIColor lightGrayColor];
//    farmaddressContent.font = [UIFont systemFontOfSize:15.0];
//    farmaddressContent.text = str1;
    farmaddressContent.text = [_farmModel mainproduct]; // 赋值
    
    farmaddressContent.font = [UIFont systemFontOfSize:15.0];
    NSDictionary *attrilbute = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0]};
    CGSize contentSize = [farmaddressContent.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - farmaddressW, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrilbute context:nil].size;
    // 设置无限换行
    farmaddressContent.numberOfLines = 0;
    // 设置label的frame
    farmaddressContent.frame = CGRectMake(farmaddressW, distanceY + 3 * commonH + 3 * 8, contentSize.width, contentSize.height);
    

    // 农场所在地
    self.farmaddress = [[UILabel alloc]initWithFrame:CGRectMake(distanceX, contentSize.height + 4 * commonH + 4 * 8, farmaddressW, commonH)];
    self.farmaddress.textColor = [UIColor lightGrayColor];
    self.farmaddress.font = [UIFont systemFontOfSize:15.0];
    self.farmaddress.text = @"农场所在地：";
    [self.view addSubview:self.farmaddress];
    
    
    // 动态计算农场所在地的高度
//    UILabel *mainproductContent = [[UILabel alloc]initWithFrame:CGRectMake(farmaddressW, contentSize.height + 4 * commonH + 4 * 8, SCREEN_WIDTH - farmaddressW, commonH)];
    UILabel *mainproductContent = [[UILabel alloc]init];
    [self.view addSubview:mainproductContent];
    mainproductContent.textColor = [UIColor lightGrayColor];
//    mainproductContent.font = [UIFont systemFontOfSize:15.0];
//    mainproductContent.text = str2;
    mainproductContent.text = [_farmModel farmaddress]; // 赋值
    
    mainproductContent.font = [UIFont systemFontOfSize:15.0];
    CGSize contentSize1 = [mainproductContent.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - farmaddressW, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrilbute context:nil].size;
    // 设置无限换行
    mainproductContent.numberOfLines = 0;
    // 设置label的frame
    mainproductContent.frame = CGRectMake(farmaddressW, contentSize.height + 4 * commonH + 4 * 8, contentSize1.width, contentSize1.height);

    
    UILabel *aboutImg = [[UILabel alloc]initWithFrame:CGRectMake(distanceX, contentSize.height + contentSize1.height + 5 * commonH + 3 * 8, SCREEN_WIDTH - distanceX, commonH)];
    aboutImg.textColor = [UIColor lightGrayColor];
    aboutImg.font = [UIFont systemFontOfSize:15.0];
    aboutImg.text = @"相关图片：";
    [self.view addSubview:aboutImg];
    
    
}

@end






























