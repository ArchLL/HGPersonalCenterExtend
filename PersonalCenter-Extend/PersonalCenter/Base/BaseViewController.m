//
//  BaseViewController.m
//  PersonalCenter
//
//  Created by Arch on 2017/6/19.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, assign) CGFloat naviViewHeight;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviViewHeight = STATUS_BAR_HEIGHT + 44;
    [self setupNaviView];
}

- (void)setupNaviView {
    //设置透明的背景图
    [self.navigationController.navigationBar setBackgroundImage:[self drawPngImageWithAlpha:0] forBarMetrics:(UIBarMetricsDefault)];
    //消除导航栏底部的黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //修改导航栏字体大小和颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
    //修改导航栏内容颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.view addSubview:self.naviView];
}

#pragma mark - 根据透明度绘制图片
- (UIImage *)drawPngImageWithAlpha:(CGFloat)alpha{
    //透明色(可设置初始颜色，当alpha=0时，为透明色)
    UIColor *color = kRGBA(255, 126, 15, alpha);
    //位图大小
    CGSize size = CGSizeMake(1, 1);
    //绘制位图
    UIGraphicsBeginImageContext(size);
    //获取当前创建的内容
    CGContextRef content = UIGraphicsGetCurrentContext();
    //充满指定的填充颜色
    CGContextSetFillColorWithColor(content, color.CGColor);
    //指定充满整个矩形
    CGContextFillRect(content, CGRectMake(0, 0, 1, 1));
    //绘制image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束绘制
    UIGraphicsEndImageContext();
    return image;
}

- (UIView *)naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.naviViewHeight)];
        _naviView.backgroundColor = kRGBA(0, 255, 143, 1.0);
    }
    return _naviView;
}

@end

