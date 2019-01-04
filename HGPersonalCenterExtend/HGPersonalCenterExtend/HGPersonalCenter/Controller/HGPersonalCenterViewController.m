//
//  HGPersonalCenterExtendViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "HGPersonalCenterViewController.h"
#import "HGDoraemonCell.h"
#import "HGFirstViewController.h"
#import "HGSecondViewController.h"
#import "HGThirdViewController.h"
#import "HGCenterBaseTableView.h"
#import "HGMessageViewController.h"
#import "HGSegmentViewController.h"

static CGFloat const HeaderImageViewHeight = 240;

@interface HGPersonalCenterViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) HGCenterBaseTableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) HGSegmentViewController *segmentViewController;
@property (nonatomic, assign) BOOL canScroll; //mainTableView是否可以滚动
@property (nonatomic, assign) BOOL isBacking; //是否正在pop

@end

@implementation HGPersonalCenterViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //如果使用自定义的按钮去替换系统默认返回按钮，会出现滑动返回手势失效的情况
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self setupSubViews];
    //注册允许外层tableView滚动通知-解决和分页视图的上下滑动冲突问题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    //切换分页时禁止mainTableView上下滑动，停止分页左右滑动的时候允许mainTableView滑动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:IsEnablePersonalCenterVCMainTableViewScroll object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateNavigationBarBackgroundColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isBacking = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:PersonalCenterVCBackingStatus object:nil userInfo:@{@"isBacking": @(self.isBacking)}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isBacking = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:PersonalCenterVCBackingStatus object:nil userInfo:@{@"isBacking": @(self.isBacking)}];
}

#pragma mark - Private Methods
- (void)setupSubViews {
    [self.view insertSubview:self.tableView belowSubview:self.navigationBar];
    [self.navigationBar addSubview:self.messageButton];
    [self.headerImageView addSubview:self.avatarImageView];
    [self.headerImageView addSubview:self.nickNameLabel];
    [self addChildViewController:self.segmentViewController];
    [self.footerView addSubview:self.segmentViewController.view];
    [self.segmentViewController didMoveToParentViewController:self];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerImageView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.mas_equalTo(-70);
    }];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerImageView);
        make.width.mas_lessThanOrEqualTo(200);
        make.bottom.mas_equalTo(-40);
    }];
    [self.segmentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
}

- (void)gotoMessagePage {
    HGMessageViewController *vc = [[HGMessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateNavigationBarBackgroundColor {
    CGFloat alpha = 0;
    if (self.tableView.contentOffset.y < HeaderImageViewHeight - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT) {
        alpha = self.tableView.contentOffset.y / (HeaderImageViewHeight - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT);
    }else {
        alpha = 1;
    }
    self.navigationBar.backgroundColor = kRGBA(28, 162, 223, alpha);
}

- (void)acceptMsg:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    if ([notification.name isEqualToString:@"leaveTop"]) {
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
        }
    } else if ([notification.name isEqualToString:IsEnablePersonalCenterVCMainTableViewScroll]) {
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.tableView.scrollEnabled = YES;
        } else if ([canScroll isEqualToString:@"0"]) {
            self.tableView.scrollEnabled = NO;
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    //通知分页子控制器列表返回顶部
    [[NSNotificationCenter defaultCenter] postNotificationName:SegementViewChildVCBackToTop object:nil];
    return YES;
}

/**
 * 处理联动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self updateNavigationBarBackgroundColor];
    
    //当前偏移量
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    //吸顶临界点(此时的临界点不是视觉感官上导航栏的底部，而是当前屏幕的顶部相对scrollViewContentView的位置)
    CGFloat criticalPointOffsetY = scrollView.contentSize.height - SCREEN_HEIGHT;
    
    //利用contentOffset处理内外层scrollView的滑动冲突问题
    /* 主要规则：
     * ⚠️ 这里的”吸顶状态“和”到达临界点状态“不能完全划等号，这里一下子确实有点难以理解，我会在下方尽可能的简单   化表达出来
     * 一、吸顶状态: segmentView到达临界点(这里设置的临界点是导航栏底部，可以自定义))
          mainTableView不能滚动(固定mainTableView的位置-通过设置contentOffset的方式),segmentView的子控制器的tableView或collectionView在竖直方向上可以滚动；
       二、未吸顶状态:
          mainTableView能滚动,segmentView的子控制器的tableView或collectionView在竖直方向上不可以滚动；
     */
    if (currentOffsetY >= criticalPointOffsetY) {
        /*
         * 到达临界点 ：此状态下有两种情况
         * 1.未吸顶状态 -> 吸顶状态
         * 2.维持吸顶状态 (segmentView的子控制器的tableView或collectionView在竖直方向上的contentOffsetY大于0)
         */
        //“进入吸顶状态”以及“维持吸顶状态”
        scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll": @"1"}];
        self.canScroll = NO;
    } else {
        /*
         * 未达到临界点 ：此状态下有两种情况，且这两种情况完全相反，这也是引入一个canScroll属性的重要原因
         * 1.吸顶状态 -> 不吸顶状态
         * 2.维持吸顶状态 (segmentView的子控制器的tableView或collectionView在竖直方向上的contentOffsetY大于0)
         */
        if (!self.canScroll) {
            //“维持吸顶状态”
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        } else {
            /* 吸顶状态 -> 不吸顶状态
             * segmentView的子控制器的tableView或collectionView在竖直方向上的contentOffsetY小于等于0时，会通过通知的方式改变self.canScroll的值；
             * 这里不再做多余处理，已经在SegmentViewController中做了处理-发送name为“leaveTop”的通知
             */
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HGDoraemonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HGDoraemonCell class]) forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor yellowColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"哆啦A梦";
    label.textColor = [UIColor orangeColor];
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    return headerView;
}

#pragma mark - Lazy
- (UITableView *)tableView {
    if (!_tableView) {
        //⚠️这里的属性初始化一定要放在mainTableView.contentInset的设置之前, 不然首次进来视图就会偏移到临界位置，contentInset会调用scrollViewDidScroll这个方法。
        //初始化变量
        self.canScroll = YES;
        
        _tableView = [[HGCenterBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerImageView;
        _tableView.tableFooterView = self.footerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HGDoraemonCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HGDoraemonCell class])];
    }
    return _tableView;
}

- (UIButton *)messageButton {
    if (!_messageButton) {
        _messageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_messageButton setImage:[UIImage imageNamed:@"message"] forState:(UIControlStateNormal)];
        _messageButton.adjustsImageWhenHighlighted = NO;
        [_messageButton addTarget:self action:@selector(gotoMessagePage) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _messageButton;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:@"center_avatar.jpeg"];
        _avatarImageView.userInteractionEnabled = YES;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.layer.borderColor = kRGBA(255, 253, 253, 1).CGColor;
        _avatarImageView.layer.cornerRadius = 40;
    }
    return _avatarImageView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:16];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.text = @"下雪天";
    }
    return _nickNameLabel;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, HeaderImageViewHeight)];
        _headerImageView.image = [UIImage imageNamed:@"center_bg.jpg"];
    }
    return _headerImageView;
}

- (HGSegmentViewController *)segmentViewController {
    if (!_segmentViewController) {
        //设置子控制器
        HGFirstViewController *firstVC  = [[HGFirstViewController alloc] init];
        HGSecondViewController *secondVC = [[HGSecondViewController alloc] init];
        HGThirdViewController *thirdVC  = [[HGThirdViewController alloc] init];
        HGSecondViewController *fourthVC = [[HGSecondViewController alloc] init];
        HGFirstViewController *fifthVC  = [[HGFirstViewController alloc] init];
        HGSecondViewController *sixthVC = [[HGSecondViewController alloc] init];
        HGFirstViewController *seventhVC  = [[HGFirstViewController alloc] init];
        HGThirdViewController *eighthVC  = [[HGThirdViewController alloc] init];
        HGSecondViewController *ninthVC = [[HGSecondViewController alloc] init];
        NSArray *controllers = @[firstVC, secondVC, thirdVC, fourthVC, fifthVC, sixthVC, seventhVC, eighthVC, ninthVC];
        NSArray *titleArray = @[@"华盛顿", @"夏威夷", @"拉斯维加斯", @"纽约", @"西雅图", @"底特律", @"费城", @"旧金山", @"芝加哥"];
        _segmentViewController = [[HGSegmentViewController alloc] init];
        _segmentViewController.pageViewControllers = controllers;
        _segmentViewController.categoryView.titles = titleArray;
        _segmentViewController.categoryView.originalIndex = self.selectedIndex;
    }
    return _segmentViewController;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT);
    }
    return _footerView;
}

@end

