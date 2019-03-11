//
//  YZHomeGoodsCell.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZHomeGoodsCell.h"

#import "YZHomeModel.h"

@interface YZHomeGoodsCell ()

@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) UILabel * titLabel;
@property (nonatomic, strong) UILabel * texLabel;

@end

@implementation YZHomeGoodsCell

- (void)upView{
    [super upView];
    
    _imgView = [UIImageView new];
    
    _titLabel = [UILabel new];
    _titLabel.textAlignment = NSTextAlignmentCenter;
    _titLabel.textColor = YZ_COLOR(0x666666);
    _titLabel.font = [UIFont systemFontOfSize:22*WIDTH_RATIO/2];
    
    _texLabel = [UILabel new];
    _texLabel.textAlignment = NSTextAlignmentCenter;
//    _texLabel.font = [UIFont systemFontOfSize:22*WIDTH_RATIO/2];
    //0xf05633 22 0x999999 20
    
    
    [self.contentView sd_addSubviews:@[_imgView, _titLabel, _texLabel]];
    
    _imgView.sd_layout
    .widthIs(170*WIDTH_RATIO/2)
    .heightIs(150*WIDTH_RATIO/2)
    .centerXEqualToView(self.contentView)
    .topEqualToView(self.contentView);
    
    _titLabel.sd_layout
    .topSpaceToView(_imgView, 10*WIDTH_RATIO/2)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .autoHeightRatio(0);
    
    _texLabel.sd_layout
    .topSpaceToView(_titLabel, 0)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .autoHeightRatio(0);
    
}

- (void)setModel:(YZBaseModel *)model{
    [super setModel:model];
    
    _titLabel.text = [(id)model title];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[(id)model shop_img_url]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMG]];
    
    NSString * newPrice = [NSString stringWithFormat:@"¥%@ ", @([(id)model bargin_price].doubleValue)];
    NSString * oldPrice = [NSString stringWithFormat:@" ¥%@ \0", @([(id)model original_price].doubleValue)];
    //0xf05633 22 0x999999 20
    
    NSString * texStr = [NSString stringWithFormat:@"%@%@", newPrice, oldPrice];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:texStr];
    //划线
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:[texStr rangeOfString:oldPrice]];
    [attri addAttribute:NSStrikethroughColorAttributeName value:YZ_COLOR(0x999999) range:[texStr rangeOfString:oldPrice]];
    //颜色
    [attri addAttribute:NSForegroundColorAttributeName value:YZ_COLOR(0xf05633) range:[texStr rangeOfString:newPrice]];
    [attri addAttribute:NSForegroundColorAttributeName value:YZ_COLOR(0x999999) range:[texStr rangeOfString:oldPrice]];
    //字体
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24*WIDTH_RATIO/2] range:[texStr rangeOfString:newPrice]];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20*WIDTH_RATIO/2] range:[texStr rangeOfString:oldPrice]];
    
    [_texLabel setAttributedText:attri];
}

@end
