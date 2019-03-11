//
//  YZBaseCollectionCell.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZBaseCollectionCell.h"

@implementation YZBaseCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self upView];
    }
    return self;
}

- (void)upView{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setModel:(YZBaseModel *)model{
    _model = model;
}

@end
