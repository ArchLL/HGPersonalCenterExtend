# HGPersonalCenterExtend

![License MIT](https://img.shields.io/dub/l/vibe-d.svg) 
[![Platform](https://img.shields.io/cocoapods/p/HGPersonalCenterExtend.svg?style=flat)](http://cocoapods.org/pods/HGPersonalCenterExtend)
![Pod version](http://img.shields.io/cocoapods/v/HGPersonalCenterExtend.svg?style=flat)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0+ 
- Objective-C
- Xcode 9+

## Installation

HGPersonalCenterExtend is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HGPersonalCenterExtend', '~> 0.1.2'
```

## Blog
[简书](https://www.jianshu.com/p/8b87837d9e3a)

## Main 
1.使用Masonry方式布局；  
2.解决外层和内层滚动视图的上下滑动冲突问题；  
3.解决segmentedPageViewController的scrollView左右滚动和外层scrollView上下滑动不能互斥的问题； 
4.计划：如：优化体验、HGPageViewController支持刷新、扩展HGCategoryView更多样式)； 

#### 如果想实现头部背景视图放大的效果，可关注我另一个库：[HGPersonalCenter](https://github.com/ArchLL/HGPersonalCenter)  

![image](https://github.com/ArchLL/HGPersonalCenterExtend/blob/master/show.gif)  

## Usage
Example: HGPersonalCenterExtend/Example

假如你要将CenterViewController作为个人主页，你需要做如下操作（参考Example下的`HGPersonalCenterViewController`）
```Objc

#import "HGSegmentedPageViewController.h"
#import "HGCenterBaseTableView.h"

@interface HGPersonalCenterViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, HGSegmentedPageViewControllerDelegate, HGPageViewControllerDelegate>
@property (nonatomic, strong) HGCenterBaseTableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) HGSegmentedPageViewController *segmentedPageViewController;
@property (nonatomic) BOOL cannotScroll;

@end

- (void)viewDidLoad {
  [super viewDidLoad];
  if (@available(iOS 11.0, *)) {
      [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
  } else {
      self.automaticallyAdjustsScrollViewInsets = NO;
  }
  self.navigationController.interactivePopGestureRecognizer.delegate = self;

  //将segmentedPageViewController.view添加在footerView上
  [self addChildViewController:self.segmentedPageViewController]; 
  [self.footerView addSubview:self.segmentedPageViewController.view];
  [self.segmentedPageViewController didMoveToParentViewController:self];
  [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.footerView);
  }];
}

#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self.segmentedPageViewController.currentPageViewController makePageViewControllerScrollToTop];
    return YES;
}

/**
* 处理联动，Example里有详细注释
*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat criticalPointOffsetY = scrollView.contentSize.height - SCREEN_HEIGHT;
    if (contentOffsetY >= criticalPointOffsetY) {
        self.cannotScroll = YES;
        scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        [self.segmentedPageViewController.currentPageViewController makePageViewControllerScroll:YES];
    } else {
        if (self.cannotScroll) {
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        }
    }
}

#pragma mark - HGSegmentedPageViewControllerDelegate
- (void)segmentedPageViewControllerWillBeginDragging {
    self.tableView.scrollEnabled = NO;
}

- (void)segmentedPageViewControllerDidEndDragging {
    self.tableView.scrollEnabled = YES;
}

#pragma mark - HGPageViewControllerDelegate
- (void)pageViewControllerLeaveTop {
    self.cannotScroll = NO;
}

#pragma mark - Lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[HGCenterBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerImageView;
        _tableView.tableFooterView = self.footerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HGDoraemonCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HGDoraemonCell class])];
    }
    return _tableView;
}

/*设置segmentedPageViewController的categoryView以及pageViewControllers
*这里可以对categoryView进行自定义，包括高度、背景颜色、字体颜色、字体大小、下划线高度和颜色等
*这里用到的pageViewController需要继承自HGPageViewController
*/
- (HGSegmentedPageViewController *)segmentedPageViewController {
    if (!_segmentedPageViewController) {
        NSMutableArray *controllers = [NSMutableArray array];
        NSArray *titles = @[@"华盛顿", @"夏威夷", @"拉斯维加斯", @"纽约", @"西雅图", @"底特律", @"费城", @"旧金山", @"芝加哥"];
        for (int i = 0; i < titles.count; i++) {
            HGPageViewController *controller;
            if (i % 3 == 0) {
            controller = [[HGThirdViewController alloc] init];
        } else if (i % 2 == 0) {
            controller = [[HGSecondViewController alloc] init];
        } else {
            controller = [[HGFirstViewController alloc] init];
        }
        controller.delegate = self;
        [controllers addObject:controller];
    }
    _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
    _segmentedPageViewController.pageViewControllers = controllers.copy;
    _segmentedPageViewController.categoryView.titles = titles;
    _segmentedPageViewController.categoryView.originalIndex = self.selectedIndex;
    _segmentedPageViewController.categoryView.collectionView.backgroundColor = [UIColor yellowColor];
    _segmentedPageViewController.delegate = self;
  }
  return _segmentedPageViewController;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT);
    }
    return _footerView;
}

```

⚠️ 如果你的pageViewController下的scrollView是UICollectionView类型，需要进行如下设置：
```Objc
//解决categoryView在吸顶状态下，且collectionView的显示内容不满屏时，出现竖直方向滑动失效的问题
_collectionView.alwaysBounceVertical = YES;
```

## Author

Arch, mint_bin@163.com

## License

HGPersonalCenterExtend is available under the MIT license. See the LICENSE file for more info.

