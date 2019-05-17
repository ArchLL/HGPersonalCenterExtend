//
//  HGBaseViewController.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/5/15.
//  Copyright © 2019 mint_bin@163.com. All rights reserved.
//

#import "HGBaseViewController.h"

@interface HGBaseViewController ()
@property (nonatomic, strong) UIImage *navigationBarOriginShadowImage;
@property (nonatomic, strong) HGAlignmentAdjustButton *backButton;
@end

@implementation HGBaseViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBaseNavigationBar];
}

#pragma mark - Public Methods
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.isHideStatusBar;
}

- (void)setIsHideStatusBar:(BOOL)isHideStatusBar {
    _isHideStatusBar = isHideStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
    //for FringeScreen, more details:https://forums.developer.apple.com/thread/88962
    if (IS_EXIST_FRINGE && self.navigationController) {
        self.navigationController.navigationBarHidden = self.isHideStatusBar;
    }
}

- (void)setNavigationBarAlpha:(CGFloat)alpha {
    if (self.navigationController) {
        [self.navigationController.navigationBar setBackgroundImage:[self drawPngImageWithAlpha:alpha] forBarMetrics:(UIBarMetricsDefault)];
    }
}

#pragma mark - Private Methods
- (void)setupBaseNavigationBar {
    if (self.navigationController) {
        self.navigationBarOriginShadowImage = self.navigationController.navigationBar.shadowImage;
        self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]};
        self.navigationController.navigationBar.barTintColor = kRGBA(28, 162, 223, 1.0);
        self.rt_navigationController.useSystemBackBarButtonItem = NO;
    }
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    [self.backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return backItem;
}

- (UIImage *)drawPngImageWithAlpha:(CGFloat)alpha {
    UIColor *color = kRGBA(28, 162, 223, alpha);
    CGSize size = CGSizeMake(1, 1);
    UIGraphicsBeginImageContext(size);
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(content, color.CGColor);
    CGContextFillRect(content, CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Setters
- (void)setIsHiddenBottomBorder:(BOOL)isHiddenBottomBorder {
    _isHiddenBottomBorder = isHiddenBottomBorder;
    if (self.isHiddenBottomBorder) {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    } else {
        [self.navigationController.navigationBar setShadowImage:self.navigationBarOriginShadowImage];
    }
}

#pragma mark - Getters
- (HGAlignmentAdjustButton *)backButton {
    if (!_backButton) {
        _backButton = [HGAlignmentAdjustButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _backButton.tintColor = [UIColor whiteColor];
        [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 7)];
        [_backButton sizeToFit];
    }
    return _backButton;
}

@end
