//
//  HGHomeViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "HGHomeViewController.h"
#import "HGPersonalCenterViewController.h"

@implementation HGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//进入个人中心
- (IBAction)enterCenterAction:(UIButton *)sender {
    HGPersonalCenterViewController *vc = [[HGPersonalCenterViewController alloc] init];
    vc.selectedIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
