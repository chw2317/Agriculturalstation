//
//  JLBBSTagCell.m
//  Agriculturalstation
//
//  Created by chw on 16/12/20.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLBBSTagCell.h"
#import "DateUtil.h"

@interface JLBBSTagCell()
// 私有扩展
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *viewsLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation JLBBSTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setBbsModel:(JLBBSModel *)bbsModel{
    _bbsModel = bbsModel;
    // 帖子类型
    switch (bbsModel.type) {
        case 1:
            self.statusLabel.text = @"[置顶]";
            break;
            
        case 2:
            self.statusLabel.text = @"[热帖]";
            break;
            
        default:
            self.statusLabel.text = @"[新帖]";
            break;
    }
    
    // 标题
    self.titleLabel.text = bbsModel.name;
    // 字符串拼接
    self.viewsLabel.text = [NSString stringWithFormat:@"浏览(%d)",bbsModel.viewnum];
    // 时间
    self.timeLabel.text = [DateUtil timestampSwitchTime:bbsModel.dateline andFormatter:@"YYYY-MM-dd"];
}

+ (instancetype)bbsTagCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"bbs";
    JLBBSTagCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        // 如何让创建的Cell加个戳
        // 对于加载的xib文件，可以到xib视图的属性选择器中进行设置
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JLBBSTagCell" owner:nil options:nil]firstObject];
    }
    return cell;
}

@end




















































