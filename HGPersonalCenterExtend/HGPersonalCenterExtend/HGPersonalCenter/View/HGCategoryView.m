//
//  HGCategoryView.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2018/8/20.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import "HGCategoryView.h"

#define kWidth self.frame.size.width
#define NORMAL_FONT [UIFont systemFontOfSize:18]
#define NORMAL_COLOR [UIColor grayColor]
#define SELECTED_COLOR [UIColor orangeColor]

@interface HGCategoryViewCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end;

@implementation HGCategoryViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = NORMAL_FONT;
        _titleLabel.textColor = NORMAL_COLOR;
    }
    return _titleLabel;
}
@end

@interface HGCategoryView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *moveLine;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) BOOL selectedCellExist;
@end

CGFloat const HGCategoryViewHeight = 41;
static NSString * const SegmentHeaderViewCollectionViewCellIdentifier = @"SegmentHeaderViewCollectionViewCell";
static CGFloat const MoveLineHeight = 2;
static CGFloat const SeparatorHeight = 0.5;
static CGFloat const CellSpacing = 15;

@implementation HGCategoryView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
        [self setupMoveLineDefaultLocation];
    }
}

#pragma mark - Public Method
- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex {
    if (self.selectedIndex == targetIndex) {
        return;
    }
    HGCategoryViewCollectionViewCell *selectedCell = [self getCell:self.selectedIndex];
    if (selectedCell) {
        selectedCell.titleLabel.textColor = NORMAL_COLOR;
    }
    HGCategoryViewCollectionViewCell *targetCell = [self getCell:targetIndex];
    if (targetCell) {
        targetCell.titleLabel.textColor = SELECTED_COLOR;
    }
    self.selectedIndex = targetIndex;
    [self layoutAndScrollToSelectedItem];
}

#pragma mark - Private Method
- (void)setupSubViews {
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.moveLine];
    [self addSubview:self.separator];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(HGCategoryViewHeight - SeparatorHeight);
    }];
    [self.moveLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HGCategoryViewHeight - SeparatorHeight - MoveLineHeight);
        make.height.mas_equalTo(MoveLineHeight);
    }];
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SeparatorHeight);
    }];
}

- (HGCategoryViewCollectionViewCell *)getCell:(NSUInteger)index {
    return (HGCategoryViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)layoutAndScrollToSelectedItem {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    if (self.selectedItemHelper) {
        self.selectedItemHelper(self.selectedIndex);
    }
    
    HGCategoryViewCollectionViewCell *selectedCell = [self getCell:self.selectedIndex];
    if (selectedCell) {
        self.selectedCellExist = YES;
        [self updateMoveLineLocation];
    } else {
        self.selectedCellExist = NO;
        //这种情况下updateMoveLineLocation将在self.collectionView滚动结束后执行（代理方法scrollViewDidEndScrollingAnimation）
    }
}

- (void)setupMoveLineDefaultLocation {
    CGFloat firstCellWidth = [self getWidthWithContent:self.titles[0]];
    [self.moveLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(firstCellWidth);
        make.left.mas_equalTo(CellSpacing);
    }];
}

- (void)updateMoveLineLocation {
    HGCategoryViewCollectionViewCell *cell = [self getCell:self.selectedIndex];
    [UIView animateWithDuration:0.25 animations:^{
        [self.moveLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(HGCategoryViewHeight - SeparatorHeight - MoveLineHeight);
            make.height.mas_equalTo(MoveLineHeight);
            make.width.centerX.equalTo(cell.titleLabel);
        }];
        [self.collectionView setNeedsLayout];
        [self.collectionView layoutIfNeeded];
    }];
}

- (CGFloat)getWidthWithContent:(NSString *)content {
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, HGCategoryViewHeight - SeparatorHeight)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:NORMAL_FONT}
                                        context:nil
                   ];
    return ceilf(rect.size.width);;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = [self getWidthWithContent:self.titles[indexPath.row]];
    return CGSizeMake(itemWidth, HGCategoryViewHeight - 1);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGCategoryViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.titleLabel.textColor = self.selectedIndex == indexPath.row ? SELECTED_COLOR : NORMAL_COLOR;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self changeItemWithTargetIndex:indexPath.row];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.selectedCellExist) {
        [self updateMoveLineLocation];
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
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = CellSpacing;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, CellSpacing, 0, CellSpacing);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor yellowColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[HGCategoryViewCollectionViewCell class] forCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier];
    }
    return _collectionView;
}

- (UIView *)moveLine {
    if (!_moveLine) {
        _moveLine = [[UIView alloc] init];
        _moveLine.backgroundColor = [UIColor orangeColor];
    }
    return _moveLine;
}

- (UIView *)separator {
    if (!_separator) {
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = [UIColor lightGrayColor];
    }
    return _separator;
}

@end
