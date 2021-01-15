//
//  HGCenterBaseTableView.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "HGCenterBaseTableView.h"

@implementation HGCenterBaseTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[HGCenterBaseTableView class]]) {
        return YES;
    } else {
        if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
            && [otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
            // 解决scrollView横向滚动不能与其他scrollView纵向滚动互斥的问题
            if (fabs(scrollView.contentOffset.x) > 0 && fabs(scrollView.contentOffset.y) == 0) { // 横向滚动
                return NO;
            }
            return YES;
        }
        return NO;
    }
}

@end
