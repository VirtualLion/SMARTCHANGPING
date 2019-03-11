//
//  YZLifeListVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/12.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZLifeListVC.h"

#import "YZImageCut.h"

#import "YZLifeDetailVC.h"

#import "YZLifeModel.h"

@interface YZLifeListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * myTableView;

@property (nonatomic, strong) NSMutableArray * titles;

@property (nonatomic, strong) NSMutableArray * listDatas;

@end

@implementation YZLifeListVC
#pragma mark --- 事件处理
- (void)onTitleButtonItem:(NSInteger)item{
    if (item < 0) {
        [self getLifeList:@"" page:1];
    }else{
        [self getLifeList:[_titles[item] lc_id] page:1];
    }
}

- (void)onBtn:(UIButton *)sender{
    
}

#pragma mark --- 获取数据
- (void)getTitleData{
    WeakSelf;
    [YZNetMaster post:SERVER_LIFE_CATE parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * array = responseObject[@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                [weakSelf.titles removeAllObjects];
                for (NSDictionary * dic in array) {
                    [weakSelf.titles addObject:[YZLifeModel modelWithDic:dic]];
                }
                [weakSelf myScrollTitleButton];
                [weakSelf chooseButtonItem:-1]; 
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

- (void)getLifeList:(NSString *)lc_id page:(NSInteger)page{
    
    _lc_id = lc_id;
    NSDictionary * parameters = @{@"lc_id":lc_id,
                                  @"page":@(page),
                                  @"pagenum":@(10),
                                  @"longitude":@([YZLocationManager sharedManager].location.coordinate.longitude),
                                  @"latitude":@([YZLocationManager sharedManager].location.coordinate.latitude)};
    WeakSelf;
    [YZNetMaster post:SERVER_LIFE_LIST parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf.myTableView.mj_header endRefreshing];
        [weakSelf.myTableView.mj_footer endRefreshing];
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * array = responseObject[@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                if (array.count < 10) {
                    [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                }
                if (page == 1) {
                    [weakSelf.listDatas removeAllObjects];
                }
                for (NSDictionary * dic in array) {
                    [weakSelf.listDatas addObject:[YZLifeModel modelWithDic:dic]];
                }
                [weakSelf.myTableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf.myTableView.mj_header endRefreshing];
        [weakSelf.myTableView.mj_footer endRefreshing];
    }];
}

#pragma mark --- 懒加载
- (NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray new];
    }
    return _titles;
}

- (NSMutableArray *)listDatas{
    if (!_listDatas) {
        _listDatas = [NSMutableArray new];
    }
    return _listDatas;
}

#pragma mark --- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self changeBackBarButton];
    [self getTitleData];
    [self upView];
}

- (CGRect)myScrollViewFrame{
    return CGRectMake(0, 0, MY_WIDTH, 86*WIDTH_RATIO/2);
}

- (NSArray *)myScrollViewTitles{
    NSMutableArray * mut = [NSMutableArray new];
    for (YZLifeModel * model in _titles) {
        [mut addObject:model.lc_name];
    }
    return mut;
}

- (void)upView{
    
    UIButton * searchBtn = [UIButton new];
    searchBtn.backgroundColor = [UIColor whiteColor];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:YZ_COLOR(0x999999) forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:26*WIDTH_RATIO/2]];
    [searchBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _myTableView = [UITableView new];
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.estimatedRowHeight = 124*WIDTH_RATIO/2;
    _myTableView.rowHeight = 124*WIDTH_RATIO/2;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [UIView new];
    
    [self.view sd_addSubviews:@[searchBtn, _myTableView]];
    
    searchBtn.sd_layout
    .topSpaceToView(self.view, 104*WIDTH_RATIO/2)
    .leftSpaceToView(self.view, 24*WIDTH_RATIO/2)
    .rightSpaceToView(self.view, 24*WIDTH_RATIO/2)
    .heightIs(64*WIDTH_RATIO/2);
    searchBtn.sd_cornerRadiusFromHeightRatio = @(0.2);
    
    _myTableView.sd_layout
    .topSpaceToView(searchBtn, 16*WIDTH_RATIO/2)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    WeakSelf;
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getLifeList:_lc_id page:1];
    }];
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getLifeList:_lc_id page:weakSelf.listDatas.count/10+1];
    }];
}

#pragma mark --- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:26*WIDTH_RATIO/2];
        cell.textLabel.textColor = YZ_COLOR(0x333333);
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:22*WIDTH_RATIO/2];
        cell.detailTextLabel.textColor = YZ_COLOR(0x999999);
        
        cell.detailTextLabel.sd_layout.minHeightIs(44*WIDTH_RATIO/2);
    }
    
//    cell.imageView.image = [YZImageCut imageWithImageSimple:[UIImage imageNamed:@"home-bdth"] scaledToSize:CGSizeMake(112*WIDTH_RATIO/2, 92*WIDTH_RATIO/2)];
    YZLifeModel * model = _listDatas[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.shop_img_url] placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMG]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.shop_img_url] placeholderImage:[YZImageCut imageWithImageSimple:[UIImage imageNamed:PLACEHOLDER_IMG] scaledToSize:CGSizeMake(112*WIDTH_RATIO/2, 92*WIDTH_RATIO/2)] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            cell.imageView.image = [YZImageCut imageWithImageSimple:[YZImageCut cutImage:image toSize:CGSizeMake(112*WIDTH_RATIO/2, 92*WIDTH_RATIO/2)] scaledToSize:CGSizeMake(112*WIDTH_RATIO/2, 92*WIDTH_RATIO/2)];
        }
    }];
    cell.textLabel.text = model.title;
    NSString * distance = model.distance;
    if (model.distance.doubleValue > 999) {
        distance = [NSString stringWithFormat:@"%@千", @(model.distance.integerValue/1000)];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"距离：%@米", distance];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.view.userInteractionEnabled = NO;
    YZLifeDetailVC * detailVC = [YZLifeDetailVC new];
    detailVC.life_id = [_listDatas[indexPath.row] life_id];
//    detailVC.doubleShare = YES;
    detailVC.title = @"详情";
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 用于将cell分割线补全
-(void)viewDidLayoutSubviews {
    if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myTableView setSeparatorInset:UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 0, 10*WIDTH_RATIO/2)];
    }
    if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_myTableView setLayoutMargins:UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 0, 10*WIDTH_RATIO/2)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 0, 10*WIDTH_RATIO/2)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 0, 10*WIDTH_RATIO/2)];
    }
}

@end
