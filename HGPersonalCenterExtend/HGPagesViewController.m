//
//  HGPagesViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/11/13.
//

#import "HGPagesViewController.h"
#import "HGPageViewController.h"
#import "HGPopGestureCompatibleCollectionView.h"
#import "Masonry.h"

#define kWidth self.view.frame.size.width

static NSString * const HGPagesViewControllerCellIdentifier = @"HGPagesViewControllerCell";

@interface HGPagesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, HGPageViewControllerDelegate>
@property (nonatomic, strong) HGPopGestureCompatibleCollectionView *collectionView;
@property (nonatomic) BOOL isInitialScroll;
@property (nonatomic) CGFloat contentOffsetXWhenBeginDragging;
@end

@implementation HGPagesViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.isInitialScroll) {
        self.selectedPage = self.originalPage;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isInitialScroll = YES;
}

#pragma mark - Public Methods
- (void)makeViewControllersScrollToTop {
    [self.viewControllers enumerateObjectsUsingBlock:^(HGPageViewController * _Nonnull controller, NSUInteger index, BOOL * _Nonnull stop) {
        [controller scrollToTop];
    }];
}

- (void)setSelectedPage:(NSInteger)selectedPage animated:(BOOL)animated {
    _selectedPage = [self getRightPage:selectedPage];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedPage inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:animated];
}

#pragma mark - Private Methods
- (NSInteger)getRightPage:(NSInteger)page {
    if (page <= 0) {
        return 0;
    } else if (page >= self.viewControllers.count) {
        return self.viewControllers.count - 1;
    } else {
        return page;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HGPagesViewControllerCellIdentifier forIndexPath:indexPath];
    HGPageViewController *viewController = self.viewControllers[indexPath.item];
    [self addChildViewController:viewController];
    [cell.contentView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewControllers[self.selectedPage] viewWillDisappear:YES];
    [self.viewControllers[indexPath.item] viewWillAppear:YES];
    
    if ([self.delegate respondsToSelector:@selector(pagesViewControllerWillTransitionToPage:)]) {
        [self.delegate pagesViewControllerWillTransitionToPage:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewControllers[indexPath.item] viewDidDisappear:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.contentOffsetXWhenBeginDragging = scrollView.contentOffset.x;
    if ([self.delegate respondsToSelector:@selector(pagesViewControllerWillBeginDragging)]) {
        [self.delegate pagesViewControllerWillBeginDragging];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(pagesViewControllerDidEndDragging)]) {
        [self.delegate pagesViewControllerDidEndDragging];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(pagesViewControllerScrollingToTargetPage:sourcePage:percent:)]) {
        
        CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
        NSInteger leftPage = floor(scale);
        NSInteger rightPage = ceil(scale);
        
        if (scrollView.contentOffset.x > self.contentOffsetXWhenBeginDragging) { // 向右切换
            if (leftPage == rightPage) {
                leftPage = rightPage - 1;
            }
            if (rightPage < self.viewControllers.count) {
                [self.delegate pagesViewControllerScrollingToTargetPage:rightPage sourcePage:leftPage percent:scale - leftPage];
            }
        } else { // 向左切换
            if (leftPage == rightPage) {
                rightPage = leftPage + 1;
            }
            if (rightPage < self.viewControllers.count) {
                [self.delegate pagesViewControllerScrollingToTargetPage:leftPage sourcePage:rightPage percent:1 - (scale - leftPage)];
            }
        }
    }
    
    // 防止连续快速滑动
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation:) object:nil];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation:) object:nil];
    
    if ([self.collectionView indexPathsForVisibleItems].count == 1) {
        _selectedPage = [[self.collectionView indexPathsForVisibleItems] firstObject].item;
        if ([self.delegate respondsToSelector:@selector(pagesViewControllerDidTransitionToPage:)]) {
            [self.delegate pagesViewControllerDidTransitionToPage: self.selectedPage];
        }
    }
}

#pragma mark - HGPageViewControllerDelegate
- (void)pageViewControllerLeaveTop {
    [self makeViewControllersScrollToTop];
    if ([self.delegate respondsToSelector:@selector(pagesViewControllerLeaveTop)]) {
        [self.delegate pagesViewControllerLeaveTop];
    }
}

#pragma mark - Getters
- (UICollectionViewFlowLayout *)layout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}

- (HGPopGestureCompatibleCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[HGPopGestureCompatibleCollectionView alloc] initWithFrame:CGRectZero
                                                                 collectionViewLayout:[self layout]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:HGPagesViewControllerCellIdentifier];
    }
    return _collectionView;
}

#pragma mark - Setters
- (void)setViewControllers:(NSArray<HGPageViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    [self.viewControllers enumerateObjectsUsingBlock:^(HGPageViewController * _Nonnull pageViewController, NSUInteger idx, BOOL * _Nonnull stop) {
        pageViewController.delegate = self;
    }];
    [self.collectionView reloadData];
}

- (void)setOriginalPage:(NSInteger)originalPage {
    _originalPage = [self getRightPage:originalPage];
}

- (void)setSelectedPage:(NSInteger)selectedPage {
    [self setSelectedPage:selectedPage animated:self.isInitialScroll && (labs(_selectedPage - selectedPage) == 1)];
}

- (HGPageViewController *)selectedPageViewController {
    return self.viewControllers[self.selectedPage];
}

@end

