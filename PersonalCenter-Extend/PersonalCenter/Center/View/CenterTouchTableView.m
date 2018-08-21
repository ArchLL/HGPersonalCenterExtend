//
//  CenterTouchTableView.m
//  PersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//
#import "CenterTouchTableView.h"
#import "SegmentHeaderView.h"

@implementation CenterTouchTableView
//是否让外层tableView的手势透传到子视图
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGFloat segmentViewContentScrollViewHeight = SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - SegmentHeaderViewHeight;
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(CGRectMake(0, self.contentSize.height - segmentViewContentScrollViewHeight, SCREEN_WIDTH, segmentViewContentScrollViewHeight), currentPoint) ) {
        return YES;
    }
    return NO;
}

@end
