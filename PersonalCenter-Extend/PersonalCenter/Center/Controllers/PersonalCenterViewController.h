//
//  PersonalCenterViewController.h
//  PersonalCenter
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterViewController : UIViewController
@property (nonatomic, assign) NSUInteger selectIndex;//当前选中的分页视图
@property (nonatomic, readonly, assign) BOOL isBacking;

@end
