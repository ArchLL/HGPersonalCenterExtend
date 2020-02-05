//
//  HGPersonalCenterExtendViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "HGPersonalCenterViewController.h"
#import "HGPersonalCenterHeaderView.h"
#import "HGDoraemonCell.h"
#import "HGFirstViewController.h"
#import "HGSecondViewController.h"
#import "HGThirdViewController.h"
#import "HGMessageViewController.h"

@interface HGPersonalCenterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HGAlignmentAdjustButton *messageButton;
@end

@implementation HGPersonalCenterViewController

#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupHeaderView];
    [self setupTableView];
    // 也可以在请求数据成功后设置pageViewControllers
    [self setupPageViewControllers];
}

#pragma mark - Private Methods
- (void)setupNavigationBar {
    self.isHiddenNavigationBarBottomBorder = YES;
    [self setNavigationBarAlpha:0];
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:self.messageButton];
    self.navigationItem.rightBarButtonItem = messageItem;
}

- (void)viewMessage {
    HGMessageViewController *vc = [[HGMessageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupHeaderView {
    self.headerView = [[HGPersonalCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HGDoraemonCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HGDoraemonCell class])];
}

/**设置segmentedPageViewController的pageViewControllers和categoryView
 * 这里用到的pageViewController需要继承自HGPageViewController
 */
- (void)setupPageViewControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    NSArray *titles = @[@"主页", @"动态", @"关注", @"粉丝"];
    for (int i = 0; i < titles.count; i++) {
        HGPageViewController *controller;
        if (i % 3 == 0) {
            controller = [[HGThirdViewController alloc] init];
        } else if (i % 2 == 0) {
            controller = [[HGSecondViewController alloc] init];
        } else {
            controller = [[HGFirstViewController alloc] init];
        }
        [controllers addObject:controller];
    }
    self.segmentedPageViewController.pageViewControllers = controllers;
    // 设置categoryView的样式，可以自定义分布方式(左、中、右)、高度、背景颜色、字体颜色、字体大小、下划线高度和颜色等
    self.segmentedPageViewController.categoryView.backgroundColor = [UIColor yellowColor];
    self.segmentedPageViewController.categoryView.titles = titles;
    self.segmentedPageViewController.categoryView.alignment = HGCategoryViewAlignmentLeft;
    self.segmentedPageViewController.categoryView.originalIndex = self.selectedIndex;
    self.segmentedPageViewController.categoryView.itemSpacing = 30;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HGDoraemonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HGDoraemonCell class]) forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor yellowColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"哆啦A梦";
    label.textColor = [UIColor redColor];
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 10, 15, 10));
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Getters
- (HGAlignmentAdjustButton *)messageButton {
    if (!_messageButton) {
        _messageButton = [HGAlignmentAdjustButton buttonWithType:UIButtonTypeCustom];
        [_messageButton setTitle:@"消息" forState:UIControlStateNormal];
        [_messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _messageButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_messageButton addTarget:self action:@selector(viewMessage) forControlEvents:UIControlEventTouchUpInside];
        [_messageButton sizeToFit];
    }
    return _messageButton;
}

@end

