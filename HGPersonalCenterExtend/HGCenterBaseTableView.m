//
//  HGCenterBaseTableView.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "HGCenterBaseTableView.h"
#import "HGCategoryView.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@implementation HGCenterBaseTableView

// 允许otherGestureRecognizer纵向滚动与gestureRecognizer的纵向滚动共存
// 解决otherGestureRecognizer横向滚动不能与gestureRecognizer纵向滚动互斥的问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)otherGestureRecognizer;
        CGPoint velocity = [panGestureRecognizer velocityInView:self];
        return abs(velocity.y) > abs(velocity.x);
    }
    return NO;
}

@end
