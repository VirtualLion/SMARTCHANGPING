//
//  YZInteractionVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZInteractionVC.h"

#import "YZDynamicModel.h"

#import "YZThingsTextCollectionCell.h"
#import "YZPointCollectionCell.h"
#import "YZToolCollectionReusableView.h"

@interface YZInteractionVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * myCollectionView;
@property (nonatomic, strong) NSMutableArray * listDatas;
@property (nonatomic, strong) NSMutableArray * hotLineDatas;

@end

@implementation YZInteractionVC

#pragma mark --- 数据请求

- (void)getInteractionData{
    WeakSelf;
    [YZNetMaster post:SERVER_INTERACTION_LIST parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [weakSelf.myCollectionView.mj_header endRefreshing];
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * hotlines = responseObject[@"data"][@"hotline"];
            if ([hotlines isKindOfClass:[NSArray class]]) {
                [weakSelf.hotLineDatas removeAllObjects];
                for (NSDictionary * dic in hotlines) {
                    [weakSelf.hotLineDatas addObject:[YZDynamicModel modelWithDic:dic]];
                }
            }
            NSArray * collects = responseObject[@"data"][@"collect"];
            if ([collects isKindOfClass:[NSArray class]]) {
                [weakSelf.listDatas removeAllObjects];
                for (NSDictionary * dic in collects) {
                    [weakSelf.listDatas addObject:[YZDynamicModel modelWithDic:dic]];
                }
                [weakSelf.myCollectionView reloadData];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf.myCollectionView.mj_header endRefreshing];
    }];
}

#pragma mark --- 懒加载
- (NSMutableArray *)listDatas{
    if (!_listDatas) {
        _listDatas = [NSMutableArray new];
    }
    return _listDatas;
}

- (NSMutableArray *)hotLineDatas{
    if (!_hotLineDatas) {
        _hotLineDatas = [NSMutableArray new];
        [self getInteractionData];
    }
    return _hotLineDatas;
}

#pragma mark --- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self changeBackBarButton];
    [self upView];
}

- (void)upView{
    
    YZCollectionViewFlowLayout * flowLayout = [YZCollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    flowLayout.headerReferenceSize = CGSizeMake(MY_WIDTH, 76*WIDTH_RATIO/2);
    
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _myCollectionView.backgroundColor = [UIColor clearColor];
    
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    
    [_myCollectionView registerClass:[YZPointCollectionCell class] forCellWithReuseIdentifier:@"hotLineCell"];
    [_myCollectionView registerClass:[YZThingsTextCollectionCell class] forCellWithReuseIdentifier:@"listCell"];
    [_myCollectionView registerClass:[YZToolCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view sd_addSubviews:@[_myCollectionView]];
    _myCollectionView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightSpaceToView(self.view, -0.1*WIDTH_RATIO)
    .bottomEqualToView(self.view);
    
    WeakSelf;
    _myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getInteractionData];
    }];
}

#pragma mark --- collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.hotLineDatas.count;
    }else{
        return self.listDatas.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(MY_WIDTH/2, 90*WIDTH_RATIO/2);
    }else{
        return CGSizeMake(MY_WIDTH, 80*WIDTH_RATIO/2);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YZBaseCollectionCell * cell;
    
    if (indexPath.section == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCell" forIndexPath:indexPath];
        cell.model = _hotLineDatas[indexPath.row];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotLineCell" forIndexPath:indexPath];
        cell.model = _listDatas[indexPath.row];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView * view;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YZToolCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            header.myTitleLabel.text = @"热线电话";
        }else{
            header.myTitleLabel.text = @"征集调查";
        }
        view = header;
    }
    
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.view.userInteractionEnabled = NO;
    YZDynamicModel * model;
    if (indexPath.section == 0) {
        model = _hotLineDatas[indexPath.row];
    }else{
        model = _listDatas[indexPath.row];
    }
    YZWabVC * webVC = [YZWabVC new];
    [webVC loadId:model.id];
//    webVC.hasShare = YES;
    webVC.title = @"详情";
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
