//
//  YZYellowVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/11.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZYellowVC.h"

#import "YZYellowCell.h"

#import "YZYellowModel.h"

@interface YZYellowVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * myTableView;
@property (nonatomic, strong) NSMutableArray * listDatas;

@end

@implementation YZYellowVC

#pragma mark --- 数据请求
- (void)getListData:(NSInteger)page{
    NSDictionary * parameters = @{@"page":@(page),
                                  @"pagenum":@(10)};
    WeakSelf;
    [YZNetMaster post:SERVER_YELLOW_LIST parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                    [weakSelf.listDatas addObject:[YZYellowModel modelWithDic:dic]];
                }
                [weakSelf.myTableView reloadData];
            }else{
                [weakSelf.myTableView.mj_footer endRefreshing];
            }
        }else{
            [weakSelf.myTableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
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
    
    _myTableView = [UITableView new];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.rowHeight = 165*WIDTH_RATIO/2;
    _myTableView.separatorStyle = UITableViewCellAccessoryNone;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    [self.view sd_addSubviews:@[_myTableView]];
    _myTableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
}

#pragma mark --- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZYellowCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YZYellowCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (_listDatas.count > indexPath.row) {
        cell.model = _listDatas[indexPath.row];
    }
    
    return cell;
}

@end
