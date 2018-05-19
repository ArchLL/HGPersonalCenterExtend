//
//  SegmentViewController.m
//  PersonalCenter
//
//  Created by 中资北方 on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "SegmentViewController.h"

@interface SegmentViewController () <UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView * scrollView;
@property (nonatomic, assign) BOOL canScroll;//是否可以滚动

@end

@implementation SegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topHeight = NaviBarHeight;
    //子控制器视图到达顶部的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"goTop" object:nil];
    //子控制器视图离开顶部的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
}

//接收信息，处理通知
- (void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:@"goTop"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            _canScroll = YES;
            self.scrollView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:@"leaveTop"]){
        _canScroll = NO;
        self.scrollView.contentOffset = CGPointZero;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil userInfo:@{@"canScroll":@"1"}];
    }
    _scrollView = scrollView;
}

//处理左滑右滑，解决系统右划手势与ScrollView右划手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.scrollView.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
