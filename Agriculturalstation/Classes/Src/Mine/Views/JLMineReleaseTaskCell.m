//
//  JLMineReleaseTaskCell.m
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLMineReleaseTaskCell.h"
#import "UIImageView+WebCache.h"

@interface JLMineReleaseTaskCell()


// 主图片
@property (strong, nonatomic) IBOutlet UIImageView *picfilepath;

// 任务名称
@property (strong, nonatomic) IBOutlet UILabel *name;

// 农作物
@property (strong, nonatomic) IBOutlet UILabel *content;

// 面积
@property (strong, nonatomic) IBOutlet UILabel *operatingarea;

// 最高限价
@property (strong, nonatomic) IBOutlet UILabel *limitedprice;

// 总价
@property (strong, nonatomic) IBOutlet UILabel *totalprice;

// 预计工期
@property (strong, nonatomic) IBOutlet UILabel *timelimit;

// 开工时间
@property (strong, nonatomic) IBOutlet UILabel *starttime;

// 可接类型
@property (strong, nonatomic) IBOutlet UILabel *meetuser;

// 参与人数
@property (strong, nonatomic) IBOutlet UILabel *participationnum;


@end

@implementation JLMineReleaseTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setReleaseTaskModel:(JLReleaseTaskModel *)releaseTaskModel{
    _releaseTaskModel = releaseTaskModel;
    // 主图片，给一张默认图片，先使用默认图片，当图片加载完成后再替换
    [self.picfilepath sd_setImageWithURL:[NSURL URLWithString:[REQUEST_URL stringByAppendingString:releaseTaskModel.picfilepath]] placeholderImage:[UIImage imageNamed:@"no_pictures.png"]];
    
    // 任务名称
    self.name.text = releaseTaskModel.name;
    
    // 显示HTML文本
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithData:[releaseTaskModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    // 弄作物
    self.content.attributedText = attrStr;
    // 设置字体大小
    self.content.font = [UIFont systemFontOfSize:14];

    // 面积
    self.operatingarea.text = [@"作业面积：" stringByAppendingString:releaseTaskModel.operatingarea];
    
    // 最高限价
    self.limitedprice.text = [@"竞标最高限价：" stringByAppendingString:releaseTaskModel.limitedprice];
    
    // 总价
    self.totalprice.text = [@"总价：" stringByAppendingString:releaseTaskModel.totalprice];
    
    // 预计工期
    self.timelimit.text = [NSString stringWithFormat:@"预计工期：%@天",releaseTaskModel.timelimit];
    
    // 开工时间
    self.starttime.text = [NSString stringWithFormat:@"开工时间：%d",releaseTaskModel.starttime];
    
    // 可接类型
    self.meetuser.text = releaseTaskModel.meetuser;
    
    // 参与人数
    self.participationnum.text = [NSString stringWithFormat:@"已有%d人参与投标",releaseTaskModel.participationnum];
}

+ (instancetype)releaseTaskCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"task";
    JLMineReleaseTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JLMineReleaseTaskCell" owner:nil options:nil]firstObject];
    }
    return cell;
}

@end



































