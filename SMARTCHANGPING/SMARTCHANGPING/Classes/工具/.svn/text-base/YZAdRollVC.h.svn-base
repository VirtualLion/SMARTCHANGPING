//
//  YZAdRollVC.h
//  YZADRollDemo
//
//  Created by 韩云智 on 16/6/21.
//  Copyright © 2016年 YZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZAdRollVC : UIViewController

//轮播主视图
@property (nonatomic, strong) UIView * rollView;

//数据源，可随时更变
@property (nonatomic, strong) NSMutableArray * dataSource;

//正在显示第几张，可改变下一张显示第几张，滚动时改变可能发生短暂性错乱
@property (nonatomic, assign) NSInteger num;

//用于自定义pageControl样式与位置，必须先启动后更改
@property (nonatomic, strong) UIPageControl * pageControl;

//定时器每0.01秒的刷新偏移量,可以改变滚动方向，0无效
@property (nonatomic, assign) float timerOffset;
//定时器启动的时间间隔,小于0无效
@property (nonatomic, assign) float timerInterval;

//设置轮播图滚动方向随手势变化
@property (nonatomic, assign) BOOL isScrollWithSign;

//创建轮播视图时设定frame
//第一个block参数是 轮播图点击事件
//第二个block参数是 cell展示的回调方法 前两个参数 主要作用是 实现网络图片imageView与SDWebImage ；后两个参数 也可以自定义cell的内容 每次需创建视图所以要记得及时removesubviews 不建议使用
- (instancetype)initWithFrame:(CGRect)frame didSelectAtItem:(void (^)(NSInteger item)) selectBlock cellWebImage:(BOOL (^)(UIImageView * cellImageView,id content, UIView * cellContentView, NSInteger item)) cellImageViewBlock;

//启动或关闭定时器
- (void)letTimerRun;
- (void)letTimerStop;

//启动PageControl
- (void)letPageControlRun;

//用于自定义重新创建PageControl的点击事件
- (void)pageControlChanged:(UIPageControl *)pageControl;

@end
