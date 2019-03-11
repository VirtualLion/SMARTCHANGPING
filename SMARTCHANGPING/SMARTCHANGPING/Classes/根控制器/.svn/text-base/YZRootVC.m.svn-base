//
//  YZRootVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/4.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZRootVC.h"

#import "YZMineVC.h"

@interface YZRootVC ()

@property (nonatomic, strong) UILabel * myTitleLabel;
@property (nonatomic, strong) NSArray * myRightBarButtons;
@property (nonatomic, strong) NSArray * myLeftBarButtons;

@end

@implementation YZRootVC

#pragma mark --- 事件处理

- (void)onRightBarButton:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    YZMineVC * mineVC = [YZMineVC new];
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:mineVC];
    [self presentViewController:nvc animated:YES completion:^{
        self.view.userInteractionEnabled = YES;
        sender.userInteractionEnabled = YES;
    }];
}

#pragma mark --- 生命周期
//单例
+ (YZRootVC *)sharedManager
{
    static YZRootVC *sharedYZRootVC = nil;
    static dispatch_once_t predicateRoot;
    dispatch_once(&predicateRoot, ^{
        sharedYZRootVC = [[self alloc] init];
    });
    return sharedYZRootVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self myNavbar];
    [self upView];
}

- (void)myNavbar{
    [super myNavbar];
    self.title = @"";
}

- (void)upView{
    
    YZMainTBC * mainTBC = [YZMainTBC sharedManager];
    [self.view addSubview:mainTBC.view];
}

//title
- (void)setTitle:(NSString *)title{
    if (![self.title isEqualToString:title]) {
        [super setTitle:title];
        if (title.length>0) {
            self.navigationItem.titleView = nil;
            self.navigationItem.rightBarButtonItems = nil;
            self.navigationItem.leftBarButtonItems = nil;
        }else{
            self.navigationItem.titleView = self.myTitleLabel;
//            self.navigationItem.rightBarButtonItems = self.myRightBarButtons;
            self.navigationItem.leftBarButtonItems = self.myLeftBarButtons;
        }
    }
}

#pragma mark --- 懒加载
- (UILabel *)myTitleLabel{
    if (!_myTitleLabel) {
        _myTitleLabel = [UILabel new];
        _myTitleLabel.textColor = [UIColor whiteColor];
        _myTitleLabel.textAlignment = NSTextAlignmentCenter;
        _myTitleLabel.frame = CGRectMake(0, 0, 100, 30);
        _myTitleLabel.numberOfLines = 2;
        
        NSString * str = @"社区之窗\nSMART CHANGPING";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:17]
                        range:[str rangeOfString:@"社区之窗"]];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:6.5]
                        range:[str rangeOfString:@"SMART CHANGPING"]];
        
        _myTitleLabel.attributedText = attrStr;
    }
    return _myTitleLabel;
}

- (NSArray *)myLeftBarButtons{
    if (!_myLeftBarButtons) {
        UIButton * btn = [UIButton  new];
        btn.tintColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setImage:[UIImage imageNamed:@"home_wz"] forState:UIControlStateNormal];
        [btn setTitle:@"昌平区" forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(8, 8, 0, 0)];
        btn.userInteractionEnabled = NO;
        
        btn.frame = CGRectMake(0, 0, 60, 40);
        UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10 * WIDTH_RATIO;
        
        _myLeftBarButtons = @[spaceItem, buttonItem];
    }
    return _myLeftBarButtons;
}

- (NSArray *)myRightBarButtons{
    if (!_myRightBarButtons) {
        UIButton * btn = [UIButton  new];
        btn.tintColor = [UIColor whiteColor];
        [btn setImage:[UIImage imageNamed:@"home_hy"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(8, 10, 0, 0)];
        [btn addTarget:self action:@selector(onRightBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.frame = CGRectMake(0, 0, 30, 40);
        UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -10 * WIDTH_RATIO;
        
        _myRightBarButtons = @[spaceItem, buttonItem];
    }
    return _myRightBarButtons;
}

@end
