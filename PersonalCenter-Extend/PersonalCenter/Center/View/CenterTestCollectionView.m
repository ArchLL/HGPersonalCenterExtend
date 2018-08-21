//
//  CenterTestCellmoveLine.m
//  PersonalCenter
//
//  Created by Arch on 2018/5/19.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import "CenterTestCollectionView.h"
#import "CenterTestCollectionViewCell.h"

@interface CenterTestCollectionView ()<UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CenterTestCollectionView
- (void)awakeFromNib {
    [super awakeFromNib];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CenterTestCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CenterTestCollectionViewCell class])];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:PersonalCenterVCBackingStatus object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:PersonalCenterVCBackingStatus]) {
        NSDictionary *userInfo = notification.userInfo;
        NSNumber *isBacking = userInfo[@"isBacking"];
        if (isBacking.boolValue) {
            _collectionView.scrollEnabled = NO;
        } else {
            _collectionView.scrollEnabled = YES;
        }
    }
}

#pragma mark CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CenterTestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CenterTestCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 180);
}

@end
