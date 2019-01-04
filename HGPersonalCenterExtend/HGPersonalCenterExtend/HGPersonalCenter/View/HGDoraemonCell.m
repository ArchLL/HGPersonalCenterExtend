//
//  HGDoraemonCell.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2018/5/19.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import "HGDoraemonCell.h"
#import "HGDoraemonCollectionViewCell.h"

@interface HGDoraemonCell ()<UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HGDoraemonCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HGDoraemonCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HGDoraemonCollectionViewCell class])];
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
            self.collectionView.scrollEnabled = NO;
        } else {
            self.collectionView.scrollEnabled = YES;
        }
    }
}

#pragma mark CollectionView Delegate
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
