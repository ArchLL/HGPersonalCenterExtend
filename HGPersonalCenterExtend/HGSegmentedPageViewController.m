//
//  HGSegmentedPageViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/1/3.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#import "HGSegmentedPageViewController.h"
#import "HGPagesViewController.h"
#import "masonry.h"

#define kWidth self.view.frame.size.width

@interface HGSegmentedPageViewController () <HGCategoryViewDelegate, HGPagesViewControllerDelegate>
@property (nonatomic, strong) HGCategoryView *categoryView;
@property (nonatomic, strong) HGPagesViewController *pagesViewController;
@end

@implementation HGSegmentedPageViewController
@synthesize originalPage = _originalPage;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.categoryView];
    [self addChildViewController:self.pagesViewController];
    [self.view addSubview:self.pagesViewController.view];
    [self.pagesViewController didMoveToParentViewController:self];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.categoryView.height);
    }];
    [self.pagesViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Public Methods
- (void)makePageViewControllersScrollToTop {
    [self.pagesViewController makeViewControllersScrollToTop];
}

- (void)makePageViewControllersScrollState:(BOOL)canScroll {
    [self.pageViewControllers enumerateObjectsUsingBlock:^(HGPageViewController * _Nonnull controller, NSUInteger index, BOOL * _Nonnull stop) {
        controller.canScroll = canScroll;
    }];
}

#pragma mark - HGCategoryViewDelegate
- (void)categoryViewDidSelectedItemAtIndex:(NSInteger)index {
    self.pagesViewController.selectedPage = index;
}

#pragma mark - HGPagesViewControllerDelegate
- (void)pagesViewControllerLeaveTop {
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerLeaveTop)]) {
        [self.delegate segmentedPageViewControllerLeaveTop];
    }
}

- (void)pagesViewControllerWillBeginDragging {
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerWillBeginDragging)]) {
        [self.delegate segmentedPageViewControllerWillBeginDragging];
    }
}

- (void)pagesViewControllerDidEndDragging {
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidEndDragging)]) {
        [self.delegate segmentedPageViewControllerDidEndDragging];
    }
}

- (void)pagesViewControllerScrollingToTargetPage:(NSInteger)targetPage sourcePage:(NSInteger)sourcePage percent:(CGFloat)percent {
    [self.categoryView scrollToTargetIndex:targetPage sourceIndex:sourcePage percent:percent];
}

- (void)pagesViewControllerWillTransitionToPage:(NSInteger)page {
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerWillTransitionToPage:)]) {
        [self.delegate segmentedPageViewControllerWillTransitionToPage:page];
    }
}

- (void)pagesViewControllerDidTransitionToPage:(NSInteger)page {
    if ([self.delegate respondsToSelector:@selector(segmentedPageViewControllerDidTransitionToPage:)]) {
        [self.delegate segmentedPageViewControllerDidTransitionToPage:page];
    }
}

#pragma mark - Setters
- (void)setPageViewControllers:(NSArray<HGPageViewController *> *)pageViewControllers {
    _pageViewControllers = pageViewControllers;
    self.pagesViewController.viewControllers = pageViewControllers;
}

- (void)setOriginalPage:(NSInteger)originalPage {
    _originalPage = originalPage;
    self.categoryView.originalIndex = originalPage;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    self.pagesViewController.collectionView.scrollEnabled = scrollEnabled;
}

#pragma mark - Getters
- (HGCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[HGCategoryView alloc] init];
        _categoryView.delegate = self;
    }
    return _categoryView;
}

- (HGPagesViewController *)pagesViewController {
    if (!_pagesViewController) {
        _pagesViewController = [[HGPagesViewController alloc] init];
        _pagesViewController.delegate = self;
    }
    return _pagesViewController;
}

- (NSInteger)originalPage {
    return self.categoryView.originalIndex;
}

- (NSInteger)selectedPage {
    return self.categoryView.selectedIndex;
}

- (HGPageViewController *)selectedPageViewController {
    return self.pagesViewController.selectedPageViewController;
}

@end
