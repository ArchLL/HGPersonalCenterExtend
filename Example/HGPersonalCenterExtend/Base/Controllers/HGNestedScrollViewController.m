//
//  HGNestedScrollViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2020/1/16.
//  Copyright © 2020 mint_bin@163.com. All rights reserved.
//

#import "HGNestedScrollViewController.h"
static CGFloat const headerViewHeight = 240;

@interface HGNestedScrollViewController ()
@property (nonatomic, strong) HGCenterBaseTableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic) BOOL cannotScroll;
@end

@implementation HGNestedScrollViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // 解决pop手势中断后tableView偏移问题
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self setupSubViews];
}

#pragma mark - Private Methods
- (void)setupSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self addChildViewController:self.segmentedPageViewController];
    [self.footerView addSubview:self.segmentedPageViewController.view];
    [self.segmentedPageViewController didMoveToParentViewController:self];
    [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
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

#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self.segmentedPageViewController makePageViewControllersScrollToTop];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 第一部分：更改导航栏颜色
    [self changeNavigationBarAlpha];
    
    // 第二部分：处理scrollView滑动冲突
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    // 吸顶临界点(此时的临界点不是视觉感官上导航栏的底部，而是当前屏幕的顶部相对scrollViewContentView的位置)
    // 如果当前控制器底部存在TabBar/ToolBar/自定义的bottomBar, 还需要减去barHeight和SAFE_AREA_INSERTS_BOTTOM的高度
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
            // “维持吸顶状态”
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        } else {
            /* 吸顶状态 -> 不吸顶状态
             * categoryView的子控制器的tableView或collectionView在竖直方向上的contentOffsetY小于等于0时，会通过代理的方式改变当前控制器self.canScroll的值；
             */
        }
    }
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

#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[HGCenterBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        // 如果当前控制器底部存在TabBar/ToolBar/自定义的bottomBar, 还需要减去barHeight和SAFE_AREA_INSERTS_BOTTOM的高度
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_BAR_HEIGHT)];
    }
    return _footerView;
}

- (HGSegmentedPageViewController *)segmentedPageViewController {
    if (!_segmentedPageViewController) {
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
        _segmentedPageViewController.delegate = self;
    }
    return _segmentedPageViewController;
}

@end
