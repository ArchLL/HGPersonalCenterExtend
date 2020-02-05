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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 仅仅让pageViewController显示区域识别多个手势，是为了解决分页以上部分的"横向滑动"(如：嵌套UICollectionView)和scrollView的"纵向滑动"的手势同时作用的问题
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    CGFloat segmentViewContentScrollViewHeight = self.tableFooterView.frame.size.height - self.categoryViewHeight ?: HGCategoryViewDefaultHeight;
    BOOL isContainsPoint = CGRectContainsPoint(CGRectMake(0, self.contentSize.height - segmentViewContentScrollViewHeight, SCREEN_WIDTH, segmentViewContentScrollViewHeight), currentPoint);
    return isContainsPoint ? YES : NO;
}

@end
