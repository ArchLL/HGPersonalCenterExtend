//
//  MBProgressHUD+NHAdd.h
//  NHHUDExtendDemo
//
//  Created by neghao on 2017/6/11.
//  Copyright © 2017年 neghao. All rights reserved.
//

#import "MBProgressHUD_NHExtend.h"

@class MBProgressHUD;

//默认持续显示时间(x秒后消失)
UIKIT_EXTERN CGFloat const delayTime;

/** 设置默认的显示风格(修改这个值可以减少频繁的调用setHudStyle)：
 *  NHHUDContentDefaultStyle = 0,//默认是白底黑字 Default
 *  NHHUDContentBlackStyle = 1,//黑底白字
 *  NHHUDContentCustomStyle = 2,
 *
 * eg：设置为1时，调用任何这个扩展内的方法，显示出hud的UI效果都会为黑底白字风格
 */
#define NHDefaultHudStyle  1


/**
 * 风格为自定义时，在这里设置颜色
 */
#define NHCustomHudStyleBackgrandColor  [UIColor colorWithWhite:0.f alpha:0.7f]
#define NHCustomHudStyleContentColor    [UIColor colorWithWhite:1.f alpha:0.7f]


@interface MBProgressHUD (NHAdd)

//*************************************************************************************//
//      所有类方法中有返回本类的，则不会自动消失，返回值为void的都会自动消失(默认值:delayTime)      //
//      所有类方法中有返回本类的，则不会自动消失，返回值为void的都会自动消失(默认值:delayTime)      //
//      所有类方法中有返回本类的，则不会自动消失，返回值为void的都会自动消失(默认值:delayTime)      //
//*************************************************************************************//


/**
 纯加载图
 */
+ (MBProgressHUD *)showOnlyLoadToView:(UIView *)view;

/**
 纯文字
 */
+ (void)showOnlyTextToView:(UIView *)view title:(NSString *)title;

/**
 纯文字标题 + 详情
 */
+ (void)showOnlyTextToView:(UIView *)view title:(NSString *)title detail:(NSString *)detail;

/**
 *  成功提示 - 自动消失，带默认成功图
 *
 *  @param success 要显示的文字
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  错误提示 - 自动消失, 带默认错误图
 *
 *  @param error 要显示的错误文字
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 纯文字标题 + 自定位置 - 自动消失
 
 @param postion 位置：上、中、下
 */
+ (void)showTitleToView:(UIView *)view
                postion:(NHHUDPostion)postion
                  title:(NSString *)title;

/**
 纯文字标题 + 详情 + 自定位置 - 自动消失
 
 @param postion 配置hud其它属性
 */
+ (void)showDetailToView:(UIView *)view
                 postion:(NHHUDPostion)postion
                   title:(NSString *)title
                  detail:(NSString *)detail;


/**
 纯文字 + 自定位置、风格 - 自动消失
 
 @param postion 位置
 @param contentStyle 风格
 */
+ (void)showTitleToView:(UIView *)view
                postion:(NHHUDPostion)postion
           contentStyle:(NHHUDContentStyle)contentStyle
                  title:(NSString *)title;


/**
 文字 + 加载图
 */
+ (MBProgressHUD *)showLoadToView:(UIView *)view title:(NSString *)title;

/**
 文字 + 加载图 + 自定风格
 */
+ (MBProgressHUD *)showLoadToView:(UIView *)view contentStyle:(NHHUDContentStyle)contentStyle title:(NSString *)title;


/**
 纯文字 + 自定位置 x秒后自动消失
 
 @param delay 延迟消失时间
 */
+ (void)showTitleToView:(UIView *)view
           contentStyle:(NHHUDContentStyle)contentStyle
                  title:(NSString *)title
             afterDelay:(NSTimeInterval)delay;


/**
 文字 + 进度条
 
 @param progressStyle 进度条风格
 @param progress 当前进度值
 */
+ (MBProgressHUD *)showDownToView:(UIView *)view
                    progressStyle:(NHHUDProgressStyle)progressStyle
                            title:(NSString *)title
                         progress:(NHCurrentHud)progress;


/**
 文字 + 进度条 + 取消按钮
 
 @param progressStyle 进度条风格
 @param progress 当前进度值
 @param cancelTitle 取消按钮名称
 @param cancelation 取消按钮的点击事件
 */
+ (MBProgressHUD *)showDownToView:(UIView *)view
                    progressStyle:(NHHUDProgressStyle)progressStyle
                            title:(NSString *)title
                      cancelTitle:(NSString *)cancelTitle
                         progress:(NHCurrentHud)progress
                      cancelation:(NHCancelation)cancelation;


/**
 文字 + 自定图片
 @param image 图片
 */
+ (void)showCustomView:(UIImage *)image
                toView:(UIView *)toView
                 title:(NSString *)title;


/**
 文字 + 默认加载图 + 自定朦胧层背景色
 
 @param backgroundColor 自定背景色
 */
+ (MBProgressHUD *)showLoadToView:(UIView *)view
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title;


/**
 文字 + 默认加载图 + 自定文字、加载图颜色
 
 @param contentColor 自定文字、加载图颜色
 */
+ (MBProgressHUD *)showLoadToView:(UIView *)view
                     contentColor:(UIColor *)contentColor
                            title:(NSString *)title;


/**
 文字 + 默认加载图 + 自定文图内容颜色 + 自定朦胧层背景色
 
 @param contentColor 自定文字、加载图颜色
 @param backgroundColor + 自定朦胧层背景色
 */
+ (MBProgressHUD *)showLoadToView:(UIView *)view
                     contentColor:(UIColor *)contentColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title;

/**
 文字 + 默认加载图 + 自定文字及加载图颜色 + 自定朦胧层背景色
 
 @param titleColor 自定文字
 @param bezelViewColor 加载图背景颜色
 @param backgroundColor + 自定朦胧层背景色
 */
+ (MBProgressHUD *)showLoadToView:(UIView *)view
                       titleColor:(UIColor *)titleColor
                   bezelViewColor:(UIColor *)bezelViewColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title;

/**
 状态变换
 
 @param configHud 配置hud其它属性
 */
+ (MBProgressHUD *)showModelSwitchToView:(UIView *)toView
                                   title:(NSString *)title
                               configHud:(NHCurrentHud)configHud;


/**
 文字 + 进度 网络请求
 
 @param configHud 配置hud其它属性
 */
+ (MBProgressHUD *)showDownWithNSProgress:(NSProgress *)Progress
                                   toView:(UIView *)view
                                    title:(NSString *)title
                                configHud:(NHCurrentHud)configHud;


/**
 隐藏ProgressView
 
 */
+ (void)hideHUDForView:(UIView *)view;


/**
 隐藏（从window）
 */
+ (void)hideHUD;


/**
 创建一个新的hud
 
 @param configHud 配置hud其它属性
 */
+ (MBProgressHUD *)createHudToView:(UIView *)view
                             title:(NSString *)title
                         configHud:(NHCurrentHud)configHud;

@end


