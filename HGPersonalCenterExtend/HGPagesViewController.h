//
//  HGPagesViewController.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/11/13.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPageViewController.h"
@class HGPopGestureCompatibleCollectionView;

@protocol HGPagesViewControllerDelegate <NSObject>
- (void)pagesViewControllerLeaveTop;
- (void)pagesViewControllerWillBeginDragging;
- (void)pagesViewControllerDidEndDragging;
- (void)pagesViewControllerScrollingToTargetPage:(NSInteger)targetPage sourcePage:(NSInteger)sourcePage percent:(CGFloat)percent;

@optional
- (void)pagesViewControllerWillTransitionToPage:(NSInteger)page;
- (void)pagesViewControllerDidTransitionToPage:(NSInteger)page;
@end

@interface HGPagesViewController : UIViewController
@property (nonatomic, strong, readonly) HGPopGestureCompatibleCollectionView *collectionView;
@property (nonatomic, copy) NSArray<HGPageViewController *> *viewControllers;
@property (nonatomic) NSInteger originalPage;
@property (nonatomic, readonly) NSInteger selectedPage;
@property (nonatomic, strong, readonly) HGPageViewController *selectedPageViewController;
@property(nonatomic, weak) id <HGPagesViewControllerDelegate> delegate;

- (void)makeViewControllersScrollToTop;
- (void)setSelectedPage:(NSInteger)selectedPage animated:(BOOL)animated;
@end

