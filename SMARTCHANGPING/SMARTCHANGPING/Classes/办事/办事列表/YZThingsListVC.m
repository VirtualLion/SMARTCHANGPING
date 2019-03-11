//
//  YZThingsListVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/10.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZThingsListVC.h"

#import "YZThingsDetailVC.h"

#import "YZHomeModel.h"

@interface YZThingsListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * myTableView;
@property (nonatomic, strong) NSMutableArray * listDatas;

@end

@implementation YZThingsListVC

#pragma mark --- 事件处理
- (void)onBtn:(UIButton *)sender{
    
}
#pragma mark --- 数据请求
- (void)getListData:(NSInteger)page{
    NSDictionary * parameters = @{@"section_id":_section_id,
                                    @"theme_id":_theme_id,
                                        @"page":@(page),
                                     @"pagenum":@(10)};
    WeakSelf;
    [YZNetMaster post:SERVER_THINGS_LIST parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf.myTableView.mj_header endRefreshing];
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * dataArray = responseObject[@"data"];
            if ([dataArray isKindOfClass:[NSArray class]]) {
                if (page == 1) {
                    [weakSelf.listDatas removeAllObjects];
                    [weakSelf.myTableView.mj_footer resetNoMoreData];
                }
                if (dataArray.count == 10) {
                    [weakSelf.myTableView.mj_footer endRefreshing];
                }else{
                    [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                }
                for (NSDictionary * dic in dataArray) {
                    [weakSelf.listDatas addObject:[YZHomeModel modelWithDic:dic]];
                }
                [weakSelf.myTableView reloadData];
            }else{
                [weakSelf.myTableView.mj_footer endRefreshing];
            }
        }else{
            [weakSelf.myTableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf.myTableView.mj_header endRefreshing];
        [weakSelf.myTableView.mj_footer endRefreshing];
    }];
}

- (void)getDetailData:(NSString *)matter_id{
    
    NSDictionary * parameters = @{@"matter_id":matter_id};
    
    WeakSelf;
    [YZNetMaster post:SERVER_THINGS_DETAILS parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            YZThingsDetailVC * detailVC = [YZThingsDetailVC new];
            detailVC.title = @"详情";
//            detailVC.hasCollect = YES;
            detailVC.model = [YZThingsDetailModel modelWithDic:responseObject[@"data"]];
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }else{
            weakSelf.view.userInteractionEnabled = YES;
            [YZProgressHUD showHudFailed:@"该文章不存在"];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        weakSelf.view.userInteractionEnabled = YES;
    }];
}

#pragma mark --- 懒加载
- (NSMutableArray *)listDatas{
    if (!_listDatas) {
        _listDatas = [NSMutableArray new];
        [self getListData:1];
    }
    return _listDatas;
}


#pragma mark --- 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self changeBackBarButton];
    [self upView];
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
    _myTableView.estimatedRowHeight = 132*WIDTH_RATIO/2;
    _myTableView.rowHeight = 132*WIDTH_RATIO/2;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [UIView new];
    
    [self.view sd_addSubviews:@[searchBtn, _myTableView]];
    
    searchBtn.sd_layout
    .topSpaceToView(self.view, 16*WIDTH_RATIO/2)
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
        [weakSelf getListData:1];
    }];
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getListData:weakSelf.listDatas.count/10+1];
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
    
    YZHomeModel * model = _listDatas[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.section_name;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.view.userInteractionEnabled = NO;
    [self getDetailData:[_listDatas[indexPath.row] matter_id]];
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
