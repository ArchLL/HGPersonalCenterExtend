//
//  HGSecondViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "HGSecondViewController.h"

static NSString *const SecondViewControllerTableVIewCellIdentifier = @"SecondViewControllerTableVIewCell";

@interface HGSecondViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation HGSecondViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SecondViewControllerTableVIewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"爱晚起，也爱工作到深夜 Row: %@", @(indexPath.row)];
    cell.imageView.image = [UIImage imageNamed:@"cartoon.jpg"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SecondViewControllerTableVIewCellIdentifier];
    }
    return _tableView;
}

@end
