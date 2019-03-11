//
//  YZThingsVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/6.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZThingsVC.h"

#import "YZThingsTextCollectionCell.h"
#import "YZHomeThingsCell.h"
#import "YZHomeModel.h"

#import "YZThingsListVC.h"

@interface YZThingsVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray * departmentDatas;
@property (nonatomic, strong) NSMutableArray * themeDatas;

@end

@implementation YZThingsVC

#pragma mark --- 事件处理
- (void)onBtn:(UIButton *)sender{
    
}

#pragma mark --- 数据请求
- (void)getDepartmentData{
    WeakSelf;
    [YZNetMaster post:SERVER_THINGS_DEPARTMENT parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [[[[weakSelf myScroll] viewWithTag:100] mj_header] endRefreshing];
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]]) {
                [weakSelf.departmentDatas removeAllObjects];
                for (NSDictionary * dic in dataArray) {
                    [weakSelf.departmentDatas addObject:[YZHomeModel modelWithDic:dic]];
                }
                [[[weakSelf myScroll] viewWithTag:100] reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [[[[weakSelf myScroll] viewWithTag:100] mj_header] endRefreshing];
    }];
}
- (void)getThemeData{
    WeakSelf;
    [YZNetMaster post:SERVER_THINGS_THEME parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [[[[weakSelf myScroll] viewWithTag:101] mj_header] endRefreshing];
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]]) {
                [weakSelf.themeDatas removeAllObjects];
                for (NSDictionary * dic in dataArray) {
                    [weakSelf.themeDatas addObject:[YZHomeModel modelWithDic:dic]];
                }
                [[[weakSelf myScroll] viewWithTag:101] reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [[[[weakSelf myScroll] viewWithTag:101] mj_header] endRefreshing];
    }];
}

#pragma mark --- 懒加载
- (NSMutableArray *)departmentDatas{
    if (!_departmentDatas) {
        _departmentDatas = [NSMutableArray new];
        [self getDepartmentData];
    }
    return _departmentDatas;
}

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
    
    [self upView];
    [self myScroll];
}

- (void)upView{
    
    UIButton * searchBtn = [UIButton new];
    searchBtn.backgroundColor = [UIColor whiteColor];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:YZ_COLOR(0x999999) forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:26*WIDTH_RATIO/2]];
    [searchBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view sd_addSubviews:@[searchBtn]];
    
    searchBtn.sd_layout
    .topSpaceToView(self.view, 16*WIDTH_RATIO/2)
    .leftSpaceToView(self.view, 24*WIDTH_RATIO/2)
    .rightSpaceToView(self.view, 24*WIDTH_RATIO/2)
    .heightIs(64*WIDTH_RATIO/2);
    searchBtn.sd_cornerRadiusFromHeightRatio = @(0.2);
}

- (NSArray *)myScrollViewTitles{
    return THINGS_SCOLLBTN_TITLES;
}

- (CGRect)myScrollViewFrame{
    CGRect frame = self.view.bounds;
    frame.origin.y = 96*WIDTH_RATIO/2;
    frame.size.height = MY_HEIGHT - 113 - 96*WIDTH_RATIO/2;
    return frame;
}

- (UIView *)myScrollViewContentViewWithItem:(NSInteger)item{
    
    YZCollectionViewFlowLayout * flowLayout = [YZCollectionViewFlowLayout new];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = WIDTH_RATIO;
    flowLayout.minimumInteritemSpacing = WIDTH_RATIO;
    flowLayout.sectionInset = UIEdgeInsetsMake(2*WIDTH_RATIO, 0, 0, 0);
    
    switch (item) {
        case 1:
            flowLayout.estimatedItemSize = CGSizeMake(248*WIDTH_RATIO/2, 187*WIDTH_RATIO/2);
            flowLayout.estimatedItemSize = CGSizeMake(248*WIDTH_RATIO/2, 187*WIDTH_RATIO/2);
            break;
            
        default:
            flowLayout.estimatedItemSize = CGSizeMake(747*WIDTH_RATIO/4, 120*WIDTH_RATIO/2);
            flowLayout.estimatedItemSize = CGSizeMake(747*WIDTH_RATIO/4, 120*WIDTH_RATIO/2);
            break;
    }
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
//    collectionView.bounces = NO;
    collectionView.tag = 100+item;
    WeakSelf;
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        switch (item) {
            case 1:
                [weakSelf getThemeData];
                break;
            default:
                [weakSelf getDepartmentData];
                break;
        }
    }];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    switch (item) {
        case 1:
            [collectionView registerClass:[YZHomeThingsCell class] forCellWithReuseIdentifier:@"cell"];
            break;
        default:
            [collectionView registerClass:[YZThingsTextCollectionCell class] forCellWithReuseIdentifier:@"cell"];
            break;
    }
    
    return collectionView;
}

#pragma mark --- collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 101) {
        return self.themeDatas.count;
    }
    return self.departmentDatas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YZBaseCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (collectionView.tag == 101) {
        if (_themeDatas.count>indexPath.item) {
            cell.model = _themeDatas[indexPath.item];
        }
    }else{
        if (_departmentDatas.count>indexPath.item) {
            cell.model = _departmentDatas[indexPath.item];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YZBaseCollectionCell * cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    YZHomeModel * model = (id)cell.model;
    
    self.view.userInteractionEnabled = NO;
    YZThingsListVC * listVC = [YZThingsListVC new];
    listVC.title = @"办事指南";
    listVC.section_id = [NSString stringWithFormat:@"%@", model.section_id?model.section_id:@""];
    listVC.theme_id = [NSString stringWithFormat:@"%@", model.theme_id?model.theme_id:@""];
    [[YZRootVC sharedManager].navigationController pushViewController:listVC animated:YES];
}


@end
