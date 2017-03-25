//
//  JLSelectTenderCell.m
//  Agriculturalstation
//
//  Created by chw on 17/3/24.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "JLSelectTenderCell.h"
#import "UIImageView+WebCache.h"

@interface JLSelectTenderCell()
// 选择此人
- (IBAction)selectBtnClick:(id)sender;

// 查看信息
- (IBAction)userInfoBtnClick:(id)sender;


// 头像
@property (strong, nonatomic) IBOutlet UIImageView *avatar;

// 农机主
@property (strong, nonatomic) IBOutlet UILabel *username;

// 手机
@property (strong, nonatomic) IBOutlet UILabel *phone;

// 地址
@property (strong, nonatomic) IBOutlet UILabel *address;


@end

@implementation JLSelectTenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"JLSelectTenderCell" owner:self options:nil].lastObject;
    }
    return self;
}

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setUserModel:(JLUserModel *)userModel{
    _userModel = userModel;
    // 头像，给一张默认图片，先使用默认图片，当图片加载完成后再替换
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:userModel.avatar]] placeholderImage:[UIImage imageNamed:@"no_pictures.png"]];
    
    // 农机主
    self.username.text = [@"农机主：" stringByAppendingString:userModel.username];
    
    // 手机
    self.phone.text = [@"手机：" stringByAppendingString:userModel.phone];
    
    // 地址
    self.address.text = [@"地址：" stringByAppendingString:userModel.resideaddress];
}

+ (instancetype)userCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"collectionViewCell";
    JLSelectTenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JLSelectTenderCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

// 选择此人
- (IBAction)selectBtnClick:(id)sender {
    if([self.tenderDelegate respondsToSelector:@selector(selectTender:)]){
        [self.tenderDelegate selectTender:_userModel.uid];
    }
}

// 查看信息
- (IBAction)userInfoBtnClick:(id)sender {
    if([self.infoDelegate respondsToSelector:@selector(userInfoClick:)]){
        [self.infoDelegate userInfoClick:_userModel];
    }
}

@end


































