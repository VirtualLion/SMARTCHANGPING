//
//  YZBaseVC.h
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/3.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZBaseVC : UIViewController

//导航栏
- (void)myNavbar;
- (void)changeBackBarButton;
- (void)goBackAction;
- (void)changeBackBarButton:(NSString *)imgBack;

@property (nonatomic, assign) BOOL hasShare;
@property (nonatomic, assign) BOOL doubleShare;
@property (nonatomic, assign) BOOL hasCollect;

//滚动分页
- (UIScrollView *)myScroll;
- (CGFloat)myScrollViewButtonHeight;
- (CGRect)myScrollViewFrame;
- (NSArray *)myScrollViewTitles;
- (UIView *)myScrollViewContentViewWithItem:(NSInteger)item;
//选择条
- (UIScrollView *)myScrollTitleButton;
- (void)onTitleButtonItem:(NSInteger)item;
- (void)chooseButtonItem:(NSInteger)item;

@end
