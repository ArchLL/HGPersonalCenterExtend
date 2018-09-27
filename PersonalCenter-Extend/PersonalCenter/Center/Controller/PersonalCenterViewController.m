//
//  PersonalCenterViewController.m
//  PersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "CenterTestCollectionView.h"
#import "SegmentView.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "CenterTouchTableView.h"
#import "MessageViewController.h"

static CGFloat const HeaderImageViewHeight = 240;

@interface PersonalCenterViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) CenterTouchTableView *mainTableView;
@property (nonatomic, strong) SegmentView *segmentView;
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) BOOL canScroll; //mainTableView是否可以滚动
@property (nonatomic, assign) BOOL isBacking; //是否正在pop

@end

@implementation PersonalCenterViewController

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
    [self.navigationController setNavigationBarHidden:YES];
    self.naviView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isBacking = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:PersonalCenterVCBackingStatus object:nil userInfo:@{@"isBacking":@(self.isBacking)}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isBacking = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:PersonalCenterVCBackingStatus object:nil userInfo:@{@"isBacking":@(self.isBacking)}];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.naviView.hidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods
- (void)setupSubViews {
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.naviView];
    [self.headerImageView addSubview:self.headerContentView];
    [self.headerContentView addSubview:self.avatarImageView];
    [self.headerContentView addSubview:self.nickNameLabel];
    [self.mainTableView addSubview:self.headerImageView];
    
    [self.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.mas_equalTo(self.headerImageView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(HeaderImageViewHeight);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerContentView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.mas_equalTo(-70);
    }];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerContentView);
        make.width.mas_lessThanOrEqualTo(200);
        make.bottom.mas_equalTo(-40);
    }];
}

- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)gotoMessagePage {
    MessageViewController *myMessageVC = [[MessageViewController alloc]init];
    [self.navigationController pushViewController:myMessageVC animated:YES];
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
            self.mainTableView.scrollEnabled = YES;
        } else if ([canScroll isEqualToString:@"0"]) {
            self.mainTableView.scrollEnabled = NO;
        }
    }
}

#pragma mark - UITableViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    //通知分页子控制器列表返回顶部
    [[NSNotificationCenter defaultCenter] postNotificationName:SegementViewChildVCBackToTop object:nil];
    return YES;
}

/**
 * 处理联动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //当前偏移量
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    //吸顶临界点(此时的临界点不是感官上导航栏的底部，而是屏幕的顶部)
    CGFloat criticalPointOffsetY = scrollView.contentSize.height - SCREEN_HEIGHT;
    
    //更改导航栏的背景图的透明度
    CGFloat alpha = 0;
    if (currentOffsetY < HeaderImageViewHeight - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT) {
        alpha = currentOffsetY / (HeaderImageViewHeight - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT);
    }else {
        alpha = 1;
    }
    self.naviView.backgroundColor = kRGBA(255, 126, 15, alpha);
    
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
        
        //下面这行代码是“维持吸顶状态”和“进入吸顶状态”的共同代码
        scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        //进入吸顶状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
        self.canScroll = NO;
    } else {
        /*
         * 未达到临界点 ：此状态下有两种情况，且这两种情况完全相反，这也是引入一个canScroll属性的重要原因
         * 1.吸顶状态 -> 不吸顶状态
         * 2.维持吸顶状态 (segmentView的子控制器的tableView或collectionView在竖直方向上的contentOffsetY大于0)
         */
        
        if (!self.canScroll) {
            //维持吸顶状态
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CenterTestCollectionView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CenterTestCollectionView class]) forIndexPath:indexPath];
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
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor yellowColor];
    UILabel *titleLB = [UILabel new];
    titleLB.font = [UIFont boldSystemFontOfSize:18];
    if (section == 0) {
        titleLB.text = @"第一分区";
    } else {
        titleLB.text = @"第二分区";
    }
    [headerView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(150);
    }];
    return headerView;
}

#pragma mark - Lazy
- (UIView *)naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT)];
        _naviView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        //添加返回按钮
        UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [backButton setImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
        backButton.frame = CGRectMake(5, 8 + STATUS_BAR_HEIGHT, 28, 25);
        backButton.adjustsImageWhenHighlighted = YES;
        [backButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_naviView addSubview:backButton];
        
        //添加消息按钮
        UIButton *messageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [messageButton setImage:[UIImage imageNamed:@"message"] forState:(UIControlStateNormal)];
        messageButton.frame = CGRectMake(SCREEN_WIDTH - 35, 8 + STATUS_BAR_HEIGHT, 25, 25);
        messageButton.adjustsImageWhenHighlighted = YES;
        [messageButton addTarget:self action:@selector(gotoMessagePage) forControlEvents:(UIControlEventTouchUpInside)];
        [_naviView addSubview:messageButton];
    }
    return _naviView;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        //⚠️这里的属性初始化一定要放在mainTableView.contentInset的设置滚动之前, 不然首次进来视图就会偏移到临界位置，contentInset会调用scrollViewDidScroll这个方法。
        //初始化变量
        self.canScroll = YES;
        
        _mainTableView = [[CenterTouchTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableHeaderView = self.headerImageView;
        _mainTableView.tableFooterView = self.setPageViewControllers;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CenterTestCollectionView class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CenterTestCollectionView class])];
    }
    return _mainTableView;
}

- (UIView *)headerContentView {
    if (!_headerContentView) {
        _headerContentView = [[UIView alloc]init];
        _headerContentView.backgroundColor = [UIColor clearColor];
    }
    return _headerContentView;
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
        _nickNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _nickNameLabel.numberOfLines = 0;
        _nickNameLabel.text = @"下雪天";
    }
    return _nickNameLabel;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"center_bg.jpg"]];
        _headerImageView.backgroundColor = [UIColor greenColor];
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.frame = CGRectMake(0, -HeaderImageViewHeight, SCREEN_WIDTH, HeaderImageViewHeight);
    }
    return _headerImageView;
}

/*
 * 这里可以设置替换你喜欢的segmentView
 */
- (UIView *)setPageViewControllers {
    if (!_segmentView) {
        //设置子控制器
        FirstViewController *firstVC  = [[FirstViewController alloc] init];
        SecondViewController *secondVC = [[SecondViewController alloc] init];
        ThirdViewController *thirdVC  = [[ThirdViewController alloc] init];
        SecondViewController *fourthVC = [[SecondViewController alloc] init];
        FirstViewController *fifthVC  = [[FirstViewController alloc] init];
        SecondViewController *sixthVC = [[SecondViewController alloc] init];
        FirstViewController *seventhVC  = [[FirstViewController alloc] init];
        ThirdViewController *eighthVC  = [[ThirdViewController alloc] init];
        SecondViewController *ninthVC = [[SecondViewController alloc] init];
        NSArray *controllers = @[firstVC, secondVC, thirdVC, fourthVC, fifthVC, sixthVC, seventhVC, eighthVC, ninthVC];
        NSArray *titleArray = @[@"华盛顿", @"夏威夷", @"拉斯维加斯", @"纽约", @"西雅图", @"底特律", @"费城", @"旧金山", @"芝加哥"];
        SegmentView *segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT) controllers:controllers titleArray:(NSArray *)titleArray parentController:self];
        //注意：不能通过初始化方法传递selectedIndex的初始值，因为内部使用的是Masonry布局的方式, 否则设置selectedIndex不起作用
        segmentView.selectedIndex = self.selectedIndex;
        _segmentView = segmentView;
    }
    return _segmentView;
}

@end

