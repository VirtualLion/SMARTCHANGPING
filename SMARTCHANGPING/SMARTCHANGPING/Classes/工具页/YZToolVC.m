//
//  YZToolVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/5.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZToolVC.h"
#import "YZToolCollectionCell.h"
#import "YZToolCollectionReusableView.h"

#import "YZToolModel.h"

@interface YZToolVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * myCollectionView;
@property (nonatomic, strong) NSMutableArray * datas;
@property (nonatomic, strong) NSMutableArray * sectionTitles;

@end

@implementation YZToolVC
#pragma mark --- 请求数据
- (void)getToolData{
    WeakSelf;
    [YZNetMaster post:SERVER_TOOL_LIST parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * array = responseObject[@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                [weakSelf.datas removeAllObjects];
                for (NSDictionary * dic in array) {
                    [weakSelf.datas addObject:[YZToolClassModel modelWithDic:dic]];
                }
                [weakSelf.myCollectionView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];

    
}

#pragma mark --- 懒加载
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray new];
        [self getToolData];
    }
    return _datas;
}

#pragma mark --- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self upView];
}

- (void)upView{
    
    UICollectionViewFlowLayout * flowLayout = [UICollectionViewFlowLayout new];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 7*WIDTH_RATIO/2;
    flowLayout.minimumInteritemSpacing = 7*WIDTH_RATIO/2;
    flowLayout.estimatedItemSize = CGSizeMake(360*WIDTH_RATIO/2, 75*WIDTH_RATIO/2);
    flowLayout.itemSize = CGSizeMake(360*WIDTH_RATIO/2, 75*WIDTH_RATIO/2);
    flowLayout.headerReferenceSize = CGSizeMake(MY_WIDTH, 75*WIDTH_RATIO/2);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 15*WIDTH_RATIO/2, 10*WIDTH_RATIO/2);
    
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.bounces = NO;
    
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    
    [_myCollectionView registerClass:[YZToolCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    [_myCollectionView registerClass:[YZToolCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view sd_addSubviews:@[_myCollectionView]];
    _myCollectionView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
}

#pragma mark --- collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_datas[section] toolData].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YZToolCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = [_datas[indexPath.section] toolData][indexPath.item];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView * view;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YZToolCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        [header.myImgView sd_setImageWithURL:[NSURL URLWithString:[_datas[indexPath.section] tool_img_url]]];
        header.myTitleLabel.text = [_datas[indexPath.section] tool_name];
        
        view = header;
    }
    
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.view.userInteractionEnabled = NO;
    YZToolModel * model = [_datas[indexPath.section] toolData][indexPath.item];
    YZWabVC * webVC = [YZWabVC new];
    [webVC loadUrl:model.url];
    webVC.title = model.title;
    
    [[YZRootVC sharedManager].navigationController pushViewController:webVC animated:YES];
}

@end
