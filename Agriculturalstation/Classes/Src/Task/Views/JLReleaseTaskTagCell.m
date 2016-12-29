//
//  JLReleaseTaskTagCell.m
//  Agriculturalstation
//
//  Created by chw on 16/12/20.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLReleaseTaskTagCell.h"
#import "UIImageView+WebCache.h"

@interface JLReleaseTaskTagCell()
// 主图片
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
// 标题
@property (strong, nonatomic) IBOutlet UILabel *taskTitle;
// 主要作物
@property (strong, nonatomic) IBOutlet UILabel *taskCrops;
// 面积
@property (strong, nonatomic) IBOutlet UILabel *taskArea;
// 项目款
@property (strong, nonatomic) IBOutlet UILabel *taskPrice;
// 可接类型
@property (strong, nonatomic) IBOutlet UILabel *acceptType;
// 截止日期
@property (strong, nonatomic) IBOutlet UILabel *endTime;


@end

@implementation JLReleaseTaskTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setReleaseTaskModel:(JLReleaseTaskModel *)releaseTaskModel{
    _releaseTaskModel = releaseTaskModel;
    
    // 给一张默认图片，先使用默认图片，当图片加载完成后再替换
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:[REQUEST_URL stringByAppendingString:releaseTaskModel.picfilepath]] placeholderImage:[UIImage imageNamed:@"no_pictures.png"]];
    // 主图片
//    self.mainImage.image = [UIImage imageNamed:[IMAGE_URL stringByAppendingString:releaseTaskModel.picfilepath]];
    
    // 标题
    self.taskTitle.text = releaseTaskModel.name;
    
    // 显示HTML文本
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithData:[releaseTaskModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    // 主要作物
    self.taskCrops.attributedText = attrStr;
    // 设置字体大小
    self.taskCrops.font = [UIFont systemFontOfSize:13];
    // 设置行数
    self.taskCrops.numberOfLines = 2;
    
    // 面积
    self.taskArea.text = [NSString stringWithFormat:@"作业面积：%@亩",releaseTaskModel.operatingarea];
    // 项目款
    self.taskPrice.text = [NSString stringWithFormat:@"项目款：￥%@",releaseTaskModel.totalprice];
    // 可接类型
    self.acceptType.text = releaseTaskModel.meetuser;
    // 截止日期
    self.endTime.text = [NSString stringWithFormat:@"竞标截止日期：%lld",releaseTaskModel.endtime];
    
}

+ (instancetype)releaseTaskTagCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"AllTask";
    JLReleaseTaskTagCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JLReleaseTaskTagCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

@end









































