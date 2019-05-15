//
//  HGHomeViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "HGHomeViewController.h"
#import "HGPersonalCenterViewController.h"

@interface HGHomeViewController ()
@property (nonatomic, strong) UIButton *nextButton;
@end

@implementation HGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self setupSubViews];
}

#pragma mark Private Methods
- (void)setupSubViews {
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(200);
    }];
}

- (void)enterCenter {
    HGPersonalCenterViewController *vc = [[HGPersonalCenterViewController alloc] init];
    vc.selectedIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Getters
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.backgroundColor = kRGBA(28, 162, 223, 1.0);
        [_nextButton setTitle:@"进入个人中心" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(enterCenter) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

@end
