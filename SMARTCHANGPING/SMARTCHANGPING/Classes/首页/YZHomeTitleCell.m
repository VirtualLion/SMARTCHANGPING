//
//  YZHomeTitleCell.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZHomeTitleCell.h"
#import "YZLifeListVC.h"

@interface YZHomeTitleCell ()

@property (nonatomic, strong) UILabel * titLabel;
@property (nonatomic, strong) UIButton * allButton;

@end

@implementation YZHomeTitleCell

- (void)onBtn:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    YZLifeListVC * listVC = [YZLifeListVC new];
    listVC.title = @"生活服务列表";
    [[YZRootVC sharedManager].navigationController pushViewController:listVC animated:YES];
    sender.userInteractionEnabled = YES;
}

- (void)upView{
    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView sd_addSubviews:@[backView]];
    backView.sd_layout
    .topSpaceToView(self.contentView, 15*WIDTH_RATIO/2)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
    _titLabel = [UILabel new];
    _titLabel.textColor = YZ_COLOR(0x333333);
    _titLabel.font = [UIFont boldSystemFontOfSize:30*WIDTH_RATIO/2];
    
    _allButton = [UIButton new];
    [_allButton.titleLabel setFont:[UIFont systemFontOfSize:26*WIDTH_RATIO/2]];
    [_allButton setTitleColor:YZ_COLOR(0x666666) forState:UIControlStateNormal];
    [_allButton setTitle:@"查看全部" forState:UIControlStateNormal];
    [_allButton addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [backView sd_addSubviews:@[_titLabel, _allButton]];
    
    _titLabel.sd_layout
    .widthIs(150*WIDTH_RATIO/2)
    .leftSpaceToView(backView, 27*WIDTH_RATIO/2)
    .centerYEqualToView(backView)
    .autoHeightRatio(0);
    
    _allButton.sd_layout
    .topEqualToView(backView)
    .bottomEqualToView(backView)
    .rightEqualToView(backView)
    .widthIs(170*WIDTH_RATIO/2);
    
    _titLabel.text = @"本地特惠";
}

- (void)setModel:(YZBaseModel *)model{
    [super setModel:model];
    
}

@end
