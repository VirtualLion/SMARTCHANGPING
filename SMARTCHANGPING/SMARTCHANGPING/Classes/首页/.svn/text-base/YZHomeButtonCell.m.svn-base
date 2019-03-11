//
//  YZHomeButtonCell.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZHomeButtonCell.h"

@interface YZHomeButtonCell ()

@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) UILabel * titLabel;

@end

@implementation YZHomeButtonCell

- (void)upView{
    [super upView];
    
    _imgView = [UIImageView new];
    _titLabel = [UILabel new];
    _titLabel.textAlignment = NSTextAlignmentCenter;
    _titLabel.textColor = YZ_COLOR(0x333333);
    _titLabel.font = [UIFont systemFontOfSize:22*WIDTH_RATIO/2];
    
    [self.contentView sd_addSubviews:@[_imgView, _titLabel]];
    
    _imgView.sd_layout
    .widthIs(100*WIDTH_RATIO/2)
    .heightEqualToWidth()
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 30*WIDTH_RATIO/2);
    
    _titLabel.sd_layout
    .topSpaceToView(_imgView, 10*WIDTH_RATIO/2)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .autoHeightRatio(0);
    
}

- (void)setModel:(YZBaseModel *)model{
    [super setModel:model];
    NSDictionary * dic = [NSDictionary dictionaryWithObjects:HOME_BUTTON_IMGS forKeys:HOME_BUTTON_TITLES];
    _titLabel.text = [(id)model title];
    _imgView.image = [UIImage imageNamed:dic[_titLabel.text]];
}

@end
