//
//  HGBasePageViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "HGPageViewController.h"

@interface HGPageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) BOOL canScroll;
@end

@implementation HGPageViewController
#pragma mark - Private Methods
- (void)makePageViewControllerScroll:(BOOL)canScroll {
    self.canScroll = canScroll;
    self.scrollView.showsVerticalScrollIndicator = canScroll;
}

- (void)makePageViewControllerScrollToTop {
    [self.scrollView setContentOffset:CGPointZero];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        self.canScroll = NO;
        self.scrollView.contentOffset = CGPointZero;
        self.scrollView.showsVerticalScrollIndicator = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewControllerLeaveTop)]) {
            [self.delegate pageViewControllerLeaveTop];
        }
    }
    self.scrollView = scrollView;
}

@end
