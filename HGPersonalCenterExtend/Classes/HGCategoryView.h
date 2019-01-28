//
//  HGCategoryView.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2018/8/20.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGCategoryViewCollectionViewCell : UICollectionViewCell
@property (nonatomic, readonly, strong) UILabel *titleLabel;
@end;

@interface HGCategoryView : UIView
@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) UIView *underline;
@property (nonatomic, strong, readonly) UIView *separator;
@property (nonatomic, strong) UIFont *titleNomalFont;
@property (nonatomic, strong) UIFont *titleSelectedFont;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic) NSInteger originalIndex;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat underlineHeight;
@property (nonatomic) CGFloat cellSpacing;
@property (nonatomic) CGFloat leftAndRightMargin; // default = cellSpacing

@property (nonatomic, copy) void (^selectedItemHelper)(NSUInteger index);

- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex;

@end
