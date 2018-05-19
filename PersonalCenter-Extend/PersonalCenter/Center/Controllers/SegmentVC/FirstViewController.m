//
//  FirstViewController.m
//  PersonalCenter
//
//  Created by 中资北方 on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "FirstViewController.h"
#import "MyMessageViewController.h"

@interface FirstViewController () < UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UITableView  * tableView;
@property (nonatomic , assign) NSInteger        page;
@property (nonatomic , assign) BOOL             isHeader;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
}
- (void)creatTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.topHeight-segmentMenuHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
}

#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"FirstVCcell";
    UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"快点我%ld -> 进入我的消息",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中
    MyMessageViewController *myMesageVC = [[MyMessageViewController alloc]init];
    [self.navigationController pushViewController:myMesageVC animated:YES];
}



@end
