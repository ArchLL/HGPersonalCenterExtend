//
//  MBProgressHUD_NHExtend.h
//  NHHUDExtendDemo
//
//  Created by neghao on 2017/6/11.
//  Copyright © 2017年 neghao. All rights reserved.
//

#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, NHHUDContentStyle) {
    NHHUDContentDefaultStyle = 0,//默认是白底黑字 Default
    NHHUDContentBlackStyle = 1,//黑底白字
    NHHUDContentCustomStyle = 2,//:自定义风格<由自己设置自定义风格的颜色>
};

typedef NS_ENUM(NSInteger, NHHUDPostion) {
    NHHUDPostionTop,//上面
    NHHUDPostionCenten,//中间
    NHHUDPostionBottom,//下面
};

typedef NS_ENUM(NSInteger, NHHUDProgressStyle) {
    NHHUDProgressDeterminate,///双圆环,进度环包在内
    NHHUDProgressDeterminateHorizontalBar,///横向Bar的进度条
    NHHUDProgressAnnularDeterminate,///双圆环，完全重合
    NHHUDProgressCancelationDeterminate,///带取消按钮 - 双圆环 - 完全重合
};

typedef void((^NHCancelation)(MBProgressHUD *hud));
typedef void((^NHCurrentHud)(MBProgressHUD *hud));


@interface MBProgressHUD ()

@property (nonatomic, copy  ) NHCancelation cancelation;
///内容风格
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudContentStyle)(NHHUDContentStyle hudContentStyle);
///显示位置：有导航栏时在导航栏下在，无导航栏在状态栏下面
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudPostion)(NHHUDPostion hudPostion);
///进度条风格
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudProgressStyle)(NHHUDProgressStyle hudProgressStyle);
///标题
@property (nonatomic, copy  , readonly) MBProgressHUD *(^title)(NSString *title);
///详情
@property (nonatomic, copy  , readonly) MBProgressHUD *(^details)(NSString *details);
///自定义图片名
@property (nonatomic, copy  , readonly) MBProgressHUD *(^customIcon)(NSString *customIcon);
///标题颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^titleColor)(UIColor *titleColor);
///进度条颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^progressColor)(UIColor *progressColor);
///进度条、标题颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^allContentColors)(UIColor *allContentColors);
///蒙层背景色
@property (nonatomic, strong, readonly) MBProgressHUD *(^hudBackgroundColor)(UIColor *backgroundColor);
///内容背景色
@property (nonatomic, strong, readonly) MBProgressHUD *(^bezelBackgroundColor)(UIColor *bezelBackgroundColor);


@end
