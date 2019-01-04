//
//  HGSegmentViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/1/3.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#import "HGSegmentViewController.h"
#import "HGCategoryView.h"

#define kWidth self.view.frame.size.width

@interface HGSegmentViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) HGCategoryView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation HGSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.scrollView];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(HGCategoryViewHeight);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self.pageViewControllers enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *controller = obj;
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(idx * kWidth);
            make.top.width.height.equalTo(self.scrollView);
        }];
    }];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.categoryView.selectedItemHelper = ^(NSUInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //滚动到指定子控制器
        [strongSelf.scrollView setContentOffset:CGPointMake(index * kWidth, 0) animated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:CurrentSelectedChildViewControllerIndex object:nil userInfo:@{@"selectedPageIndex": @(index)}];
    };
}

#pragma mark - UIScrollViewDelegate
//增加分页视图左右滑动和外界tableView上下滑动互斥处理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:IsEnablePersonalCenterVCMainTableViewScroll object:nil userInfo:@{@"canScroll": @"0"}];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[NSNotificationCenter defaultCenter] postNotificationName:IsEnablePersonalCenterVCMainTableViewScroll object:nil userInfo:@{@"canScroll": @"1"}];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger selectedIndex = (NSUInteger)(self.scrollView.contentOffset.x / kWidth);
    [self.categoryView changeItemWithTargetIndex:selectedIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:CurrentSelectedChildViewControllerIndex object:nil userInfo:@{@"selectedPageIndex": @(selectedIndex)}];
}

#pragma mark - Getters
- (HGCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[HGCategoryView alloc] init];
    }
    return _categoryView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(kWidth * self.pageViewControllers.count, 0);
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
@end
