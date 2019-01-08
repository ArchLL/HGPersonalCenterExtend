//
//  HGSegmentedPageViewController.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/1/3.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGCategoryView;
@class HGPageViewController;

@protocol HGSegmentedPageViewControllerDelegate <NSObject>
- (void)segmentedPageViewControllerWillBeginDragging;
- (void)segmentedPageViewControllerDidEndDragging;
@end

@interface HGSegmentedPageViewController : UIViewController
@property (nonatomic, strong, readonly) HGCategoryView *categoryView;
@property (nonatomic, copy) NSArray<HGPageViewController *> *pageViewControllers;
@property (nonatomic, strong, readonly) HGPageViewController *currentPageViewController;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, weak) id<HGSegmentedPageViewControllerDelegate> delegate;
@end

