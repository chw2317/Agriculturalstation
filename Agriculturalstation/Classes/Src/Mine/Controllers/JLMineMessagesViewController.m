//
//  JLMineMessagesViewController.m
//  Agriculturalstation
//
//  Created by chw on 16/12/16.
//  Copyright © 2016年 chw. All rights reserved.
//

  // 我的消息

#import "JLMineMessagesViewController.h"
#import "MJExtension.h"
#import "JLMineMessageModel.h"

@interface JLMineMessagesViewController ()

@end

@implementation JLMineMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self json2object:@"[{\"ID\":1,\"title\":\"陈汉文\",\"time\":\"123456478\",\"content\":\"案发时发生发生法撒旦法师打发是否是飞洒发士大夫撒旦法是的范德萨发撒飞洒地方是沙发沙发士大夫撒旦师傅师傅说到底发生士大夫撒飞洒的\"},{\"ID\":2,\"title\":\"陈汉文2\",\"time\":\"1234564782\",\"content\":\"案发时发生发生法撒旦法师打发是否是飞洒发士大夫撒旦法是的范德萨发撒飞洒地方是沙发沙发士大夫撒旦师傅师傅说到底发生士大夫撒飞洒的2\"}]"];
}

// 将json数组转化为模型对象
-(void)json2object:(NSString *)json_data{
    NSLog(@"json_data=%@",json_data);
    
    // 1. NSString --> NSData
    NSData *data = [json_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2. NSData --> NSDictionary
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    // 3. 将字典数组转为JLMineMessageModel模型数组
    NSArray *messageArray = [JLMineMessageModel mj_objectArrayWithKeyValuesArray:jsonObject];
    
    NSLog(@"messageArray.count=%d",messageArray.count);
    
    // 打印messageArray数组中的JLMineMessage模型属性
    for(JLMineMessageModel *message in messageArray){
        NSLog(@"ID=%d, title=%@, time=%@, content=%@", message.ID, message.title, message.time, message.content);
    }
}

@end






















































