//
//  PersonalCenterViewController.h
//  PersonalCenter
//
//  Created by 中资北方 on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PersonalCenterViewController : UIViewController

@property (nonatomic, assign) BOOL isRefreshOfdownPull;//下拉操作下方tableView是否刷新
@property (nonatomic, assign) NSInteger selectIndex;//当前选中的分页视图

@end
