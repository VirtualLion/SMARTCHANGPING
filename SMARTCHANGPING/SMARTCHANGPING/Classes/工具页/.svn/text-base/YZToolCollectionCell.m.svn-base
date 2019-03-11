//
//  YZToolCollectionCell.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/5.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZToolCollectionCell.h"

@implementation YZToolCollectionCell

- (void)upView{
    
    _myTitleLabel = [UILabel new];
    _myTitleLabel.font = [UIFont systemFontOfSize:23*WIDTH_RATIO/2];
    _myTitleLabel.textColor = YZ_COLOR(0x333333);
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _myTitleLabel.layer.borderWidth = WIDTH_RATIO/2;
    _myTitleLabel.layer.borderColor = [YZ_COLOR(0xdfdfdf) CGColor];
    
    [self.contentView sd_addSubviews:@[_myTitleLabel]];
    
    _myTitleLabel.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
}

- (void)setModel:(YZBaseModel *)model{
    [super setModel:model];
    _myTitleLabel.text = [(id)model title];
}

@end
