//
//  HGCenterBaseTableView.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//
#import "HGCenterBaseTableView.h"
#import "HGPersonalCenterMacro.h"

@implementation HGCenterBaseTableView
//是否让手势透传到子视图
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGFloat segmentViewContentScrollViewHeight = HG_SCREEN_HEIGHT - HG_NAVIGATION_BAR_HEIGHT - self.categoryViewHeight ?: HGCategoryViewDefaultHeight;
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(CGRectMake(0, self.contentSize.height - segmentViewContentScrollViewHeight, HG_SCREEN_WIDTH, segmentViewContentScrollViewHeight), currentPoint)) {
        return YES;
    }
    return NO;
}

@end
