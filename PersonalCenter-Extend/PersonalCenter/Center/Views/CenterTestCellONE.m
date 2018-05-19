//
//  CenterTestCellONE.m
//  PersonalCenter
//
//  Created by 黑色幽默 on 2018/5/19.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import "CenterTestCellONE.h"
#import "CenterTestOneCollectionViewCell.h"

@interface CenterTestCellONE ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CenterTestCellONE

- (void)awakeFromNib {
    [super awakeFromNib];
    [_collectionView registerNib:[UINib nibWithNibName:@"CenterTestOneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CenterTestOneCollectionViewCell"];
}

#pragma mark CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CenterTestOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CenterTestOneCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 180);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
