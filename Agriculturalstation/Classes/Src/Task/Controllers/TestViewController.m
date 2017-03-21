//
//  TestViewController.m
//  Agriculturalstation
//
//  Created by chw on 17/2/10.
//  Copyright © 2017年 chw. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()
@property (strong, nonatomic) IBOutlet UIView *hiddenview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *hiddenViewH;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *hiddenViewW;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hiddenViewH.constant = 0;
    self.hiddenViewW.constant = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
