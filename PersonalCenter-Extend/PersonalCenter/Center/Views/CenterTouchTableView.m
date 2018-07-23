//
//  CenterTouchTableView.m
//  PersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "CenterTouchTableView.h"

#define segmentMenuHeight 41

@implementation CenterTouchTableView
//注意：下方的tableView是继承自XXHomeBaseTableView，至关重要，目的是判断是否让外层tableView的手势透传到子视图
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //分页列表高度
    CGFloat naviBarHeight = NaviBarHeight;
    CGFloat listHeight = kScreenHeight - naviBarHeight - segmentMenuHeight;
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(CGRectMake(0, self.contentSize.height - listHeight, kScreenWidth, listHeight), currentPoint) ) {
        return YES;
    }
    return NO;
}

@end
