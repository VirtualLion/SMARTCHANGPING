//
//  YZToolCollectionReusableView.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/5.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZToolCollectionReusableView.h"

@implementation YZToolCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self upView];
    }
    return self;
}

- (void)upView{
    
    _myImgView = [UIImageView new];
    
    _myTitleLabel = [UILabel new];
    _myTitleLabel.font = [UIFont boldSystemFontOfSize:27*WIDTH_RATIO/2];
    _myTitleLabel.textColor = YZ_COLOR(0x333333);
    
    [self sd_addSubviews:@[_myImgView, _myTitleLabel]];
    
    _myImgView.sd_layout
    .widthIs(34*WIDTH_RATIO/2)
    .heightEqualToWidth()
    .leftSpaceToView(self, 10*WIDTH_RATIO/2)
    .centerYEqualToView(self);
    
    _myTitleLabel.sd_layout
    .topEqualToView(self)
    .bottomEqualToView(self)
    .leftSpaceToView(_myImgView, 10*WIDTH_RATIO/2)
    .rightSpaceToView(self, 10*WIDTH_RATIO/2);
}

@end
