//
//  ThirdViewController.m
//  PersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "ThirdViewController.h"

static NSString * const reuseIdentifier = @"collectionCell";

@interface ThirdViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 5, 10);
    flowLayout.itemSize = CGSizeMake((kScreenWidth - 30) / 2, 200);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.topHeight - segmentMenuHeight) collectionViewLayout:flowLayout];
    [_collectionView registerClass :[UICollectionViewCell class ] forCellWithReuseIdentifier :reuseIdentifier];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor colorWithRed:242/255. green:242/255. blue:242/255. alpha:1.];
    [self.view addSubview:_collectionView];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
