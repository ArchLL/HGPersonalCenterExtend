//
//  HGCategoryView.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2018/8/20.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, HGCategoryViewAlignment) {
    HGCategoryViewAlignmentLeft,
    HGCategoryViewAlignmentCenter,
    HGCategoryViewAlignmentRight
};

@interface HGCategoryViewCollectionViewCell : UICollectionViewCell
@property (nonatomic, readonly, strong) UILabel *titleLabel;
@end;

@interface HGCategoryView : UIView

/// titles
@property (nonatomic, copy) NSArray<NSString *> *titles;

/// 分布方式（左、中、右）
@property (nonatomic) HGCategoryViewAlignment alignment;

/// 游标
@property (nonatomic, strong, readonly) UIView *vernier;

/// 上边框
@property (nonatomic, strong, readonly) UIView *topBorder;

/// 下边框
@property (nonatomic, strong, readonly) UIView *bottomBorder;

/// 未选中时的字体大小
@property (nonatomic, strong) UIFont *titleNomalFont;

/// 选中时的字体大小
@property (nonatomic, strong) UIFont *titleSelectedFont;

/// 未选中时的字体颜色
@property (nonatomic, strong) UIColor *titleNormalColor;

/// 选中时的字体颜色
@property (nonatomic, strong) UIColor *titleSelectedColor;

/// 初始选中的下标
@property (nonatomic) NSInteger originalIndex;

/// 当前选中的下标
@property (nonatomic, readonly) NSInteger selectedIndex;

/// 自身高度
@property (nonatomic) CGFloat height;

/// 游标的高度
@property (nonatomic) CGFloat vernierHeight;

/// item间距
@property (nonatomic) CGFloat itemSpacing;

/// item宽度
@property (nonatomic) CGFloat itemWidth;

/// collectionView左右的margin
@property (nonatomic) CGFloat leftAndRightMargin;

/// item是否等分(在titles、itemSpacing、itemWidth、leftAndRightMargin设置之后设置)，Default：NO
@property (nonatomic) CGFloat isEqualParts;

/// item点击事件的回调
@property (nonatomic, copy) void (^selectedItemHelper)(NSUInteger index);


/**
 使collectionViewd滚动到指定的cell

 @param targetIndex 目标cell的index
 */
- (void)changeItemToTargetIndex:(NSUInteger)targetIndex;

@end
