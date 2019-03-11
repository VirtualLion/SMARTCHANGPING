//
//  YZBaseVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/3.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZBaseVC.h"

@interface YZBaseVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scroll;
@property (nonatomic, strong) UILabel * scrollLine;
@property (nonatomic, strong) UIScrollView * scrollBtnView;

@end

@implementation YZBaseVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.userInteractionEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = YZ_COLOR(0xefefef);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

#pragma mark --- 导航栏
- (void)myNavbar{
    self.navigationController.navigationBar.translucent = NO;//首先要将当前的navigationBar的半透明设置为Yes;为NO的导航栏不透明
    self.navigationController.navigationBar.hidden = NO;
    //这里设置navigationBar的背景图片为一张 1像素 的透明背景图片
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)changeBackBarButton{
    [self changeBackBarButton:NAV_BACK];
}

- (void)changeBackBarButton:(NSString *)imgBack{
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 40, 60);
    
    [btn setImage:[UIImage imageNamed:imgBack] forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -20 * WIDTH_RATIO;
    
    self.navigationItem.leftBarButtonItems = @[spaceItem, back];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)goBackAction{
    // 在这里增加返回按钮的自定义动作
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)myKeyboardHide{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)setHasShare:(BOOL)hasShare{
    _hasShare = hasShare;
    if (hasShare) {
        [self upNav:@[[self myNavBtnItem:DETAIL_SHARE_IMG]]];
    }
}

- (void)setHasCollect:(BOOL)hasCollect{
    _hasCollect = hasCollect;
    if (hasCollect) {
        [self upNav:@[[self myNavBtnItem:DETAIL_COLLECT_IMG]]];
    }
}

- (void)setDoubleShare:(BOOL)doubleShare{
    _doubleShare = doubleShare;
    if (doubleShare) {
        [self upNav:@[[self myNavBtnItem:DETAIL_SHARE_IMG],
                      [self myNavBtnItem:DETAIL_COLLECT_IMG]]];
    }
}

- (void)upNav:(NSArray *)items{
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10 * WIDTH_RATIO;
    
    NSMutableArray * mut = [NSMutableArray new];
    [mut addObject:spaceItem];
    [mut addObjectsFromArray:items];
    
    self.navigationItem.rightBarButtonItems = mut;
}

- (UIBarButtonItem *)myNavBtnItem:(NSString *)imgName{
    
    UIButton * btn = [UIButton  new];
    btn.tintColor = [UIColor whiteColor];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn.imageView setSize:CGSizeMake(20.5, 19)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(4, 0, 0, 0)];
    [btn addTarget:self action:@selector(onRightBarButton:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(0, 0, 30, 40);
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    return buttonItem;
}

- (void)onRightBarButton:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    self.view.userInteractionEnabled = YES;
    sender.userInteractionEnabled = YES;
}

#pragma mark --- 滚动页
- (UIScrollView *)myScroll{
    if (!_scroll) {
        _scroll = [UIScrollView new];
        _scroll.backgroundColor = [UIColor clearColor];
        _scroll.bounces = NO;
        _scroll.pagingEnabled = YES;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.showsVerticalScrollIndicator = NO;
        _scroll.delegate = self;
        
        CGFloat btnHeight = ([self myScrollViewButtonHeight]+WIDTH_RATIO);
        CGRect frame = [self myScrollViewFrame];
        
        _scrollBtnView = [UIScrollView new];
        _scrollBtnView.bounces = NO;
        _scrollBtnView.pagingEnabled = NO;
        _scrollBtnView.showsHorizontalScrollIndicator = NO;
        _scrollBtnView.showsVerticalScrollIndicator = NO;
        _scrollBtnView.backgroundColor = [UIColor whiteColor];
        _scrollBtnView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, btnHeight-WIDTH_RATIO);
        
        frame.origin.y += btnHeight;
        frame.size.height -= btnHeight;
        _scroll.frame = frame;
        
        [self.view addSubview:_scrollBtnView];
        [self.view addSubview:_scroll];
        
        NSArray * titles = [self myScrollViewTitles];
        for (NSInteger i = 0; i < titles.count; i++) {
            UIButton * btn = [UIButton new];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:YZ_COLOR(0x333333) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(myScrollViewOnBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.frame = CGRectMake(_scrollBtnView.width/MIN(titles.count, 5)*i, 0, _scrollBtnView.width/MIN(titles.count, 5), btnHeight-WIDTH_RATIO);
            [_scrollBtnView addSubview:btn];
            
            if (i == 0) {
                btn.selected = YES;
                [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:30*WIDTH_RATIO/2]];
                
                _scrollLine = [UILabel new];
                _scrollLine.backgroundColor = [UIColor redColor];
                _scrollLine.frame = CGRectMake(0, btnHeight-8*WIDTH_RATIO/2, btn.width, 6*WIDTH_RATIO/2);
                [_scrollBtnView addSubview:_scrollLine];
            }else{
                btn.selected = NO;
                [btn.titleLabel setFont:[UIFont systemFontOfSize:30*WIDTH_RATIO/2]];
            }
            
            UIView * subView = [self myScrollViewContentViewWithItem:i];
            CGRect subFrame = _scroll.bounds;
            subFrame.origin.x = subFrame.size.width*i;
            subView.frame = subFrame;
            [_scroll addSubview:subView];
        }
        
        _scrollBtnView.contentSize = CGSizeMake(_scrollBtnView.width/MIN(titles.count, 5)*titles.count, _scrollBtnView.height);
        _scroll.contentSize = CGSizeMake(_scroll.width*titles.count, _scroll.height);
    }
    
    return _scroll;
}

- (CGFloat)myScrollViewButtonHeight{
    return 84*WIDTH_RATIO/2;
}

- (CGRect)myScrollViewFrame{
    
    return self.view.bounds;
}

- (NSArray *)myScrollViewTitles{
    return @[];
}

- (UIView *)myScrollViewContentViewWithItem:(NSInteger)item{
    return [UIView new];
}

- (void)myScrollViewOnBtn:(UIButton *)sender{
    if (sender.selected == NO) {
        [UIView animateWithDuration:0.25 animations:^{
            [_scroll setContentOffset:CGPointMake(_scroll.size.width*(sender.origin.x/sender.size.width), 0)];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _scroll) {
        _scrollLine.left = scrollView.contentOffset.x*CGRectGetWidth(_scrollLine.bounds)/CGRectGetWidth(scrollView.bounds);
        if (_scrollLine.right-_scrollBtnView.contentOffset.x > _scrollBtnView.width-2*WIDTH_RATIO) {
            if ((_scrollLine.right < _scrollBtnView.contentSize.width+2*WIDTH_RATIO)) {
                [UIView animateWithDuration:0.25 animations:^{
                    [_scrollBtnView setContentOffset:CGPointMake(MIN(_scrollLine.right+_scrollLine.width, _scrollBtnView.contentSize.width)-_scrollBtnView.width, 0)];
                } completion:^(BOOL finished) {
                }];
            }
        }else if (_scrollLine.left < _scrollBtnView.contentOffset.x+2*WIDTH_RATIO){
            if (_scrollLine.left > -2*WIDTH_RATIO) {
                [UIView animateWithDuration:0.25 animations:^{
                    [_scrollBtnView setContentOffset:CGPointMake(MAX(_scrollLine.left-_scrollLine.width, 0), 0)];
                } completion:^(BOOL finished) {
                }];
            }
        }
        
        for (UIButton * btn in _scrollBtnView.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                if (CGRectContainsPoint(btn.frame, _scrollLine.center)) {
                    btn.selected = YES;
                    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:30*WIDTH_RATIO/2]];
                }else{
                    btn.selected = NO;
                    [btn.titleLabel setFont:[UIFont systemFontOfSize:30*WIDTH_RATIO/2]];
                }
            }
        }
        return;
    }
}

#pragma mark --- 选择条
- (UIScrollView *)myScrollTitleButton{
    if (!_scroll) {
        _scroll = [UIScrollView new];
        _scroll.backgroundColor = [UIColor whiteColor];
        _scroll.bounces = NO;
        _scroll.pagingEnabled = NO;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.showsVerticalScrollIndicator = NO;
        
        _scroll.frame = [self myScrollViewFrame];
        [self.view addSubview:_scroll];
        
        NSArray * titles = [self myScrollViewTitles];
        
        if (titles.count > 0) {
            UIButton * allBtn = [UIButton new];
            [allBtn setTitle:@"全部" forState:UIControlStateNormal];
            [allBtn setTitleColor:YZ_COLOR(0x333333) forState:UIControlStateNormal];
            [allBtn addTarget:self action:@selector(onMyScrollTitleButton:) forControlEvents:UIControlEventTouchUpInside];
            allBtn.layer.borderColor = [YZ_COLOR(0x767978) CGColor];
            allBtn.layer.borderWidth = WIDTH_RATIO;
            allBtn.layer.cornerRadius = 30*WIDTH_RATIO/2;
            allBtn.clipsToBounds = YES;
            allBtn.tag = 99;
            
            allBtn.frame = CGRectMake(20*WIDTH_RATIO/2, (_scroll.height-60*WIDTH_RATIO/2)/2, 102*WIDTH_RATIO/2, 60*WIDTH_RATIO/2);
            
            allBtn.selected = YES;
            [allBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:26*WIDTH_RATIO/2]];
            
            [_scroll addSubview:allBtn];
        }
        
        for (NSInteger i = 0; i < titles.count; i++) {
            UIButton * btn = [UIButton new];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sh_dh%@",@(i%8+1)]] forState:UIControlStateNormal];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:YZ_COLOR(0x333333) forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 0, 0)];
            [btn addTarget:self action:@selector(onMyScrollTitleButton:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderColor = [YZ_COLOR(0x767978) CGColor];
            btn.layer.borderWidth = 0;
            btn.layer.cornerRadius = 30*WIDTH_RATIO/2;
            btn.clipsToBounds = YES;
            btn.tag = 100+i;
            
            btn.frame = CGRectMake(_scroll.subviews.lastObject.right+10*WIDTH_RATIO/2, (_scroll.height-60*WIDTH_RATIO/2)/2, [titles[i] length]*26*WIDTH_RATIO/2+60*WIDTH_RATIO/2, 60*WIDTH_RATIO/2);
            
            btn.selected = NO;
            [btn.titleLabel setFont:[UIFont systemFontOfSize:26*WIDTH_RATIO/2]];
            
            [_scroll addSubview:btn];
        }
        
        _scroll.contentSize = CGSizeMake(_scroll.subviews.lastObject.right+30*WIDTH_RATIO/2, _scroll.height);
    }
    
    return _scroll;
}

- (void)onMyScrollTitleButton:(UIButton *)sender{
    if (sender.selected == NO) {
        [self onTitleButtonItem:sender.tag-100];
        for (UIButton * btn in _scroll.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                if (btn.tag == sender.tag) {
                    btn.selected = YES;
                    btn.layer.borderWidth = WIDTH_RATIO;
                    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:26*WIDTH_RATIO/2]];
                }else{
                    btn.selected = NO;
                    btn.layer.borderWidth = 0;
                    [btn.titleLabel setFont:[UIFont systemFontOfSize:26*WIDTH_RATIO/2]];
                }
            }
        }
    }
}

- (void)chooseButtonItem:(NSInteger)item{
    UIButton * btn = [UIButton new];
    btn.tag = 100+item;
    [self onMyScrollTitleButton:btn];
}

- (void)onTitleButtonItem:(NSInteger)item{
    
}

@end
