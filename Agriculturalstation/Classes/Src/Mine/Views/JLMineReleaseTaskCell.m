//
//  JLMineReleaseTaskCell.m
//  Agriculturalstation
//
//  Created by chw on 16/12/30.
//  Copyright © 2016年 chw. All rights reserved.
//

/**
 实现在Cell中点击一个Button，在Controller中实现该Button的点击逻辑(比如跳转)
 
 用delegate可以这么写：
 1.cell的头文件：
 @protocol ActivityCellDelegate;
 
 @interface ActivityCell : UITableViewCell{
 __unsafe_unretained id<ActivityCellDelegate> delegate;
 }
 
 @property (nonatomic, assign)id<ActivityCellDelegate> delegate;
 
 @end
 
 @protocol ActivityCellDelegate <NSObject>
 - (void)onClick;
 @end
 
 2.cell实现文件里 @synthesize delegate;视图点击方法中加上：
 if ([self.delegate respondsToSelector:@selector(onClick)]) {
 [self.delegate onClick];
 }
 
 2.controller遵循ActivityCellDelegate协议
 
 3.controller中cellForRowAtIndexPath里面加上cell.delega = self;
 
 3.controller中实现onClick方法，push页面的相关代码可以放在其中了
 
 
 */


#import "JLMineReleaseTaskCell.h"
#import "UIImageView+WebCache.h"
#import "DateUtil.h"


@interface JLMineReleaseTaskCell()

- (IBAction)selectTender:(id)sender;


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

// 选标
@property (strong, nonatomic) IBOutlet UIButton *tenderBtn;

// 竞标中
@property (strong, nonatomic) IBOutlet UIButton *curStatus;


@property (nonatomic, assign) int regtype; // 1农场主、2农机主

@end

@implementation JLMineReleaseTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 获取用户regtype
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.regtype = [[userDefaults objectForKey:@"regtype"] intValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 重写set方法，完成数据的赋值操作
- (void)setReleaseTaskModel:(JLReleaseTaskModel *)releaseTaskModel{
    _releaseTaskModel = releaseTaskModel;
    
    // 主图片，给一张默认图片，先使用默认图片，当图片加载完成后再替换
    [self.picfilepath sd_setImageWithURL:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:releaseTaskModel.picfilepath]] placeholderImage:[UIImage imageNamed:@"no_pictures.png"]];
    
    // 任务名称
    self.name.text = releaseTaskModel.name;
    
    // 显示HTML文本
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithData:[releaseTaskModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    // 农作物
    self.content.attributedText = attrStr;
    // 设置字体大小
    self.content.font = [UIFont systemFontOfSize:12];

    // 面积
    self.operatingarea.text = [@"作业面积：" stringByAppendingFormat:@"%0.2f亩",releaseTaskModel.operatingarea];
    
    // 最高限价
    self.limitedprice.text = [@"竞标最高限价：" stringByAppendingFormat:@"%0.2f元/亩",releaseTaskModel.limitedprice];
    
    // 总价
    self.totalprice.text = [@"总价：" stringByAppendingFormat:@"%0.2f元",releaseTaskModel.totalprice];
    
    // 预计工期
    self.timelimit.text = [NSString stringWithFormat:@"预计工期：%d天",releaseTaskModel.timelimit];
    
    // 开工时间
    self.starttime.text = [@"开工时间：" stringByAppendingString:[DateUtil timestampSwitchTime:releaseTaskModel.starttime andFormatter:@"YYYY-MM-dd"]];
    
    // 可接类型
    self.meetuser.text = [NSString stringWithFormat:@"%d星及以上用户可接",releaseTaskModel.needstar];
    
    // 参与人数
    self.participationnum.text = [NSString stringWithFormat:@"已有%d人参与投标",releaseTaskModel.participationnum];
    
    // 农场主：1竞标中、2作业中、3已结束
    // 农机主：1已投标、2作业中、3已结束
    switch (releaseTaskModel.curstatu) {
        case 1: // 竞标中
            if(self.regtype == 1){
                [self.curStatus setTitle:@"竞标中" forState:UIControlStateNormal];
            }else if (self.regtype == 2){
                [self.curStatus setTitle:@"已投标" forState:UIControlStateNormal];
                self.tenderBtn.hidden = YES; // 隐藏选标按钮
            }
            
            break;
            
        case 2: // 作业中
            if(self.regtype == 1){
                [self.curStatus setTitle:@"作业中..." forState:UIControlStateNormal];
                self.tenderBtn.hidden = YES; // 隐藏选标按钮
            }else if (self.regtype == 2){
                [self.tenderBtn setTitle:@"完成项目" forState:UIControlStateNormal];
            }
            break;
            
        case 3: // 已结束
            [self.curStatus setTitle:@"已结束" forState:UIControlStateNormal];
            NULLString(releaseTaskModel.comment) ? [self.tenderBtn setTitle:@"待评价" forState:UIControlStateNormal] : [self.tenderBtn setTitle:@"已评价" forState:UIControlStateNormal];
            break;
            
        case 4:
            [self.curStatus setTitle:@"等待接单" forState:UIControlStateNormal];
            if(self.regtype == 2){
                [self.tenderBtn setTitle:@"接下项目" forState:UIControlStateNormal];
            }
            break;
            
        default:
            break;
    }
    
}

+ (instancetype)releaseTaskCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"task";
    JLMineReleaseTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JLMineReleaseTaskCell" owner:nil options:nil]firstObject];
    }
    return cell;
}

- (IBAction)selectTender:(id)sender {
    JLLog(@"参与投标人数 == %d", _releaseTaskModel.participationnum);
    if(_releaseTaskModel.participationnum <= 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"暂无人投标，请浏览其它任务" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        if([self.delegate respondsToSelector:@selector(selectTenderClick:)]){
            [self.delegate selectTenderClick:_releaseTaskModel];
        }
    }
}
@end



































