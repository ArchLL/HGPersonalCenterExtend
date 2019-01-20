//
//  HGPersonalCenterMacro.h
//  HGPersonalCenterExtend
//
//  Created by 黑色幽默 on 2019/1/20.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#ifndef HGPersonalCenterMacro_h
#define HGPersonalCenterMacro_h

#define HG_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define HG_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define HG_STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define HG_IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define HG_NAVIGATION_BAR_HEIGHT ((HG_IS_IPAD ? 50 : 44) + HG_STATUS_BAR_HEIGHT)

#define HG_RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

static const CGFloat HGCategoryViewDefaultHeight = 41;

#endif /* HGPersonalCenterMacro_h */
