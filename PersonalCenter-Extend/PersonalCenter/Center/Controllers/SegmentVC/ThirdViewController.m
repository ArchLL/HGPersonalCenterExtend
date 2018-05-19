//
//  ThirdViewController.m
//  PersonalCenter
//
//  Created by 中资北方 on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@end

static NSString * const reuseIdentifier = @"collectionCell";
@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
}


- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;//item左右最小间隔(实际间距，比sectionInset优先级高)
    flowLayout.minimumLineSpacing = 10;//item上下最小间隔(实际间距，比sectionInset优先级高)
    flowLayout.sectionInset = UIEdgeInsetsMake(10,10,5,10);//item对象上左下右的距离
    flowLayout.itemSize = CGSizeMake((kScreenWidth-30)/2, 200);//每一个 item 对象大小
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//设置滚动方向,默认垂直方向.
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.topHeight-segmentMenuHeight) collectionViewLayout:flowLayout];
    [_collectionView registerClass :[UICollectionViewCell class ] forCellWithReuseIdentifier :reuseIdentifier];
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor colorWithRed:242/255. green:242/255. blue:242/255. alpha:1.];
    _collectionView.directionalLockEnabled = YES;
    [self.view addSubview:_collectionView];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
