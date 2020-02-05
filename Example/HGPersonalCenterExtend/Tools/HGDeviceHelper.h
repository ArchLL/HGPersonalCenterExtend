//
//  HGDeviceHelper.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2018/9/17.
//  Copyright © 2019 mint_bin@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGDeviceHelper : NSObject
+ (BOOL)isIpad;
+ (BOOL)isExistFringe;
+ (BOOL)isExistJaw;
+ (CGFloat)safeAreaInsetsTop;
+ (CGFloat)safeAreaInsetsBottom;
+ (CGFloat)navigationBarHeight;

@end
