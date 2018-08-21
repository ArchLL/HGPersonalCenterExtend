//
//  RootViewController.m
//  PersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "RootViewController.h"
#import "PersonalCenterViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//进入个人中心
- (IBAction)enterCenterAction:(UIButton *)sender {
    PersonalCenterViewController *personalCenterVC = [[PersonalCenterViewController alloc]init];
    personalCenterVC.selectedIndex = 0;
    [self.navigationController pushViewController:personalCenterVC animated:YES];
}

@end
