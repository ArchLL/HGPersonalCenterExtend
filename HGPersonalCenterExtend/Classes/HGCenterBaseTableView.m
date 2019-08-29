//
//  HGCenterBaseTableView.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//
#import "HGCenterBaseTableView.h"
#import "HGPersonalCenterExtendMacro.h"

@implementation HGCenterBaseTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 仅仅让pageViewController区域的多个手势共存, 解决分页以上部分的"横向滑动视图(嵌套UICollectionView)"和scrollView的纵向滑动的手势冲突问题
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    CGFloat segmentViewContentScrollViewHeight = self.tableFooterView.frame.size.height - self.categoryViewHeight ?: HGCategoryViewDefaultHeight;
    BOOL isContainsPoint = CGRectContainsPoint(CGRectMake(0, self.contentSize.height - segmentViewContentScrollViewHeight, HG_SCREEN_WIDTH, segmentViewContentScrollViewHeight), currentPoint);
    return isContainsPoint ? YES : NO;
}

@end
