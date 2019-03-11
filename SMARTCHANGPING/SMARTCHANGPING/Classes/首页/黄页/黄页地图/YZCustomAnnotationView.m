//
//  YZCustomAnnotationView.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/13.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZCustomAnnotationView.h"

#import "GPSNaviViewController.h"

@implementation YZCustomAnnotationView

- (void)onBtn:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    GPSNaviViewController * gpsVC = [GPSNaviViewController new];
    gpsVC.coorinate = [self.annotation coordinate];
    [[YZRootVC sharedManager] presentViewController:gpsVC animated:YES completion:^{
        sender.userInteractionEnabled = YES;
    }];
}

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self){
        self.canShowCallout = NO;
        self.draggable = NO;
        self.centerOffset = CGPointMake(0, -126*WIDTH_RATIO/4);
        [self upView];
    }
    
    return self;
}

- (void)upView{
    
    self.bounds = CGRectMake(0, 0, 564*WIDTH_RATIO/2, 126*WIDTH_RATIO/2);
    UIImageView * backImgView = [UIImageView new];
    backImgView.userInteractionEnabled = YES;
    backImgView.frame = self.bounds;
    backImgView.image = [UIImage imageNamed:@"hy_map"];
    [self addSubview:backImgView];
    
    UIButton * btn = [UIButton new];
    [btn setBackgroundImage:[UIImage imageNamed:@"dh"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    UILabel * titLabel = [UILabel new];
    titLabel.textColor = [UIColor whiteColor];
    titLabel.font = [UIFont systemFontOfSize:26*WIDTH_RATIO/2];
    UILabel * subLabel = [UILabel new];
    subLabel.textColor = [UIColor whiteColor];
    subLabel.font = [UIFont systemFontOfSize:22*WIDTH_RATIO/2];
    
    [backImgView sd_addSubviews:@[btn, titLabel, subLabel]];
    
    btn.sd_layout
    .widthIs(90*WIDTH_RATIO/2)
    .heightIs(66*WIDTH_RATIO/2)
    .topSpaceToView(backImgView, 20*WIDTH_RATIO/2)
    .rightSpaceToView(backImgView, 20*WIDTH_RATIO/2);
    
    titLabel.sd_layout
    .topEqualToView(btn)
    .leftSpaceToView(backImgView, 20*WIDTH_RATIO/2)
    .rightSpaceToView(btn, 20*WIDTH_RATIO/2)
    .autoHeightRatio(0);
    
    subLabel.sd_layout
    .bottomEqualToView(btn)
    .leftEqualToView(titLabel)
    .rightEqualToView(titLabel)
    .autoHeightRatio(0);
    
    titLabel.text = [self.annotation title];
    subLabel.text = [self.annotation subtitle];
}

@end
