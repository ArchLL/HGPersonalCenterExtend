//
//  HGPopGestureCompatibleCollectionView.m
//  HGPersonalCenterExtend
//
//  Created by 黑色幽默 on 2019/5/17.
//  Copyright © 2019 mint_bin@163.com. All rights reserved.
//

#import "HGPopGestureCompatibleCollectionView.h"

@implementation HGPopGestureCompatibleCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end
