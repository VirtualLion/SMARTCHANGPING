//
//  YZChooseVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZChooseVC.h"

#import "YZHomeThingsCell.h"
#import "YZHomeModel.h"

#import "YZHomeVC.h"

@interface YZChooseVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray * themeDatas;

@end

@implementation YZChooseVC

#pragma mark --- 事件处理
- (void)goBackAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)onRightBarButton:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    [self getThemeUpDate];
    sender.userInteractionEnabled = YES;
}

#pragma mark --- 数据请求
- (void)getThemeData{
    WeakSelf;
    [YZNetMaster post:SERVER_THINGS_THEME parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]]) {
                [weakSelf.themeDatas removeAllObjects];
                for (NSDictionary * dic in dataArray) {
                    YZHomeModel * model = [YZHomeModel modelWithDic:dic];
                    if ([_themes containsObject:model.theme_id]) {
                        model.isChoose = YES;
                    }else{
                        model.isChoose = NO;
                    }
                    [weakSelf.themeDatas addObject:model];
                }
                [weakSelf.view.subviews.firstObject reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

- (void)getThemeUpDate{
    
    NSMutableArray * mutArray = [NSMutableArray new];
    NSMutableArray * themesArray = [NSMutableArray new];
    for (YZHomeModel * model in _themeDatas) {
        if (model.isChoose) {
            [themesArray addObject:[NSString stringWithFormat:@"%@", model.theme_id]];
            [mutArray addObject:model];
        }
    }
    [mutArray addObject:@""];
    
    NSDictionary * parameters = @{@"theme":[themesArray componentsJoinedByString:@","]};
    WeakSelf;
    [YZNetMaster post:SERVER_THEME_UPDATE parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [(YZHomeVC *)[YZMainTBC sharedManager].viewControllers.firstObject loadThingsData:mutArray];
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                weakSelf.view.userInteractionEnabled = YES;
            }];
        }else{
            [YZProgressHUD showHudFailed:responseObject[@"info"]];
            weakSelf.view.userInteractionEnabled = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        weakSelf.view.userInteractionEnabled = YES;
    }];
}

#pragma mark --- 懒加载
- (NSMutableArray *)themeDatas{
    if (!_themeDatas) {
        _themeDatas = [NSMutableArray new];
        [self getThemeData];
    }
    return _themeDatas;
}

#pragma mark --- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self myNavbar];
    self.title = @"添加办事主题";
    [self changeBackBarButton:NAV_DISMISS];
    self.navigationItem.rightBarButtonItems = [self myRightBarButtons];
    [self upView];
}

- (NSArray *)myRightBarButtons{
    UIButton * btn = [UIButton  new];
    btn.tintColor = [UIColor whiteColor];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [btn addTarget:self action:@selector(onRightBarButton:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(0, 0, 30, 40);
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10 * WIDTH_RATIO;
    
    return @[spaceItem, buttonItem];
}

- (void)upView{
    UICollectionViewFlowLayout * flowLayout = [UICollectionViewFlowLayout new];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = WIDTH_RATIO;
    flowLayout.minimumInteritemSpacing = WIDTH_RATIO;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    flowLayout.estimatedItemSize = CGSizeMake(248*WIDTH_RATIO/2, 190*WIDTH_RATIO/2);
    flowLayout.estimatedItemSize = CGSizeMake(248*WIDTH_RATIO/2, 190*WIDTH_RATIO/2);
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.bounces = NO;
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [collectionView registerClass:[YZHomeThingsCell class] forCellWithReuseIdentifier:@"cell"];

    [self.view sd_addSubviews:@[collectionView]];
    collectionView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
}

#pragma mark --- collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.themeDatas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHomeThingsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.choButton.hidden = NO;
    if (_themeDatas.count > indexPath.row) {
        cell.model = _themeDatas[indexPath.item];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YZHomeThingsCell * cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    
    [(id)cell.model setIsChoose:![(id)cell.model isChoose]];
    cell.model = cell.model;
}

@end
