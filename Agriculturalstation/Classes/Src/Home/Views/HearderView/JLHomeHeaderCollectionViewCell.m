//
//  JLHomeHeaderCollectionViewCell.m
//  Agriculturalstation
//
//  Created by chw on 17/1/5.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLHomeHeaderCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "DateUtil.h"

@interface JLHomeHeaderCollectionViewCell ()
// 主图片
@property (strong, nonatomic) IBOutlet UIImageView *picfilepath;

// 任务标题
@property (strong, nonatomic) IBOutlet UILabel *name;

// 主要作物
@property (strong, nonatomic) IBOutlet UILabel *content;

// 作业面积
@property (strong, nonatomic) IBOutlet UILabel *operatingarea;

// 项目款
@property (strong, nonatomic) IBOutlet UILabel *totalprice;

// 可接类型
@property (strong, nonatomic) IBOutlet UILabel *meetuser;

// 竞标截止日期
@property (strong, nonatomic) IBOutlet UILabel *endtime;


@end

@implementation JLHomeHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"JLHomeHeaderCollectionViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

- (void)setReleaseModel:(JLReleaseTaskModel *)releaseModel{
    _releaseModel = releaseModel;
    // 主图片，给一张默认图片，先使用默认图片，当图片加载完成后再替换
    [self.picfilepath sd_setImageWithURL:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:releaseModel.picfilepath]] placeholderImage:[UIImage imageNamed:@"no_pictures.png"]];
    // 标题
    self.name.text = releaseModel.name;
    // 内容
    self.content.text = releaseModel.content;
    // 作业面积
    self.operatingarea.text = [NSString stringWithFormat:@"作业面积：%0.2f亩",releaseModel.operatingarea];
    // 项目款
    self.totalprice.text = [NSString stringWithFormat:@"项目款：￥%0.2f",releaseModel.totalprice];
    // 可接类型
    self.meetuser.text = [NSString stringWithFormat:@"%d星及以上用户可接",releaseModel.needstar];
    // 竞标截止日期
    self.endtime.text = [NSString stringWithFormat:@"%@",[DateUtil timestampSwitchTime:releaseModel.endtime andFormatter:@"yyyy-MM-dd"]];
}

+ (instancetype)releaseCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"collectionViewCell";
    JLHomeHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JLHomeHeaderCollectionViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

@end



































