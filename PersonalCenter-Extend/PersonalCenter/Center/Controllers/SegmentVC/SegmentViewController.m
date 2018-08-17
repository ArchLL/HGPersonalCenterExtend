//
//  SegmentViewController.m
//  PersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "SegmentViewController.h"

@interface SegmentViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) NSNumber *selectedVCIndex;

@end

@implementation SegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topHeight = NaviBarHeight;
    //子控制器视图到达顶部的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"goTop" object:nil];
    //子控制器视图离开顶部的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    //切换分页选项的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"SelectVC" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//处理通知
- (void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:@"goTop"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            _canScroll = YES;
            self.scrollView.showsVerticalScrollIndicator = YES;
        } else {
            _canScroll = NO;
        }
    } else if ([notificationName isEqualToString:@"leaveTop"]){
        _canScroll = NO;
        self.scrollView.contentOffset = CGPointZero;
        self.scrollView.showsVerticalScrollIndicator = NO;
    } else if ([notificationName isEqualToString:@"SelectVC"]) {
        NSDictionary *userInfo = notification.userInfo;
        self.selectedVCIndex = userInfo[@"selectedVCIndex"];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.selectedVCIndex isEqualToNumber:@0]) {
        return YES;
    }
    return NO;
}

@end
