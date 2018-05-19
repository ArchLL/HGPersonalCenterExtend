//
//  CenterSegmentView.h
//  PersonalCenter
//
//  Created by 中资北方 on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterSegmentView : UIView

@property ( nonatomic, strong) NSArray       * nameArray;
@property ( nonatomic, strong) UIView        * segmentView;
@property ( nonatomic, strong) UIScrollView  * segmentScrollV;
@property ( nonatomic, strong) UILabel       * line;
@property ( nonatomic, strong) UIButton      * seleBtn;
@property ( nonatomic, strong) UILabel       * down;
@property ( nonatomic,   copy) void (^pageBlock)(NSInteger);//页面切换的回调，依次是 0 1 2 。。。

- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray ParentController:(UIViewController *)parentC selectBtnIndex:(NSInteger)index lineWidth:(float)lineW lineHeight:(float)lineH;

@end
