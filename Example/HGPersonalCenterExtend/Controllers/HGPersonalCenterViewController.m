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
#import "HGPersonalCenterExtend.h"

CGFloat const headerViewHeight = 240;

@interface HGPersonalCenterViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, HGSegmentedPageViewControllerDelegate, HGPageViewControllerDelegate>
@property (nonatomic, strong) HGAlignmentAdjustButton *messageButton;
@property (nonatomic, strong) HGCenterBaseTableView *tableView;
@property (nonatomic, strong) HGPersonalCenterHeaderView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic) BOOL cannotScroll;

@end

@implementation HGPersonalCenterViewController

#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //解决pop手势中断后tableView偏移问题
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [self setupNavigationBar];
    [self setupSubViews];
    //可以在请求数据成功后设置/改变pageViewControllers, 但是要保证titles.count=pageViewControllers.count
    [self setupPageViewControllers];
}

#pragma mark - Private Methods
- (void)setupNavigationBar {
    self.isHiddenBottomBorder = YES;
    [self setNavigationBarAlpha:0];
    
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:self.messageButton];
    self.navigationItem.rightBarButtonItem = messageItem;
}

- (void)setupSubViews {
    [self.view addSubview:self.tableView];
    [self addChildViewController:self.segmentedPageViewController];
    [self.footerView addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController didMoveToParentViewController:self];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
}

/**设置segmentedPageViewController的pageViewControllers和categoryView
 * 这里可以对categoryView进行自定义，包括分布方式(左、中、右)、高度、背景颜色、字体颜色、字体大小、下划线高度和颜色等
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
        controller.delegate = self;
        [controllers addObject:controller];
    }
    _segmentedPageViewController.pageViewControllers = controllers;
    _segmentedPageViewController.categoryView.backgroundColor = [UIColor yellowColor];
    _segmentedPageViewController.categoryView.titles = titles;
    _segmentedPageViewController.categoryView.alignment = HGCategoryViewAlignmentLeft;
    _segmentedPageViewController.categoryView.originalIndex = self.selectedIndex;
    _segmentedPageViewController.categoryView.itemSpacing = 30;
}

- (void)changeNavigationBarAlpha {
    CGFloat alpha = 0;
    if (self.tableView.contentOffset.y - (headerViewHeight - TOP_BAR_HEIGHT) < FLT_EPSILON) {
        alpha = self.tableView.contentOffset.y / (headerViewHeight - TOP_BAR_HEIGHT);
    } else {
        alpha = 1;
    }
    [self setNavigationBarAlpha:alpha];
}

- (void)viewMessage {
    HGMessageViewController *vc = [[HGMessageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self.segmentedPageViewController makePageViewControllersScrollToTop];
    return YES;
}

/**
 * 处理联动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //第一部分：更改导航栏颜色
    [self changeNavigationBarAlpha];
    
    //第二部分：处理scrollView滑动冲突
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //吸顶临界点(此时的临界点不是视觉感官上导航栏的底部，而是当前屏幕的顶部相对scrollViewContentView的位置)
    //如果底部存在TabBar/ToolBar, 还需要减去TabBarHeight/ToolBarHeight(自定义的Bar)和SAFE_AREA_INSERTS_BOTTOM
    CGFloat criticalPointOffsetY = scrollView.contentSize.height - SCREEN_HEIGHT;
    
    // 利用contentOffset处理内外层scrollView的滑动冲突问题
    if (contentOffsetY - criticalPointOffsetY >= FLT_EPSILON) {
        /*
         * 到达临界点：
         * 1.未吸顶状态 -> 吸顶状态
         * 2.维持吸顶状态 (pageViewController.scrollView.contentOffsetY > 0)
         */
        //“进入吸顶状态”以及“维持吸顶状态”
        self.cannotScroll = YES;
        scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        [self.segmentedPageViewController makePageViewControllersScrollState:YES];
    } else {
        /*
         * 未达到临界点：
         * 1.维持吸顶状态 (pageViewController.scrollView.contentOffsetY > 0)
         * 2.吸顶状态 -> 不吸顶状态
         */
        if (self.cannotScroll) {
            //“维持吸顶状态”
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        } else {
            /* 吸顶状态 -> 不吸顶状态
             * categoryView的子控制器的tableView或collectionView在竖直方向上的contentOffsetY小于等于0时，会通过代理的方式改变当前控制器self.canScroll的值；
             */
        }
    }
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

#pragma mark - HGSegmentedPageViewControllerDelegate
- (void)segmentedPageViewControllerWillBeginDragging {
    self.tableView.scrollEnabled = NO;
}

- (void)segmentedPageViewControllerDidEndDragging {
    self.tableView.scrollEnabled = YES;
}

#pragma mark - HGPageViewControllerDelegate
- (void)pageViewControllerLeaveTop {
    [self.segmentedPageViewController makePageViewControllersScrollToTop];
    self.cannotScroll = NO;
}

#pragma mark - Lazy
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

- (HGPersonalCenterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HGPersonalCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerViewHeight)];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        //如果当前控制器存在TabBar/ToolBar, 还需要减去TabBarHeight/ToolBarHeight(自定义的Bar)和SAFE_AREA_INSERTS_BOTTOM
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_BAR_HEIGHT)];
    }
    return _footerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[HGCenterBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HGDoraemonCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HGDoraemonCell class])];
    }
    return _tableView;
}

- (HGSegmentedPageViewController *)segmentedPageViewController {
    if (!_segmentedPageViewController) {
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
        _segmentedPageViewController.delegate = self;
    }
    return _segmentedPageViewController;
}

@end

