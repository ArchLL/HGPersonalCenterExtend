//
//  HGMacro.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/5/15.
//  Copyright © 2019 mint_bin@163.com. All rights reserved.
//

#ifndef HGMacro_h
#define HGMacro_h

// device
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define NAVIGATION_BAR_HEIGHT (IS_IPAD ? 50 : 44)
#define IS_EXIST_FRINGE [HGDeviceHelper isExistFringe]
#define IS_EXIST_JAW [HGDeviceHelper isExistJaw]
#define SAFE_AREA_INSERTS_BOTTOM [HGDeviceHelper safeAreaInsetsBottom]
#define SAFE_AREA_INSERTS_TOP [HGDeviceHelper safeAreaInsetsTop]
#define TOP_BAR_HEIGHT (SAFE_AREA_INSERTS_TOP + NAVIGATION_BAR_HEIGHT)
#define IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
// color
#define kRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#endif /* HGMacro_h */
