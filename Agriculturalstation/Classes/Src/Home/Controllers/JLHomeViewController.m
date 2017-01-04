//
//  JLHomeViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/13.
//  Copyright © 2016年 chw. All rights reserved.
//

#import "JLHomeViewController.h"

@interface JLHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView{
    [super loadView];
    
    // 添加collectionView
    [self.view addSubview:self.collectionView];
}

// 懒加载collectionView
- (UICollectionView *)collectionView{
    if(!_collectionView){
//        _collectionView = [UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:[]
    }
    return _collectionView;
}

@end










































