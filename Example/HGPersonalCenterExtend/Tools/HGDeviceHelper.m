//
//  HGDeviceHelper.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2018/9/17.
//  Copyright © 2019 mint_bin@163.com. All rights reserved.
//

#import "HGDeviceHelper.h"

@implementation HGDeviceHelper

+ (BOOL)isExistFringe {
    BOOL isExistFringe = NO;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        if (mainWindow.safeAreaInsets.top > 20.0) {
            isExistFringe = YES;
        }
    }
    return isExistFringe;
}

+ (BOOL)isExistJaw {
    BOOL isExistJaw = NO;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            isExistJaw = YES;
        }
    }
    return isExistJaw;
}

+ (CGFloat)safeAreaInsetsBottom {
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        return mainWindow.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}

+ (CGFloat)safeAreaInsetsTop {
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        return mainWindow.safeAreaInsets.top;
    } else {
        return 20;
    }
}

@end
