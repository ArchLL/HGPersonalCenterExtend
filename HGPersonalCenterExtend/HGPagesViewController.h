//
//  HGPagesViewController.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/11/13.
//

#import <UIKit/UIKit.h>
#import "HGPageViewController.h"
@class HGPopGestureCompatibleCollectionView;

@protocol HGPagesViewControllerDelegate <NSObject>
@optional
- (void)pagesViewControllerWillBeginDragging;
- (void)pagesViewControllerDidEndDragging;
- (void)pagesViewControllerScrollingToTargetPage:(NSInteger)targetPage sourcePage:(NSInteger)sourcePage percent:(CGFloat)percent;
- (void)pagesViewControllerWillTransitionToPage:(NSInteger)page;
- (void)pagesViewControllerDidTransitionToPage:(NSInteger)page;

@end

@interface HGPagesViewController : UIViewController
@property (nonatomic, strong, readonly) HGPopGestureCompatibleCollectionView *collectionView;
@property (nonatomic, copy) NSArray<HGPageViewController *> *viewControllers;
@property (nonatomic) NSInteger originalPage;
@property (nonatomic) NSInteger selectedPage;
@property (nonatomic, strong, readonly) HGPageViewController *selectedPageViewController;
@property(nonatomic, weak) id<HGPagesViewControllerDelegate> delegate;

- (void)setSelectedPage:(NSInteger)selectedPage animated:(BOOL)animated;

@end

