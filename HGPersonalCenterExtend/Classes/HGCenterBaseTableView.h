//
//  HGCenterBaseTableView.h
//  HGPersonalCenterExtend
//
//  Created by Arch on 2017/6/16.
//  Copyright © 2017年 mint_bin. All rights reserved.
//

#import <UIKit/UIKit.h>

//⚠️：如果使用Swift改写HGCenterBaseTableView这个类, 则需要主动去服从UIGestureRecognizerDelegate这个代理协议

@interface HGCenterBaseTableView : UITableView

@property (nonatomic) CGFloat categoryViewHeight;

@end
