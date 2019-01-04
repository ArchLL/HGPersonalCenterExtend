//
//  HGCategoryView.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2018/8/20.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN CGFloat const HGCategoryViewHeight;

@interface HGCategoryViewCollectionViewCell : UICollectionViewCell
@property (nonatomic, readonly, strong) UILabel *titleLabel;
@end;

@interface HGCategoryView : UIView
@property (nonatomic) NSInteger originalIndex;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic, copy) void (^selectedItemHelper)(NSUInteger index);

- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex;

@end
