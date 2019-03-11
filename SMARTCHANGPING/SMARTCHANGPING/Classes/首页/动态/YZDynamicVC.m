//
//  YZDynamicVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZDynamicVC.h"

#import "YZDynamicModel.h"

@interface YZDynamicVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView * scrView;

@property (nonatomic, strong) NSMutableArray * idDatas;
@property (nonatomic, strong) NSMutableArray * nameDatas;
@property (nonatomic, strong) NSMutableArray * listDatas;

@end

@implementation YZDynamicVC
#pragma mark --- 数据请求
- (void)getDynamicNameData{
    if (!_idDatas) {
        _idDatas = [NSMutableArray new];
    }
    if (!_nameDatas) {
        _nameDatas = [NSMutableArray new];
    }
    if (!_listDatas) {
        _listDatas = [NSMutableArray new];
    }
    NSDictionary * parameters = @{@"page":@(1),
                                  @"pagenum":@(100)};
    WeakSelf;
    [YZNetMaster post:SERVER_DYNAMIC_TITLES parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]]) {
                [_idDatas removeAllObjects];
                [_nameDatas removeAllObjects];
                for (NSDictionary * dic in dataArray) {
                    [_idDatas addObject:dic[@"cat_id"]];
                    [_nameDatas addObject:dic[@"cat_name"]];
                    [_listDatas addObject:@[]];
                }
                weakSelf.scrView = [weakSelf myScroll];
                [weakSelf loadListData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

- (void)getListDataPage:(NSInteger)page item:(NSInteger)item {
    NSDictionary * parameters = @{@"cat_id":_idDatas[item],
                                  @"page":@(page),
                                  @"pagenum":@(10)};
    UITableView * tableView = [_scrView viewWithTag:100+item];
    NSMutableArray * mutArray;
    if (page == 1) {
        mutArray = [NSMutableArray new];
    }else{
        mutArray = _listDatas[item];
    }
    WeakSelf;
    [YZNetMaster post:SERVER_DYNAMIC_LIST parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [tableView.mj_header endRefreshing];
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]]) {
                if (page == 1) {
                    [mutArray removeAllObjects];
                    [tableView.mj_footer resetNoMoreData];
                }
                if (dataArray.count == 10) {
                    [tableView.mj_footer endRefreshing];
                }else{
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                }
                for (NSDictionary * dic in dataArray) {
                    [mutArray addObject:[YZDynamicModel modelWithDic:dic]];
                }
                [weakSelf.listDatas setObject:mutArray atIndexedSubscript:item];
                
                [tableView reloadData];
                
            }else{
                [tableView.mj_footer endRefreshing];
            }
        }else{
            [tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
    }];
}

#pragma mark --- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self changeBackBarButton];
    [self getDynamicNameData];
}

- (void)loadListData{
    for (NSInteger i = 0; i<_listDatas.count; i++) {
        [self getListDataPage:1 item:i];
    }
}

- (NSArray *)myScrollViewTitles{
    return _nameDatas;
}

- (UIView *)myScrollViewContentViewWithItem:(NSInteger)item{
    UITableView * tableView = [UITableView new];
    tableView.tag = 100+item;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.estimatedRowHeight = 132*WIDTH_RATIO/2;
    tableView.rowHeight = 132*WIDTH_RATIO/2;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    
    WeakSelf;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getListDataPage:1 item:item];
    }];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getListDataPage:[weakSelf.listDatas[item] count]/10+1 item:item];
    }];
    
    return tableView;
}

#pragma mark --- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listDatas[tableView.tag - 100] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont systemFontOfSize:26*WIDTH_RATIO/2];
        cell.textLabel.textColor = YZ_COLOR(0x333333);
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:22*WIDTH_RATIO/2];
        cell.detailTextLabel.textColor = YZ_COLOR(0x999999);
        
        cell.detailTextLabel.sd_layout.minHeightIs(44*WIDTH_RATIO/2);
    }
    YZDynamicModel * model = _listDatas[tableView.tag - 100][indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.create_time;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.view.userInteractionEnabled = NO;
    YZDynamicModel * model = _listDatas[tableView.tag - 100][indexPath.row];
    YZWabVC * webVC = [YZWabVC new];
    [webVC loadId:model.id];
//    webVC.hasShare = YES;
    webVC.title = @"详情";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark 用于将cell分割线补全
-(void)viewDidLayoutSubviews {
    if (_scrView) {
        for (UITableView * tableView in _scrView.subviews) {
            if ([tableView isKindOfClass:[UITableView class]]) {
                if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
                    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 0, 10*WIDTH_RATIO/2)];
                }
                if ([tableView respondsToSelector:@selector(setLayoutMargins:)])  {
                    [tableView setLayoutMargins:UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 0, 10*WIDTH_RATIO/2)];
                }
            }
        }
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
