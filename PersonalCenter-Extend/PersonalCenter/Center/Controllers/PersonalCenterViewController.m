//
//  PersonalCenterViewController.m
//  PersonalCenter
//
//  Created by 中资北方 on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "CenterTestCellONE.h"
#import "CenterTestCellTWO.h"
#import "CenterSegmentView.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "CenterTouchTableView.h"
#import "MyMessageViewController.h"

#define headimageHeight   240.0 //头部视图的高度

@interface PersonalCenterViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) CenterTouchTableView   * mainTableView;
@property (nonatomic, strong) CenterSegmentView      * segmentView;//分栏视图，头部视图下方区域
@property (nonatomic, strong) UIView                 * naviView;//自定义导航栏
@property (nonatomic, strong) UIImageView            * headImageView; //头部背景视图
@property (nonatomic, strong) UIView                 * headContentView;//头部内容视图，放置用户信息，如：姓名，昵称、座右铭等(作用：背景放大不会影响内容的位置)
@property (nonatomic, strong) UIImageView            * avatarImage;//头像
@property (nonatomic,   copy) UILabel                * nickNameLB;//昵称
@property (nonatomic, strong) UIView                 * footerView;



@property (nonatomic, assign) BOOL canScroll;//mainTableView是否可以滚动
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;//到达顶部(临界点)不能移动mainTableView
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;//到达顶部(临界点)不能移动子控制器的tableView

@end

@implementation PersonalCenterViewController
{
    NSInteger _naviBarHeight;//导航栏的高度+状态栏的高度
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.naviView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.naviView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //接收宏定义的值，因为下面要做运算，这个宏含有三目运算不能直接拿来运算,会出错
    _naviBarHeight = NaviBarHeight;
    //如果使用自定义的按钮去替换系统默认返回按钮，会出现滑动返回手势失效的情况，解决方法如下：
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self setUI];
//    [self requestData];
    //注册允许外层tableView滚动通知-解决和分页视图的上下滑动冲突问题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    //注册允许外层tableView滚动通知-解决子视图左右滑动和外层tableView上下滑动的冲突问题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsgOfSubView:) name:@"isScroll" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 设置界面
- (void)setUI {
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    //添加tableView
    [self.view addSubview:self.mainTableView];
    
    //添加头部背景视图
    [_mainTableView addSubview:self.headImageView];
    
    //添加自定义导航栏
    [self.view addSubview:self.naviView];
    
    //添加头部内容视图
    [_headImageView addSubview:self.headContentView];
    [_headContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImageView).offset(0);
        make.centerX.mas_equalTo(_headImageView.mas_centerX);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(headimageHeight);
    }];
    //添加头像
    [_headContentView addSubview:self.avatarImage];
    [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headContentView);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
        make.bottom.mas_equalTo(-70);
    }];
    
    //添加昵称
    [_headImageView addSubview:self.nickNameLB];
    [_nickNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headContentView);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(25);
        make.bottom.mas_equalTo(-40);
    }];
}

//请求数据
- (void)requestData {
    [MBProgressHUD showOnlyLoadToView:self.view];
    //模拟数据请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

//接收通知
- (void)acceptMsg:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

- (void)acceptMsgOfSubView:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _mainTableView.scrollEnabled = YES;
    }else if([canScroll isEqualToString:@"0"]) {
        _mainTableView.scrollEnabled = NO;
    }
}

/**
 * 处理联动
 * 因为要实现下拉头部放大的问题，tableView设置了contentInset，所以试图刚加载的时候会调用一遍这个方法，所以要做一些特殊处理，
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //当前偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    //分页高度
    CGFloat footerHeight = kScreenHeight - _naviBarHeight;
    //临界点偏移量(吸顶临界点)
    CGFloat tabyOffset = scrollView.contentSize.height - footerHeight - _naviBarHeight;
    
    //第一部分：
    //更改导航栏的背景图的透明度
    CGFloat alpha = 0;
    if (yOffset < headimageHeight - _naviBarHeight) {
        alpha = yOffset/(headimageHeight - _naviBarHeight);
    }else {
        alpha = 1;
    }
    self.naviView.backgroundColor = kRGBA(255,126,15,alpha);
    
    //第二部分：
    //注意：先解决mainTableView的bance问题，如果不用下拉头部刷新/下拉头部放大/为了实现subTableView下拉刷新
    //1. 不用下拉顶部刷新、不用下拉头部放大、使用subTableView下拉顶部刷新， 可在mainTableView初始化时禁用bance；
    //2. 如果做下拉顶部刷新、下拉头部放大，就需要对bance做处理，不然当视图滑动到底部后，内外层的scrollView的bance都会起作用，导致视觉上的幻觉(刚滑动到底部/触发内部scrollView的bance的时候，再去点击cell/item/button, 你会发现竟然不管用，再次点就好了，刚开始还以为是点击事件和滑动事件的冲突，后来通过offset的log，发现当内部bance触发的时候，你感觉不到外层bance的变化，并且你会看见，当前列表已经停止滚动了，但是外层scrollView的offset还在变，所以导致首次点击事件失效)
    if (yOffset > 0) {
        scrollView.bounces = NO;
    }else {
        scrollView.bounces = YES;
    }
    
    //利用contentOffset处理内外层scrollView的滑动冲突问题
    if (yOffset >= tabyOffset) {
        //当分页视图滑动至导航栏时，禁止外层tableView滑动
        scrollView.contentOffset = CGPointMake(0, tabyOffset);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        //当分页视图和顶部导航栏分离时，允许外层tableView滑动
        _isTopIsCanNotMoveTabView = NO;
    }
    
    //取反
    _isTopIsCanNotMoveTabViewPre = !_isTopIsCanNotMoveTabView;
    
    if (!_isTopIsCanNotMoveTabViewPre) {
        NSLog(@"分页选择部分滑动到顶端");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
        _canScroll = NO;
    }else {
        NSLog(@"页面滑动到底部后开始下拉");
        if (!_canScroll) {
            NSLog(@"分页选择部分保持在顶端");
            _mainTableView.contentOffset = CGPointMake(0, tabyOffset);
        }
    }
}

#pragma mark - 返回上一界面
- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 查看消息
- (void)checkMessage {
    NSLog(@"查看消息");
    MyMessageViewController *myMessageVC = [[MyMessageViewController alloc]init];
    [self.navigationController pushViewController:myMessageVC animated:YES];
}

#pragma mark - tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }else {
        return 200;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 0) {
        CenterTestCellONE * cell = [tableView dequeueReusableCellWithIdentifier:@"CenterTestCellONE"];
        return cell;
    }else {
        CenterTestCellTWO * cell = [tableView dequeueReusableCellWithIdentifier:@"CenterTestCellTWO"];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerView.backgroundColor = [UIColor yellowColor];
    UILabel *titleLB = [UILabel new];
    titleLB.font = [UIFont boldSystemFontOfSize:18];
    if (section == 0) {
        titleLB.text = @"第一分区";
    }else {
        titleLB.text = @"第二分区";
    }
    [headerView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(15);
        make.bottom.offset(-10);
        make.width.offset(150);
    }];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

#pragma mark - 懒加载
- (UIView *)naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,_naviBarHeight)];
        _naviView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];//该透明色设置不会影响子视图
        //添加返回按钮
        UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [backButton setImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
        backButton.frame = CGRectMake(5, 28 + _naviBarHeight - 64, 28, 25);
        backButton.adjustsImageWhenHighlighted = NO;
        [backButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_naviView addSubview:backButton];
        
        //添加消息按钮
        UIButton *messageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [messageButton setImage:[UIImage imageNamed:@"message"] forState:(UIControlStateNormal)];
        messageButton.frame = CGRectMake(kScreenWidth-35, 28 + _naviBarHeight - 64, 25, 25);
        messageButton.adjustsImageWhenHighlighted = NO;
        [messageButton addTarget:self action:@selector(checkMessage) forControlEvents:(UIControlEventTouchUpInside)];
        [_naviView addSubview:messageButton];
    }
    return _naviView;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        //⚠️这里的属性初始化一定要放在mainTableView.contentInset的设置滚动之前, 不然首次进来视图就会偏移到临界位置，contentInset会调用scrollViewDidScroll这个方法。
        //初始化变量
        _canScroll = YES;
        _isTopIsCanNotMoveTabView = NO;
        
        _mainTableView = [[CenterTouchTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableHeaderView = self.headImageView;
        _mainTableView.tableFooterView = self.setPageViewControllers;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        //注册cell
        [_mainTableView registerNib:[UINib nibWithNibName:@"CenterTestCellONE" bundle:nil] forCellReuseIdentifier:@"CenterTestCellONE"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"CenterTestCellTWO" bundle:nil] forCellReuseIdentifier:@"CenterTestCellTWO"];
    }
    return _mainTableView;
}

- (UIView *)headContentView {
    if (!_headContentView) {
        _headContentView = [[UIView alloc]init];
        _headContentView.backgroundColor = [UIColor clearColor];
    }
    return _headContentView;
}

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc] init];
        _avatarImage.image = [UIImage imageNamed:@"center_avatar.jpeg"];
        _avatarImage.userInteractionEnabled = YES;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.layer.borderWidth = 1;
        _avatarImage.layer.borderColor = kRGBA(255, 253, 253, 1.).CGColor;
        _avatarImage.layer.cornerRadius = 40;
    }
    return _avatarImage;
}

- (UILabel *)nickNameLB {
    if (!_nickNameLB) {
        _nickNameLB = [[UILabel alloc] init];
        _nickNameLB.font = [UIFont systemFontOfSize:16.];
        _nickNameLB.textColor = [UIColor whiteColor];
        _nickNameLB.textAlignment = NSTextAlignmentCenter;
        _nickNameLB.lineBreakMode = NSLineBreakByWordWrapping;
        _nickNameLB.numberOfLines = 0;
        _nickNameLB.text = @"撒哈拉下雪了";
    }
    return _nickNameLB;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"center_bg.jpg"]];
        _headImageView.backgroundColor = [UIColor greenColor];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.frame = CGRectMake(0, -headimageHeight, kScreenWidth, headimageHeight);
    }
    return _headImageView;
}

/*
 * 这里可以设置替换你喜欢的segmentView
 */
-(UIView *)setPageViewControllers {
    if (!_segmentView) {
        //设置子控制器
        FirstViewController   * firstVC  = [[FirstViewController alloc]init];
        SecondViewController  * secondVC = [[SecondViewController alloc]init];
        ThirdViewController   * thirdVC  = [[ThirdViewController alloc]init];
        SecondViewController  * fourthVC = [[SecondViewController alloc]init];
        NSArray *controllers = @[firstVC,secondVC,thirdVC,fourthVC];
        NSArray *titleArray  = @[@"普吉岛",@"夏威夷",@"洛杉矶",@"新泽西"];
        CenterSegmentView *segmentView = [[CenterSegmentView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -_naviBarHeight) controllers:controllers titleArray:(NSArray *)titleArray ParentController:self selectBtnIndex:(NSInteger)index lineWidth:kScreenWidth/5 lineHeight:3];
        _segmentView = segmentView;
    }
    return _segmentView;
}

@end

