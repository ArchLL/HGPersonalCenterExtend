//
//  SegmentHeaderView.m
//  PersonalCenter
//
//  Created by Arch on 2018/8/20.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import "SegmentHeaderView.h"

#define kWidth self.frame.size.width
#define NORMAL_FONT [UIFont systemFontOfSize:18]
#define NORMAL_COLOR [UIColor blackColor]
#define SELECTED_COLOR [UIColor orangeColor]

@interface SegmentHeaderViewCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end;

@implementation SegmentHeaderViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
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

@interface SegmentHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, strong) UIView *moveLine;
@property (nonatomic, strong) UIView *separator;
@end

CGFloat const SegmentHeaderViewHeight = 41;
static NSString * const SegmentHeaderViewCollectionViewCellIdentifier = @"SegmentHeaderViewCollectionViewCell";
static CGFloat const MoveLineHeight = 2;
static CGFloat const SeparatorHeight = 0.5;
static CGFloat const CellSpacing = 15;
static CGFloat const CollectionViewHeight = SegmentHeaderViewHeight - SeparatorHeight;

@implementation SegmentHeaderView

#pragma mark - Life
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        self.titleArray = titleArray;
        self.selectedIndex = 0;
    }
    return self;
}

#pragma mark - Public Method
- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex {
    if (_selectedIndex == targetIndex) {
        return;
    }
    
    SegmentHeaderViewCollectionViewCell *selectedCell = [self getCell:_selectedIndex];
    selectedCell.titleLabel.textColor = NORMAL_COLOR;
    SegmentHeaderViewCollectionViewCell *targetCell = [self getCell:targetIndex];
    targetCell.titleLabel.textColor = SELECTED_COLOR;
    
    _selectedIndex = targetIndex;
    
    [self layoutAndScrollToSelectedItem];
}

#pragma mark - Private Method
- (void)setupSubViews {
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.moveLine];
    [self addSubview:self.separator];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(CollectionViewHeight);
    }];
    [self.moveLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CollectionViewHeight - MoveLineHeight);
        make.height.mas_equalTo(MoveLineHeight);
    }];
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SeparatorHeight);
    }];
}

- (SegmentHeaderViewCollectionViewCell *)getCell:(NSUInteger)Index {
    return (SegmentHeaderViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:Index inSection:0]];
}

- (void)layoutAndScrollToSelectedItem {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    
    //方法一:
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    //方法二：
    //        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [self updateMoveLineLocation];
    
    if (self.selectedItemHelper) {
        self.selectedItemHelper(_selectedIndex);
    }
}

- (void)setupMoveLineDefaultLocation {
    CGFloat firstCellWidth = [self getWidthWithContent:self.titleArray[0]];
    [self.moveLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(firstCellWidth);
        make.left.mas_equalTo(CellSpacing);
    }];
}

- (void)updateMoveLineLocation {
    SegmentHeaderViewCollectionViewCell *cell = [self getCell:_selectedIndex];
    [UIView animateWithDuration:0.25 animations:^{
        [self.moveLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CollectionViewHeight - MoveLineHeight);
            make.height.mas_equalTo(MoveLineHeight);
            make.width.centerX.equalTo(cell.titleLabel);
        }];
        [self.collectionView setNeedsLayout];
        [self.collectionView layoutIfNeeded];
    }];
}

- (CGFloat)getWidthWithContent:(NSString *)content {
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, CollectionViewHeight)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:NORMAL_FONT}
                                        context:nil
                   ];
    return ceilf(rect.size.width);;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = [self getWidthWithContent:self.titleArray[indexPath.row]];
    return CGSizeMake(itemWidth, SegmentHeaderViewHeight - 1);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SegmentHeaderViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.titleLabel.textColor = _selectedIndex == indexPath.row ? SELECTED_COLOR : NORMAL_COLOR;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self changeItemWithTargetIndex:indexPath.row];
}

#pragma mark - Setter
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray.copy;
    [self.collectionView reloadData];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (self.titleArray == nil && self.titleArray.count == 0) {
        return;
    }
    
    if (selectedIndex >= self.titleArray.count) {
        _selectedIndex = self.titleArray.count - 1;
    } else {
        _selectedIndex = selectedIndex;
    }
    
    //设置初始选中位置
    if (_selectedIndex == 0) {
        [self setupMoveLineDefaultLocation];
    } else {
        [self layoutAndScrollToSelectedItem];
    }
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = CellSpacing;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, CellSpacing, 0, CellSpacing);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, CollectionViewHeight) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor yellowColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[SegmentHeaderViewCollectionViewCell class] forCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier];
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
