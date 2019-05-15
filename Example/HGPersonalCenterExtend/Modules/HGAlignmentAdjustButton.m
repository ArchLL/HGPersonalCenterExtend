//
//  HGAlignmentAdjustButton.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/5/15.
//  Copyright © 2019 mint_bin@163.com. All rights reserved.
//

#import "HGAlignmentAdjustButton.h"

@interface HGAlignmentAdjustButton ()
@property (nonatomic) UIEdgeInsets alignmentRectInsetsOverride;
@end

@implementation HGAlignmentAdjustButton

- (UIEdgeInsets)alignmentRectInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(self.alignmentRectInsetsOverride, UIEdgeInsetsZero)) {
        return [super alignmentRectInsets];
    } else {
        return self.alignmentRectInsetsOverride;
    }
}

@end
