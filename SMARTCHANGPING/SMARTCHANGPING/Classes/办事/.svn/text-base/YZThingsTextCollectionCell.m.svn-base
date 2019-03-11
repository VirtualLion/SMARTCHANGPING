//
//  YZThingsTextCollectionCell.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/6.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZThingsTextCollectionCell.h"

#import "YZHomeModel.h"
#import "YZDynamicModel.h"

@interface YZThingsTextCollectionCell()

@property (nonatomic, strong) UILabel * myTitleLabel;

@end

@implementation YZThingsTextCollectionCell


- (void)upView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    _myTitleLabel = [UILabel new];
    _myTitleLabel.font = [UIFont systemFontOfSize:25*WIDTH_RATIO/2];
    _myTitleLabel.textColor = YZ_COLOR(0x333333);
    _myTitleLabel.textAlignment = NSTextAlignmentLeft;
    _myTitleLabel.numberOfLines = 0;
    
    [self.contentView sd_addSubviews:@[_myTitleLabel]];
    
    _myTitleLabel.sd_layout
    .topSpaceToView(self.contentView, 10*WIDTH_RATIO/2)
    .leftSpaceToView(self.contentView, 70*WIDTH_RATIO/2)
    .bottomSpaceToView(self.contentView, 10*WIDTH_RATIO/2)
    .rightSpaceToView(self.contentView, 70*WIDTH_RATIO/2);
}

- (void)setModel:(YZBaseModel *)model{
    [super setModel:model];
    if ([model isKindOfClass:[YZHomeModel class]]) {
        _myTitleLabel.text = [(id)model section_name];
    }else if ([model isKindOfClass:[YZDynamicModel class]]) {
        _myTitleLabel.text = [(id)model title];
    }
}

@end
