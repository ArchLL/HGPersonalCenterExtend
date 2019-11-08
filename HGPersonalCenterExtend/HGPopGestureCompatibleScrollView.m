//
//  HGPopGestureCompatibleScrollView.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/5/16.
//

#import "HGPopGestureCompatibleScrollView.h"

@implementation HGPopGestureCompatibleScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end
