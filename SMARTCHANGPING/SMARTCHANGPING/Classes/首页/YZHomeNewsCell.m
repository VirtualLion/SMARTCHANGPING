//
//  YZHomeNewsCell.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZHomeNewsCell.h"

#import "YZHomeModel.h"

@interface YZHomeNewsCell ()

@property (nonatomic, strong) UIScrollView * scrView;
@property (nonatomic, strong) UIImageView * imgView;

@property (nonatomic, strong) UILabel * titLabel;
@property (nonatomic, strong) UILabel * texLabel;
@property (nonatomic, strong) UILabel * titLabel0;
@property (nonatomic, strong) UILabel * texLabel0;

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSArray * models;

@end

@implementation YZHomeNewsCell

- (void)beginScroll{
    [UIView animateWithDuration:1 delay:2.5 options:0 animations:^{
        [_scrView setContentOffset:CGPointZero];
    } completion:^(BOOL finished) {
        if (finished) {
            _page++;
            [super setModel:_models[_page%_models.count]];
            [_scrView setContentOffset:CGPointMake(0, 132*WIDTH_RATIO/2)];
            _titLabel.text = [_models[_page%_models.count] title];
            _texLabel.text = [NSString stringWithFormat:@"来源：%@",[_models[_page%_models.count] author]];
            _titLabel0.text = [_models[(_page+1)%_models.count] title];
            _texLabel0.text = [NSString stringWithFormat:@"来源：%@",[_models[(_page+1)%_models.count] author]];
            [self beginScroll];
        }
    }];
    
}

- (void)upView{
    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel * line = [UILabel new];
    line.backgroundColor = YZ_COLOR(0xefefef);
    
    [self.contentView sd_addSubviews:@[backView]];
    backView.sd_layout
    .topSpaceToView(self.contentView, 15*WIDTH_RATIO/2)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomSpaceToView(self.contentView, 15*WIDTH_RATIO/2);
    
    _imgView = [UIImageView new];
    _imgView.image = [UIImage imageNamed:HOME_NEWS_IMG];
    
    _scrView = [UIScrollView new];
    _scrView.bounces = NO;
    _scrView.scrollsToTop = NO;
    _scrView.pagingEnabled = YES;
    _scrView.userInteractionEnabled = NO;
    _scrView.showsVerticalScrollIndicator = NO;
    _scrView.showsHorizontalScrollIndicator = NO;
    
    [backView sd_addSubviews:@[_imgView, line, _scrView]];
    
    _imgView.sd_layout
    .widthIs(73*WIDTH_RATIO/2)
    .heightIs(68*WIDTH_RATIO/2)
    .centerYEqualToView(backView)
    .leftSpaceToView(backView, 18*WIDTH_RATIO/2);
    
    line.sd_layout
    .widthIs(WIDTH_RATIO)
    .leftSpaceToView(backView, 109*WIDTH_RATIO/2)
    .topSpaceToView(backView, 20*WIDTH_RATIO/2)
    .bottomSpaceToView(backView, 20*WIDTH_RATIO/2);

    _scrView.sd_layout
    .topEqualToView(backView)
    .leftSpaceToView(line, 15*WIDTH_RATIO/2)
    .rightSpaceToView(backView, 15*WIDTH_RATIO/2)
    .bottomEqualToView(backView);
    
    _scrView.contentSize = CGSizeMake(610*WIDTH_RATIO/2, 132*WIDTH_RATIO);
    [_scrView setContentOffset:CGPointMake(0, 132*WIDTH_RATIO/2)];
    
    _titLabel = [UILabel new];
    _titLabel.font = [UIFont boldSystemFontOfSize:27*WIDTH_RATIO/2];
    _titLabel.textColor = YZ_COLOR(0x333333);
    _titLabel.numberOfLines = 1;
    
    _texLabel = [UILabel new];
    _texLabel.font = [UIFont systemFontOfSize:21*WIDTH_RATIO/2];
    _texLabel.textColor = YZ_COLOR(0x999999);
    
    _titLabel0 = [UILabel new];
    _titLabel0.font = [UIFont boldSystemFontOfSize:27*WIDTH_RATIO/2];
    _titLabel0.textColor = YZ_COLOR(0x333333);
    
    _texLabel0 = [UILabel new];
    _texLabel0.font = [UIFont systemFontOfSize:21*WIDTH_RATIO/2];
    _texLabel0.textColor = YZ_COLOR(0x999999);
    
    [_scrView sd_addSubviews:@[_titLabel0, _texLabel0, _titLabel, _texLabel]];
    
    _titLabel0.sd_layout
    .leftEqualToView(_scrView)
    .rightEqualToView(_scrView)
    .topSpaceToView(_scrView, 32*WIDTH_RATIO/2)
    .heightIs(28*WIDTH_RATIO/2);
//    .autoHeightRatio(0);
    
    _texLabel0.sd_layout
    .leftEqualToView(_scrView)
    .rightEqualToView(_scrView)
    .topSpaceToView(_titLabel0, 10*WIDTH_RATIO/2)
    .heightIs(22*WIDTH_RATIO/2);
//    .autoHeightRatio(0);
    
    _titLabel.sd_layout
    .leftEqualToView(_scrView)
    .rightEqualToView(_scrView)
    .topSpaceToView(_scrView, 164*WIDTH_RATIO/2)
    .heightIs(28*WIDTH_RATIO/2);
//    .autoHeightRatio(0);
    
    _texLabel.sd_layout
    .leftEqualToView(_scrView)
    .rightEqualToView(_scrView)
    .topSpaceToView(_titLabel, 10*WIDTH_RATIO/2)
    .heightIs(22*WIDTH_RATIO/2);
//    .autoHeightRatio(0);
}

- (void)setModel:(YZBaseModel *)model{
    _models = (id)model;
    [_scrView.layer removeAllAnimations];
    [_scrView setContentOffset:CGPointMake(0, 132*WIDTH_RATIO/2)];
    
    if (![_models isEqualToArray:(id)model]) {
        _page = 0;
        [super setModel:_models.firstObject];
    }
    
    if (_models.count > 0) {
        _titLabel.text = [_models[_page%_models.count] title];
        _texLabel.text = [NSString stringWithFormat:@"来源：%@",[_models[_page%_models.count] author]];
    }
    if (_models.count>1) {
        _titLabel0.text = [_models[(_page+1)%_models.count] title];
        _texLabel0.text = [NSString stringWithFormat:@"来源：%@",[_models[(_page+1)%_models.count] author]];
        [self beginScroll];
    }
}


@end
