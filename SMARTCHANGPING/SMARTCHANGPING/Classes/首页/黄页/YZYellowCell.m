//
//  YZYellowCell.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZYellowCell.h"

#import "YZYellowMapVC.h"

#import "YZYellowModel.h"

@interface YZYellowCell ()<UIAlertViewDelegate>

@end

@implementation YZYellowCell

- (void)onBtn:(UIButton *)sender{
    self.sd_tableView.superview.userInteractionEnabled = NO;
    if (sender.tag == 100) {
        YZYellowMapVC * mapVC = [YZYellowMapVC new];
        mapVC.title = @"黄页";
        mapVC.model = (id)self.model;
        [[YZRootVC sharedManager].navigationController pushViewController:mapVC animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"呼叫电话：%@", [(id)self.model telephone]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        [alert show];
        self.sd_tableView.superview.userInteractionEnabled = YES;
    }
}

- (void)upView{
    self.selectionStyle = UIAccessibilityTraitNone;
    self.backgroundColor = YZ_COLOR(0xefefef);
    
    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView sd_addSubviews:@[backView]];
    backView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomSpaceToView(self.contentView, 15*WIDTH_RATIO/2);
    
    UIButton * btn1 = [UIButton new];
    btn1.tag = 100;
    [btn1 setBackgroundImage:[UIImage imageNamed:YELLOW_MAP_IMG] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btn2 = [UIButton new];
    btn2.tag = 101;
    [btn2 setBackgroundImage:[UIImage imageNamed:YELLOW_PHONE_IMG] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [backView sd_addSubviews:@[btn1, btn2]];
    
    btn2.sd_layout
    .widthIs(120*WIDTH_RATIO/2)
    .heightIs(110*WIDTH_RATIO/2)
    .rightSpaceToView(backView, 20*WIDTH_RATIO/2)
    .centerYEqualToView(backView);
    
    btn1.sd_layout
    .widthIs(120*WIDTH_RATIO/2)
    .heightIs(110*WIDTH_RATIO/2)
    .rightSpaceToView(btn2, 20*WIDTH_RATIO/2)
    .centerYEqualToView(backView);
    
    
    self.textLabel.font = [UIFont systemFontOfSize:26*WIDTH_RATIO/2];
    self.textLabel.textColor = YZ_COLOR(0x333333);
    self.textLabel.backgroundColor = [UIColor whiteColor];
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:22*WIDTH_RATIO/2];
    self.detailTextLabel.textColor = YZ_COLOR(0x999999);
    self.detailTextLabel.backgroundColor = [UIColor whiteColor];
    
    self.detailTextLabel.sd_layout.minHeightIs(44*WIDTH_RATIO/2);
    
    [self setModel:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
        NSString * phoneStr = [[[(id)self.model telephone] componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneStr]]];
    }
}

- (void)setModel:(YZBaseModel *)model{
    [super setModel:model];
    
    self.textLabel.text = [(id)model mechanism_name];
    self.detailTextLabel.text = [NSString stringWithFormat:@"地址：%@", [(id)model address]];
}

@end
