# HGPersonalCenterExtend

![License MIT](https://img.shields.io/dub/l/vibe-d.svg) 
[![Platform](https://img.shields.io/cocoapods/p/HGPersonalCenterExtend.svg?style=flat)](http://cocoapods.org/pods/HGPersonalCenterExtend)
![Pod version](http://img.shields.io/cocoapods/v/HGPersonalCenterExtend.svg?style=flat)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 9.0+ 
- Objective-C
- Xcode 10+

## Installation

HGPersonalCenterExtend is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HGPersonalCenterExtend', '~> 1.2.9'
```

## Main 
1.使用`Masonry`方式布局；  
2.解决外层和内层滚动视图的上下滑动冲突问题；  
3.解决`segmentedPageViewController`的`scrollView`横向滚动和外层`scrollView`纵向滑动不能互斥的问题等；   
4.支持全屏返回；  

## Plan
1.支持刷新；  
2.`HGCategoryView`支持更多样式 ；

## Show
![image](https://github.com/ArchLL/HGPersonalCenterExtend/blob/master/show.gif)  

## Usage
`Example: HGPersonalCenterExtend/Example`

1.新建一个主控制器(可参照`Example`中`HGPersonalCenterViewController`)，并继承自`HGNestedScrollViewController`，在这里你只需要设置`pageViewControllers`和`categaryView相关的属性`，不需要关心嵌套的交互逻辑；  

2.嵌套逻辑交互封装在`HGNestedScrollViewController`中，大家可根据自己实际业务需求进行自定义；   
  问：为什么这个控制器不直接放进`HGPersonalCenterExtend`库中呢？  
  答：这是为了方便大家`DIY`(改个基类/改个样式)，你们可以将其文件拖到自己的项目中，稍加改动即可使用；     

3.新建需要的子控制器, 需要继承自`HGPageViewController`，其他正常开发即可；      
   
4.如果你的`pageViewController`下的`scrollView`是`UICollectionView`类型，需要额外进行如下设置：  

```Objc
// 因为当collectionView的内容不满一屏时，会导致竖直方向滑动失效，所以需要设置alwaysBounceVertical为YES
_collectionView.alwaysBounceVertical = YES;
```

## Recommend

如果想实现头部背景视图放大的效果，可关注我另一个库：[HGPersonalCenter](https://github.com/ArchLL/HGPersonalCenter)  

## Blog
[简书](https://www.jianshu.com/p/8b87837d9e3a)

## Author

Arch, mint_bin@163.com

## License

HGPersonalCenterExtend is available under the MIT license. See the LICENSE file for more info.
