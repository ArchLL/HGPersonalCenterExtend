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
@property (nonatomic) NSInteger selectedIndex;
@end

@implementation HGSegmentedPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPageViewController = self.pageViewControllers[self.categoryView.originalIndex];
    self.selectedIndex = self.categoryView.originalIndex;
    [self setupViews];
}

- (void)setupViews {
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
    [self.pageViewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:obj];
        [self.scrollView addSubview:obj.view];
        [obj didMoveToParentViewController:self];
        [obj.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(idx * kWidth);
            make.top.width.height.equalTo(self.scrollView);
        }];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerWillBeginDragging)]) {
        [self.delegate segmentedPageViewControllerWillBeginDragging];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidEndDragging)]) {
        [self.delegate segmentedPageViewControllerDidEndDragging];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = (NSUInteger)(self.scrollView.contentOffset.x / kWidth);
    [self.categoryView changeItemToTargetIndex:index];
    self.currentPageViewController = self.pageViewControllers[index];
    self.selectedIndex = index;
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidEndDeceleratingWithPageIndex:)]) {
        [self.delegate segmentedPageViewControllerDidEndDeceleratingWithPageIndex:index];
    }
}

#pragma mark - Getters
- (HGCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[HGCategoryView alloc] init];
        @weakify(self)
        _categoryView.selectedItemHelper = ^(NSUInteger index) {
            @strongify(self)
            [self.scrollView setContentOffset:CGPointMake(index * kWidth, 0) animated:NO];
            self.currentPageViewController = self.pageViewControllers[index];
            self.selectedIndex = index;
        };
    }
    return _categoryView;
}

- (HGPopGestureCompatibleScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[HGPopGestureCompatibleScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(kWidth * self.pageViewControllers.count, 0);
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

@end
