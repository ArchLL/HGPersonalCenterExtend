//
//  HGSegmentViewController.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/1/3.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGCategoryView;
@class HGPageViewController;

@interface HGSegmentViewController : UIViewController
@property (nonatomic, strong, readonly) HGCategoryView *categoryView;
@property (nonatomic, copy) NSArray<HGPageViewController *> *pageViewControllers;
@end

