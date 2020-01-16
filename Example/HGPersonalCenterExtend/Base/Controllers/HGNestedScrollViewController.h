//
//  HGNestedScrollViewController.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2020/1/16.
//  Copyright © 2020 mint_bin@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPersonalCenterExtend.h"

/// ScrollView嵌套控制器
@interface HGNestedScrollViewController : HGBaseViewController <HGSegmentedPageViewControllerDelegate, HGPageViewControllerDelegate>
@property (nonatomic, strong, readonly) HGCenterBaseTableView *tableView;
@property (nonatomic, strong, readonly) UIView *footerView;
@property (nonatomic, strong, readonly) HGSegmentedPageViewController *segmentedPageViewController;
@end
