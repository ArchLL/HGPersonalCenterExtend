//
//  CentersegmentHeaderView.m
//  PersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "SegmentView.h"
#import "SegmentHeaderView.h"

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height

@interface SegmentView () <UIScrollViewDelegate>
@property (nonatomic, strong) SegmentHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

@implementation SegmentView
#pragma mark - Life
- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray parentController:(UIViewController *)parentController {
    if ( self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        self.headerView = [[SegmentHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, SegmentHeaderViewHeight) titleArray:titleArray];
        [self addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(SegmentHeaderViewHeight);
        }];
        __weak  typeof(self) weakSelf = self;
        weakSelf.headerView.selectedItemHelper = ^(NSUInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.contentScrollView setContentOffset:CGPointMake(index * kWidth, 0) animated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:CurrentSelectedChildViewControllerIndex object:nil userInfo:@{@"selectedPageIndex" : @(index)}];
        };
        
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SegmentHeaderViewHeight, kWidth, kHeight - SegmentHeaderViewHeight)];
        self.contentScrollView.contentSize = CGSizeMake(kWidth * controllers.count, 0);
        self.contentScrollView.delegate = self;
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView.pagingEnabled = YES;
        self.contentScrollView.bounces = NO;
        [self addSubview:self.contentScrollView];
        
        [controllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *controller = obj;
            [self.contentScrollView addSubview:controller.view];
            controller.view.frame = CGRectMake(idx * kWidth, 0, kWidth, kHeight);
            [parentController addChildViewController:controller];
            [controller didMoveToParentViewController:parentController];
        }];
    }
    return self;
}

#pragma mark - Setter
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    self.headerView.selectedIndex =  selectedIndex;
    [[NSNotificationCenter defaultCenter] postNotificationName:CurrentSelectedChildViewControllerIndex object:nil userInfo:@{@"selectedPageIndex" : @(selectedIndex)}];
}

#pragma mark - UIScrollViewDelegate
//增加分页视图左右滑动和外界tableView上下滑动互斥处理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:IsEnablePersonalCenterVCMainTableViewScroll object:nil userInfo:@{@"canScroll" : @"0"}];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[NSNotificationCenter defaultCenter] postNotificationName:IsEnablePersonalCenterVCMainTableViewScroll object:nil userInfo:@{@"canScroll" : @"1"}];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger selectedIndex = (NSUInteger)(self.contentScrollView.contentOffset.x / kWidth);
    [self.headerView changeItemWithTargetIndex:selectedIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:CurrentSelectedChildViewControllerIndex object:nil userInfo:@{@"selectedPageIndex" : @(selectedIndex)}];
}

@end
