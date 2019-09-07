//
//  HGSegmentedPageViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/1/3.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#import "HGSegmentedPageViewController.h"
#import "masonry.h"
#import "HGPersonalCenterExtendMacro.h"
#import "HGPopGestureCompatibleScrollView.h"

#define kWidth self.view.frame.size.width

@interface HGSegmentedPageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) HGCategoryView *categoryView;
@property (nonatomic, strong) HGPopGestureCompatibleScrollView *scrollView;
@property (nonatomic, strong) HGPageViewController *currentPageViewController;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) CGFloat whenBeginDraggingContentOffsetX;
@end

@implementation HGSegmentedPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.scrollView];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(self->_categoryView.height);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - Public Methods
- (void)makePageViewControllersScrollToTop {
    [self.pageViewControllers enumerateObjectsUsingBlock:^(HGPageViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj scrollToTop];
    }];
}

- (void)makePageViewControllersScrollState:(BOOL)canScroll {
    [self.pageViewControllers enumerateObjectsUsingBlock:^(HGPageViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.canScroll = canScroll;
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.whenBeginDraggingContentOffsetX = scrollView.contentOffset.x;
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerWillBeginDragging)]) {
        [self.delegate segmentedPageViewControllerWillBeginDragging];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = scrollView.contentOffset.x / kWidth;
    NSInteger leftPage = floor(scale);
    NSInteger rightPage = ceil(scale);
    
    if (scrollView.contentOffset.x > self.whenBeginDraggingContentOffsetX) { //向右切换
        if (leftPage == rightPage) {
            leftPage = rightPage - 1;
        }
        if (rightPage < self.pageViewControllers.count) {
            [self.categoryView scrollToTargetIndex:rightPage sourceIndex:leftPage percent:scale - leftPage];
        }
    } else { //向左切换
        if (leftPage == rightPage) {
            rightPage = leftPage + 1;
        }
        if (rightPage < self.pageViewControllers.count) {
            [self.categoryView scrollToTargetIndex:leftPage sourceIndex:rightPage percent:1 - (scale - leftPage)];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidEndDragging)]) {
        [self.delegate segmentedPageViewControllerDidEndDragging];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = (NSUInteger)(self.scrollView.contentOffset.x / kWidth);
    self.currentPageIndex = index;
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidEndDeceleratingWithPageIndex:)]) {
        [self.delegate segmentedPageViewControllerDidEndDeceleratingWithPageIndex:index];
    }
}

#pragma mark - Setters
- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    self.currentPageViewController = self.pageViewControllers[self.categoryView.originalIndex];
}

- (void)setPageViewControllers:(NSArray<HGPageViewController *> *)pageViewControllers {
    if (self.pageViewControllers.count > 0) {
        //remove pageViewControllers
        [self.pageViewControllers enumerateObjectsUsingBlock:^(HGPageViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj willMoveToParentViewController:nil];
            [obj.view removeFromSuperview];
            [obj removeFromParentViewController];
        }];
    }
    
    _pageViewControllers = pageViewControllers;
    
    //add pageViewControllers
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
    self.currentPageIndex = self.categoryView.originalIndex;
}

#pragma mark - Getters
- (HGCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[HGCategoryView alloc] init];
        _categoryView.userInteractionEnabled = NO;
        @weakify(self)
        _categoryView.selectedItemHelper = ^(NSUInteger index) {
            @strongify(self)
            [self.scrollView setContentOffset:CGPointMake(index * kWidth, 0) animated:NO];
            self.currentPageIndex = index;
        };
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

@end
