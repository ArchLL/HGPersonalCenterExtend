//
//  HGCategoryView.h
//  HGCategoryView
//
//  Created by Arch on 2018/8/20.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const HGCategoryViewDefaultHeight;

typedef NS_ENUM(NSUInteger, HGCategoryViewAlignment) {
    HGCategoryViewAlignmentLeft,
    HGCategoryViewAlignmentCenter,
    HGCategoryViewAlignmentRight
};

@protocol HGCategoryViewDelegate <NSObject>
@optional
- (void)categoryViewDidSelectedItemAtIndex:(NSInteger)index;
@end

@interface HGCategoryView : UIView

@property (nonatomic, weak) id<HGCategoryViewDelegate> delegate;

/// titles
@property (nonatomic, copy) NSArray<NSString *> *titles;

/// 当前选中的下标，default：0
@property (nonatomic) NSUInteger selectedIndex;

/// 自身高度，default：41
@property (nonatomic) CGFloat height;

/// 分布方式（左、中、右）
@property (nonatomic) HGCategoryViewAlignment alignment;

/// 未选中时的字体，default size：16
@property (nonatomic, strong) UIFont *titleNomalFont;

/// 选中时的字体，default size：17
@property (nonatomic, strong) UIFont *titleSelectedFont;

/// 未选中时的字体颜色，default：[UIColor grayColor]
@property (nonatomic, strong) UIColor *titleNormalColor;

/// 选中时的字体颜色，default：[UIColor redColor]
@property (nonatomic, strong) UIColor *titleSelectedColor;

/// 上边框(高度为一个像素)，默认显示
@property (nonatomic, strong, readonly) UIView *topBorder;

/// 下边框(高度为一个像素)，默认显示
@property (nonatomic, strong, readonly) UIView *bottomBorder;

/// 游标
@property (nonatomic, strong, readonly) UIView *vernier;

/// 游标的宽度(设置后固定)，default：随着title的宽度变化，
@property (nonatomic) CGFloat vernierWidth;

/// 游标的高度，default：1.8
@property (nonatomic) CGFloat vernierHeight;

/// item间距，default：15
@property (nonatomic) CGFloat itemSpacing;

/// item宽度(设置后固定)，default：随着内容宽度变化
@property (nonatomic) CGFloat itemWidth;

/// collectionView左边的margin，default：10
@property (nonatomic) CGFloat leftMargin;

/// collectionView右边的margin，default：10
@property (nonatomic) CGFloat rightMargin;

/// item是否等分(实质上改变的是itemWidth)，default：NO
@property (nonatomic) CGFloat isEqualParts;

/// 字体变大、vernier位置切换动画时长，default：0.1
@property (nonatomic) CGFloat animateDuration;

/**
 使collectionView滚动到指定的cell

 @param targetIndex 目标cell的index
 @param sourceIndex 当前cell的index
 @param percent 滑动距离/(sourceIndex与targetIndex的距离)
 */
- (void)scrollToTargetIndex:(NSUInteger)targetIndex sourceIndex:(NSUInteger)sourceIndex percent:(CGFloat)percent;

@end
