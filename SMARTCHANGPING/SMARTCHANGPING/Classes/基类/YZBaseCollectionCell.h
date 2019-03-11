//
//  YZBaseCollectionCell.h
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZBaseCollectionCell : UICollectionViewCell

@property (nonatomic, strong) YZBaseModel * model;

- (void)upView;

@end
