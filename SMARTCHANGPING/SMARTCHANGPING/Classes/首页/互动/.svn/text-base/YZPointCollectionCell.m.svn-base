//
//  YZPointCollectionCell.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/17.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZPointCollectionCell.h"

#import "YZDynamicModel.h"

@interface YZPointCollectionCell ()

@property (nonatomic, strong) UILabel * myTitleLabel;

@end

@implementation YZPointCollectionCell

- (void)upView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView * myImgView = [UIImageView new];
    myImgView.image = [UIImage imageNamed:CELL_POINT_IMG];
    
    _myTitleLabel = [UILabel new];
    _myTitleLabel.font = [UIFont boldSystemFontOfSize:26*WIDTH_RATIO/2];
    _myTitleLabel.textColor = YZ_COLOR(0x333333);
    
    [self.contentView sd_addSubviews:@[myImgView, _myTitleLabel]];
    
    myImgView.sd_layout
    .widthIs(16*WIDTH_RATIO/2)
    .heightIs(17*WIDTH_RATIO/2)
    .leftSpaceToView(self.contentView, 54*WIDTH_RATIO/2)
    .centerYEqualToView(self.contentView);
    
    _myTitleLabel.sd_layout
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .leftSpaceToView(myImgView, 20*WIDTH_RATIO/2)
    .rightSpaceToView(self.contentView, 10*WIDTH_RATIO/2);
}

- (void)setModel:(YZBaseModel *)model{
    [super setModel:model];
    _myTitleLabel.text = [(id)model title];
}

@end
