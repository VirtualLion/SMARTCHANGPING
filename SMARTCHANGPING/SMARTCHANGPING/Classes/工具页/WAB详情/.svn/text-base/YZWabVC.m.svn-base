//
//  YZWabVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/10.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZWabVC.h"

@interface YZWabVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * myWebView;

@end

@implementation YZWabVC
#pragma mark --- 事件处理

#pragma mark --- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self changeBackBarButton];
}

- (void)loadId:(NSString *)news_id{
    [self loadUrl:[NSString stringWithFormat:@"%@%@?id=%@", YZ_SERVER, SERVER_NEWS_DETAILS, news_id]];
}

- (void)loadUrl:(NSString *)urlStr{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (UIWebView *)myWebView{
    if (!_myWebView) {
        _myWebView = [UIWebView new];
        _myWebView.delegate = self;
        //webView 去掉底部黑线
        _myWebView.opaque = NO;
        _myWebView.backgroundColor = [UIColor clearColor];
        [_myWebView setScalesPageToFit:YES];
        
        [self.view sd_addSubviews:@[_myWebView]];
        
        _myWebView.sd_layout
        .topEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
    }
    return _myWebView;
}


@end
