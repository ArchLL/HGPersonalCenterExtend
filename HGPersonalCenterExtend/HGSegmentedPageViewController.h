//
//  HGSegmentedPageViewController.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/1/3.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGCategoryView.h"
#import "HGPageViewController.h"

@protocol HGSegmentedPageViewControllerDelegate <NSObject>
- (void)segmentedPageViewControllerLeaveTop;
- (void)segmentedPageViewControllerWillBeginDragging;
- (void)segmentedPageViewControllerDidEndDragging;

@optional
- (void)segmentedPageViewControllerWillTransitionToPage:(NSInteger)page;
- (void)segmentedPageViewControllerDidTransitionToPage:(NSInteger)page;
@end

@interface HGSegmentedPageViewController : UIViewController
@property (nonatomic, strong, readonly) HGCategoryView *categoryView;
@property (nonatomic, copy) NSArray<HGPageViewController *> *pageViewControllers;
@property (nonatomic) NSInteger selectedPage;
@property (nonatomic, strong, readonly) HGPageViewController *selectedPageViewController;
@property (nonatomic, weak) id<HGSegmentedPageViewControllerDelegate> delegate;
@property (nonatomic) BOOL scrollEnabled; // 是否允许pageViewControllers被拖动. default is YES

- (void)makePageViewControllersScrollToTop;
- (void)makePageViewControllersScrollState:(BOOL)canScroll;
@end

