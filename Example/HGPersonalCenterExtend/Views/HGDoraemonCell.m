//
//  HGDoraemonCell.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2018/5/19.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import "HGDoraemonCell.h"
#import "HGDoraemonCollectionViewCell.h"

@interface HGDoraemonCell ()
@property (weak, nonatomic) IBOutlet HGPopGestureCompatibleCollectionView *collectionView;
@end

@implementation HGDoraemonCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HGDoraemonCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HGDoraemonCollectionViewCell class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.collectionView.contentOffset.x <= 0) {
        self.collectionView.bounces = NO;
    } else {
        self.collectionView.bounces = YES;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HGDoraemonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HGDoraemonCollectionViewCell class]) forIndexPath:indexPath];
    return cell;
}

#pragma mark FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 180);
}

@end
