//
//  YZHomeThingsCell.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZHomeThingsCell.h"
#import "YZHomeModel.h"
#import "YZLifeModel.h"

@interface YZHomeThingsCell ()

@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) UILabel * titLabel;
@property (nonatomic, strong) UIImageView * addImgView;

@end

@implementation YZHomeThingsCell

- (void)onBtn:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    sender.selected = !sender.selected;
    [(id)self.model setIsChoose:sender.selected];
    sender.userInteractionEnabled = YES;
}

- (void)upView{
    [super upView];
    _addImgView = [UIImageView new];
    _addImgView.image = [UIImage imageNamed:HOME_THINGS_ADD];
    _addImgView.hidden = YES;
    
    UIView * contentView = [UIView new];
    contentView.hidden = YES;
    
    _choButton = [UIButton new];
    _choButton.userInteractionEnabled = NO;
    [_choButton addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    _choButton.hidden = YES;
    [_choButton setImage:[UIImage imageNamed:THINGS_BUTTON_NOCHOOSE] forState:UIControlStateNormal];
    [_choButton setImage:[UIImage imageNamed:THINGS_BUTTON_CHOOSE] forState:UIControlStateSelected];
    
    [self.contentView sd_addSubviews:@[_addImgView, contentView, _choButton]];
    
    _addImgView.sd_layout
    .widthIs(68*WIDTH_RATIO/2)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView)
    .centerXEqualToView(self.contentView);
    
    contentView.sd_layout
    .heightIs(100*WIDTH_RATIO/2)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .centerYEqualToView(self.contentView);
    
    _choButton.sd_layout
    .widthIs(80*WIDTH_RATIO/2)
    .heightIs(60*WIDTH_RATIO/2)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    
    _imgView = [UIImageView new];
    
    _titLabel = [UILabel new];
    _titLabel.textColor = YZ_COLOR(0x333333);
    _titLabel.font = [UIFont systemFontOfSize:23*WIDTH_RATIO/2];
    _titLabel.textAlignment = NSTextAlignmentCenter;
    
    [contentView sd_addSubviews:@[_imgView, _titLabel]];
    
    _imgView.sd_layout
    .widthIs(68*WIDTH_RATIO/2)
    .heightEqualToWidth()
    .topEqualToView(contentView)
    .centerXEqualToView(contentView);
    
    _titLabel.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .bottomEqualToView(contentView)
    .autoHeightRatio(0);
    
}

- (void)setModel:(YZBaseModel *)model{
    [super setModel:model];
    if (!model) {
        _addImgView.hidden = YES;
        _titLabel.superview.hidden = YES;
    }else{
        if ([model isKindOfClass:[YZHomeModel class]]) {
            _titLabel.text = [(id)model theme_name];
            [_imgView sd_setImageWithURL:[NSURL URLWithString:[(id)model theme_img_url]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMG]];
            _addImgView.hidden = YES;
            _titLabel.superview.hidden = NO;
            _choButton.selected = [(id)model isChoose];
        }else if ([model isKindOfClass:[YZLifeModel class]]) {
            _titLabel.text = [(id)model lc_name];
            [_imgView sd_setImageWithURL:[NSURL URLWithString:[(id)model lc_img_url]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMG]];
            _addImgView.hidden = YES;
            _titLabel.superview.hidden = NO;
            _choButton.hidden = YES;
        }else{
            _addImgView.hidden = NO;
            _titLabel.superview.hidden = YES;
        }
    }
}

@end
