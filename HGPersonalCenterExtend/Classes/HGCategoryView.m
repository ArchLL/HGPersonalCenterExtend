//
//  HGCategoryView.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2018/8/20.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import "HGCategoryView.h"
#import "masonry.h"
#import "HGPersonalCenterExtendMacro.h"

@interface HGCategoryViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end;

@implementation HGCategoryViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

@interface HGCategoryView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *vernier;
@property (nonatomic, strong) UIView *topBorder;
@property (nonatomic, strong) UIView *bottomBorder;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) BOOL selectedCellExist;
@property (nonatomic) CGFloat fontPointSizeScale;
@property (nonatomic) CGFloat animateDuration;
@property (nonatomic) BOOL isFixedVernierWidth;
@property (nonatomic, strong) MASConstraint *vernierCenterXConstraint;
@property (nonatomic, strong) MASConstraint *vernierWidthConstraint;
@end

@implementation HGCategoryView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _selectedIndex = 0;
        _height = HGCategoryViewDefaultHeight;
        _vernierHeight = 1.8;
        _itemSpacing = 15;
        _leftAndRightMargin = 10;
        self.titleNomalFont = [UIFont systemFontOfSize:16];
        self.titleSelectedFont = [UIFont systemFontOfSize:17];
        self.titleNormalColor = [UIColor grayColor];
        self.titleSelectedColor = [UIColor redColor];
        self.vernier.backgroundColor = self.titleSelectedColor;
        self.animateDuration = 0.1;
        [self setupSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.originalIndex > 0) {
        self.selectedIndex = self.originalIndex;
    } else {
        _selectedIndex = 0;
        [self setupUnderlineDefaultLocation];
    }
}

#pragma mark - Public Method
- (void)scrollToTargetIndex:(NSUInteger)targetIndex sourceIndex:(NSUInteger)sourceIndex percent:(CGFloat)percent {
    CGRect sourceVernierFrame = [self vernierFrameAtIndexPath:[NSIndexPath indexPathForItem:sourceIndex inSection:0]];
    CGRect targetVernierFrame = [self vernierFrameAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]];
    self.vernier.frame = CGRectMake(sourceVernierFrame.origin.x + (targetVernierFrame.origin.x - sourceVernierFrame.origin.x) * percent,
                                 targetVernierFrame.origin.y,
                                 targetVernierFrame.size.width,
                                 targetVernierFrame.size.height);
    
    HGCategoryViewCell *sourceCell = [self getCell:sourceIndex];
    HGCategoryViewCell *targetCell = [self getCell:targetIndex];
    
    if (percent > 0.5) {
        if (sourceCell) sourceCell.titleLabel.textColor = self.titleNormalColor;
        if (targetCell) targetCell.titleLabel.textColor = self.titleSelectedColor;
        
        CGFloat scale = self.titleSelectedFont.pointSize / self.titleNomalFont.pointSize;
        [UIView animateWithDuration:self.animateDuration animations:^{
            if (sourceCell) sourceCell.titleLabel.transform = CGAffineTransformIdentity;
            if (targetCell) targetCell.titleLabel.transform = CGAffineTransformMakeScale(scale, scale);
        } completion:nil];
    }
    
    _selectedIndex = targetIndex;
}

#pragma mark - Private Method
- (void)setupSubViews {
    [self addSubview:self.topBorder];
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.vernier];
    [self addSubview:self.bottomBorder];
    
    [self.topBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(HG_ONE_PIXEL);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBorder.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.height - HG_ONE_PIXEL);
    }];
    [self.vernier mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat collectionViewHeight = self.height - HG_ONE_PIXEL * 2;
        make.top.mas_equalTo(collectionViewHeight - self.vernierHeight);
        make.height.mas_equalTo(self.vernierHeight);
    }];
    [self.bottomBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(HG_ONE_PIXEL);
    }];
}

- (HGCategoryViewCell *)getCell:(NSUInteger)index {
    return (HGCategoryViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)layoutAndScrollToSelectedItem {    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    if (self.selectedItemHelper) {
        self.selectedItemHelper(self.selectedIndex);
    }
    
    HGCategoryViewCell *selectedCell = [self getCell:self.selectedIndex];
    if (selectedCell) {
        self.selectedCellExist = YES;
        [self updateUnderlineLocation];
    } else {
        self.selectedCellExist = NO;
        //这种情况下updateUnderlineLocation将在self.collectionView滚动结束后执行（代理方法scrollViewDidEndScrollingAnimation）
    }
}

- (void)setupUnderlineDefaultLocation {
    [self.collectionView layoutIfNeeded];
    HGCategoryViewCell *cell = [self getCell:self.selectedIndex];
    [self.vernier mas_updateConstraints:^(MASConstraintMaker *make) {
        self.vernierCenterXConstraint = make.centerX.equalTo(cell);
        if (self.isFixedVernierWidth) {
            make.width.mas_equalTo(self.vernierWidth);
        } else {
            self.vernierWidthConstraint = make.width.equalTo(cell);
            self->_vernierWidth = cell.titleLabel.frame.size.width;
        }
    }];
}

- (void)updateUnderlineLocation {
    [self.collectionView layoutIfNeeded];
    HGCategoryViewCell *cell = [self getCell:self.selectedIndex];
    [self.vernierCenterXConstraint uninstall];
    if (self.isFixedVernierWidth) {
        [self.vernier mas_updateConstraints:^(MASConstraintMaker *make) {
            self.vernierCenterXConstraint = make.centerX.equalTo(cell);
        }];
    } else {
        [self.vernierWidthConstraint uninstall];
        [self.vernier mas_updateConstraints:^(MASConstraintMaker *make) {
            self.vernierCenterXConstraint = make.centerX.equalTo(cell);
            self.vernierWidthConstraint = make.width.equalTo(cell);
            self->_vernierWidth = cell.titleLabel.frame.size.width;
        }];
    }
    [UIView animateWithDuration:self.animateDuration animations:^{
        [self.collectionView layoutIfNeeded];
    }];
}

- (void)updateCollectionViewContentInset {
    [self.collectionView layoutIfNeeded];
    CGFloat width = self.collectionView.contentSize.width;
    CGFloat margin;
    if (width > HG_SCREEN_WIDTH) {
        width = HG_SCREEN_WIDTH;
        margin = 0;
    } else {
        margin = (HG_SCREEN_WIDTH - width) / 2.0;
    }
    
    switch (self.alignment) {
        case HGCategoryViewAlignmentLeft:
            self.collectionView.contentInset = UIEdgeInsetsZero;
            break;
        case HGCategoryViewAlignmentCenter:
            self.collectionView.contentInset = UIEdgeInsetsMake(0, margin, 0, margin);
            break;
        case HGCategoryViewAlignmentRight:
            self.collectionView.contentInset = UIEdgeInsetsMake(0, margin * 2, 0, 0);
            break;
    }
}

- (CGFloat)getWidthWithContent:(NSString *)content {
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height - HG_ONE_PIXEL)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:self.titleSelectedFont}
                                        context:nil
                   ];
    return ceilf(rect.size.width);
}

- (CGRect)vernierFrameAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layout = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellFrame = layout.frame;
    if (self.isFixedVernierWidth) {
        return CGRectMake(cellFrame.origin.x + (cellFrame.size.width - self.vernierWidth) / 2,
                          self.collectionView.frame.size.height - self.vernierHeight,
                          self.vernierWidth,
                          self.vernierHeight);
    } else {
        return CGRectMake(cellFrame.origin.x,
                          self.collectionView.frame.size.height - self.vernierHeight,
                          cellFrame.size.width,
                          self.vernierHeight);
    }
}

/// 仅点击item的时候调用
- (void)changeItemToTargetIndex:(NSUInteger)targetIndex {
    if (self.selectedIndex == targetIndex) {
        return;
    }
    
    HGCategoryViewCell *selectedCell = [self getCell:self.selectedIndex];
    HGCategoryViewCell *targetCell = [self getCell:targetIndex];
    
    if (selectedCell) selectedCell.titleLabel.textColor = self.titleNormalColor;
    if (targetCell) targetCell.titleLabel.textColor = self.titleSelectedColor;
    
    CGFloat scale = self.titleSelectedFont.pointSize / self.titleNomalFont.pointSize;
    [UIView animateWithDuration:self.animateDuration animations:^{
        if (selectedCell) selectedCell.titleLabel.transform = CGAffineTransformIdentity;
        if (targetCell) targetCell.titleLabel.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:nil];
    
    self.selectedIndex = targetIndex;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [self getWidthWithContent:self.titles[indexPath.row]];
    CGFloat height = self.height - HG_ONE_PIXEL * 2;
    return CGSizeMake(self.itemWidth > 0 ? self.itemWidth : width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.itemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, self.leftAndRightMargin, 0, self.leftAndRightMargin);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGCategoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HGCategoryViewCell class]) forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.titleLabel.textColor = self.selectedIndex == indexPath.row ? self.titleSelectedColor : self.titleNormalColor;
    if (self.selectedIndex == indexPath.row) {
        cell.titleLabel.transform = CGAffineTransformMakeScale(self.fontPointSizeScale, self.fontPointSizeScale);
        cell.titleLabel.font = self.titleSelectedFont;
    } else {
        cell.titleLabel.transform = CGAffineTransformIdentity;
        cell.titleLabel.font = self.titleNomalFont;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self changeItemToTargetIndex:indexPath.row];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.selectedCellExist) {
        [self updateUnderlineLocation];
    }
}

#pragma mark - Setter
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (self.titles.count == 0) {
        return;
    }
    if (selectedIndex >= self.titles.count) {
        _selectedIndex = self.titles.count - 1;
    } else {
        _selectedIndex = selectedIndex;
    }
    [self layoutAndScrollToSelectedItem];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles.copy;
    [self updateCollectionViewContentInset];
}

- (void)setAlignment:(HGCategoryViewAlignment)alignment {
    _alignment = alignment;
}

- (void)setHeight:(CGFloat)categoryViewHeight {
    _height = categoryViewHeight;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.height - HG_ONE_PIXEL);
    }];
    [self.vernier mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.height - self.vernierHeight - HG_ONE_PIXEL);
    }];
}

- (void)setUnderlineHeight:(CGFloat)underlineHeight {
    _vernierHeight = underlineHeight;
    [self.vernier mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.height - self.vernierHeight - HG_ONE_PIXEL);
    }];
}

- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self updateCollectionViewContentInset];
}

- (void)setItemSpacing:(CGFloat)cellSpacing {
    _itemSpacing = cellSpacing;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self updateCollectionViewContentInset];
}

- (void)setLeftAndRightMargin:(CGFloat)leftAndRightMargin {
    _leftAndRightMargin = leftAndRightMargin;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self updateCollectionViewContentInset];
}

- (void)setIsEqualParts:(CGFloat)isEqualParts {
    _isEqualParts = isEqualParts;
    if (self.isEqualParts && self.titles.count > 0) {
        self.itemWidth = (HG_SCREEN_WIDTH - self.leftAndRightMargin * 2 - self.itemSpacing * (self.titles.count - 1)) / self.titles.count;
    }
}

- (void)setVernierWidth:(CGFloat)vernierWidth {
    _vernierWidth = vernierWidth;
    self.isFixedVernierWidth = YES;
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[HGCategoryViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HGCategoryViewCell class])];
    }
    return _collectionView;
}

- (UIView *)vernier {
    if (!_vernier) {
        _vernier = [[UIView alloc] init];
    }
    return _vernier;
}

- (UIView *)topBorder {
    if (!_topBorder) {
        _topBorder = [[UIView alloc] init];
        _topBorder.backgroundColor = [UIColor lightGrayColor];
    }
    return _topBorder;
}

- (UIView *)bottomBorder {
    if (!_bottomBorder) {
        _bottomBorder = [[UIView alloc] init];
        _bottomBorder.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomBorder;
}

- (CGFloat)fontPointSizeScale {
    return self.titleSelectedFont.pointSize / self.titleNomalFont.pointSize;
}

@end
