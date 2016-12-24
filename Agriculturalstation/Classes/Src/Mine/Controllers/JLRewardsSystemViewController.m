//
//  JLRewardsSystemViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

// 奖罚制度

#import "JLRewardsSystemViewController.h"

@interface JLRewardsSystemViewController (){
    // 在私有扩展中创建一个属性
    UIScrollView *_scrollView;
}

@end

@implementation JLRewardsSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

// 初始化视图
-(void)initView{
    // 1.创建UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    // frame中的size指UIScrollView的可视范围
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    
    // 创建标题Label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 25)];
    titleLabel.text = @"奖罚制度";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:titleLabel];
    
    // 创建内容Label
    UILabel *contentLabel = [[UILabel alloc]init];
    [scrollView addSubview:contentLabel];
    //
    contentLabel.text = @"2016年石墨烯产业·技术高峰论坛于8月22日至24日在广西南宁举办。中国科学院院士成会明表示，目前面临的最大挑战是如何实现高品质石墨烯材料和大型单晶石墨烯大规模制造，这对于石墨烯的广泛应用和器件应用至关重要。为了实现石墨烯材料的商业化，团队研发了插高温膨胀－液相剥离和电化学剥离工序，从而实现高品质石墨烯材料的大规模生产。该技术将广泛应用于复合材料、能源储备和导电油墨等领域。[全文]中国科学家在《自然·纳米技术》杂志上发表论文称，他们在单晶石墨烯制备上取得了一项突破。通过对化学气相沉积法（CVD的调整和改进他们将石墨烯薄膜生产的速度提高了150倍新研究为石墨烯的大规模应用奠定了基础[全文]7月22日全球第一台使用石墨烯作为车身材料的汽车在曼彻斯特亮相这辆汽车是由利物浦的Briggs汽车公司制造的[全文]常州瑞丰特科技有限公司低温等离子体辅助卷对卷石墨烯薄膜连续生产线建成仪式，日前在西太湖科技产业园举行。[全文]自2004年英国科学家首次从石墨晶体表面“粘”出石墨烯以来，这一拥有导热导电性超强等诸多“绝技”的新材料之王让人们对其产业化前景无限憧憬。[全文]石墨烯在中国正成为“科技宠儿”，不少人期待这一“神奇材料”继续书写“科技改变生活”的下一个故事。作为一种技术含量高、应用潜力广泛的碳材料，石墨烯也逐渐被应用于新能源开发中。[全文]16日从中加石墨烯产业及应用研讨会上获悉，石墨烯有望入选“十三五”新材料重大专项，石墨烯研发及产业化也会在“十三五”科技发展规划中占据一定的位置。[全文]为培育壮大石墨烯产业，加快石墨烯材料规模化生产和产业化应用，工业和信息化部原材料工业司日前在北京组织召开石墨烯产业发展座谈会，研讨了拟建石墨烯创新中心的使命功能定位和组建运营模式。[全文]日前《石墨烯材料的术语、定义及代号》国家标准（征求意见稿）在中国国家标准化管理委员会官网正式公布。这标志着我国首个石墨烯国家标准制定取得重要进展。目前，全球石墨烯产业正处于早期研究向中期应用转变的阶段。2014年我国从事石墨烯产业的企业已突破千家，石墨烯产业链市场规模达到233.3亿元，产业化应用已在不断推进，未来空间依然广阔。[全文]备受业界关注的《石墨烯材料的术语、定义及代号》国家标准（征求意见稿）5日在中国国家标准化管理委员会官网正式公布，并将在一个月内向社会公开征求意见。这标志着我国首个石墨烯国家标准制定取得重要进展";
    
    // 根据获取到的字符串以及字体计算label需要的size（第二种方法）
    contentLabel.font = [UIFont systemFontOfSize:14];
    NSDictionary *attrilbute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize contentSize = [contentLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrilbute context:nil].size;
    // 设置无限换行
    contentLabel.numberOfLines = 0;
    // 设置label的frame
    contentLabel.frame = CGRectMake(10, 60, contentSize.width, contentSize.height);
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentSize.height + 150);

    /** 第一种计算需要显示的文本高度的方法  */
//    contentLabel.numberOfLines = 0;
//    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 20, 9999);
//    CGSize expectSize = [contentLabel sizeThatFits:maxSize];
//    contentLabel.frame = CGRectMake(10, 60, expectSize.width, expectSize.height);
//    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, expectSize.height + 200);
    

    // 隐藏水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView = scrollView;
}

@end













































