//
//  HGPersonalCenterHeaderView.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/4/4.
//  Copyright © 2019 mint_bin@163.com. All rights reserved.
//

#import "HGPersonalCenterHeaderView.h"

@interface HGPersonalCenterHeaderView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@end

@implementation HGPersonalCenterHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backgroundImageView];
        [self.backgroundImageView addSubview:self.avatarImageView];
        [self.backgroundImageView addSubview:self.nickNameLabel];
        
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backgroundImageView);
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.bottom.mas_equalTo(-70);
        }];
        [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backgroundImageView);
            make.width.mas_lessThanOrEqualTo(200);
            make.bottom.mas_equalTo(-40);
        }];
    }
    return self;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"center_bg.jpg"];
    }
    return _backgroundImageView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:@"center_avatar.jpeg"];
        _avatarImageView.userInteractionEnabled = YES;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.layer.borderColor = kRGBA(255, 253, 253, 1).CGColor;
        _avatarImageView.layer.cornerRadius = 40;
    }
    return _avatarImageView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:16];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.text = @"下雪天";
    }
    return _nickNameLabel;
}

@end
