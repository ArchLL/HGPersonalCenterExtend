//
//  HGSegmentedPageViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/1/3.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#import "HGSegmentedPageViewController.h"
#import "masonry.h"
#import "HGPopGestureCompatibleScrollView.h"

#define kWidth self.view.frame.size.width

@interface HGSegmentedPageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) HGCategoryView *categoryView;
@property (nonatomic, strong) HGPopGestureCompatibleScrollView *scrollView;
@property (nonatomic) CGFloat whenBeginDraggingContentOffsetX;
@property (nonatomic) BOOL isDragging;
@end

@implementation HGSegmentedPageViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.scrollView];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.categoryView.height);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    _categoryView.selectedItemHandler = ^(NSUInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.isDragging = NO;
        [strongSelf.scrollView setContentOffset:CGPointMake(index * kWidth, 0) animated:NO];
        strongSelf.isDragging = YES;
    };
}

#pragma mark - Public Methods
- (void)makePageViewControllersScrollToTop {
    [self.pageViewControllers enumerateObjectsUsingBlock:^(HGPageViewController * _Nonnull controller, NSUInteger index, BOOL * _Nonnull stop) {
        [controller scrollToTop];
    }];
}

- (void)makePageViewControllersScrollState:(BOOL)canScroll {
    [self.pageViewControllers enumerateObjectsUsingBlock:^(HGPageViewController * _Nonnull controller, NSUInteger index, BOOL * _Nonnull stop) {
        controller.canScroll = canScroll;
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    scrollView.userInteractionEnabled = NO;
    self.whenBeginDraggingContentOffsetX = scrollView.contentOffset.x;
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerWillBeginDragging)]) {
        [self.delegate segmentedPageViewControllerWillBeginDragging];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isDragging) {
        return;
    }
    
    CGFloat scale = scrollView.contentOffset.x / kWidth;
    NSInteger leftPage = floor(scale);
    NSInteger rightPage = ceil(scale);
    
    if (scrollView.contentOffset.x > self.whenBeginDraggingContentOffsetX) { // 向右切换
        if (leftPage == rightPage) {
            leftPage = rightPage - 1;
        }
        if (rightPage < self.pageViewControllers.count) {
            [self.categoryView scrollToTargetIndex:rightPage sourceIndex:leftPage percent:scale - leftPage];
        }
    } else { // 向左切换
        if (leftPage == rightPage) {
            rightPage = leftPage + 1;
        }
        if (rightPage < self.pageViewControllers.count) {
            [self.categoryView scrollToTargetIndex:leftPage sourceIndex:rightPage percent:1 - (scale - leftPage)];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        scrollView.userInteractionEnabled = YES;
    }
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidEndDragging)]) {
        [self.delegate segmentedPageViewControllerDidEndDragging];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = (NSUInteger)(self.scrollView.contentOffset.x / kWidth);
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidEndDeceleratingWithPageIndex:)]) {
        [self.delegate segmentedPageViewControllerDidEndDeceleratingWithPageIndex:index];
    }
}

#pragma mark - Setters
- (void)setPageViewControllers:(NSArray<HGPageViewController *> *)pageViewControllers {
    if (self.pageViewControllers.count > 0) {
        // remove pageViewControllers
        [self.pageViewControllers enumerateObjectsUsingBlock:^(HGPageViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj willMoveToParentViewController:nil];
            [obj.view removeFromSuperview];
            [obj removeFromParentViewController];
        }];
    }
    
    _pageViewControllers = pageViewControllers;
    
    // add pageViewControllers
    [self.pageViewControllers enumerateObjectsUsingBlock:^(HGPageViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:obj];
        [self.scrollView addSubview:obj.view];
        [obj didMoveToParentViewController:self];
        [obj.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(idx * kWidth);
            make.top.width.height.equalTo(self.scrollView);
        }];
    }];
    
    self.scrollView.contentSize = CGSizeMake(kWidth * self.pageViewControllers.count, 0);
    self.categoryView.userInteractionEnabled = YES;
}

#pragma mark - Getters
- (HGCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[HGCategoryView alloc] init];
        _categoryView.userInteractionEnabled = NO;
    }
    return _categoryView;
}

- (HGPopGestureCompatibleScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[HGPopGestureCompatibleScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (NSInteger)currentPageIndex {
    return self.categoryView.selectedIndex;
}

- (UIViewController *)currentPageViewController {
    return self.pageViewControllers[self.categoryView.selectedIndex];
}

@end
