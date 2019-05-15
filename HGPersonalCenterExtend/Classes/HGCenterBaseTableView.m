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
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    CGFloat segmentViewContentScrollViewHeight = self.tableFooterView.frame.size.height - self.categoryViewHeight ?: HGCategoryViewDefaultHeight;
    BOOL isContainsPoint = CGRectContainsPoint(CGRectMake(0, self.contentSize.height - segmentViewContentScrollViewHeight, HG_SCREEN_WIDTH, segmentViewContentScrollViewHeight), currentPoint);
    BOOL isPop = [otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")];
    
    if (isPop && isContainsPoint) {
        return YES;
    } else {
        if (isContainsPoint) {
            return YES;
        } else {
            if (isPop) {
                gestureRecognizer.state = UIGestureRecognizerStateCancelled;
            }
            return NO;
        }
    }
}

@end
