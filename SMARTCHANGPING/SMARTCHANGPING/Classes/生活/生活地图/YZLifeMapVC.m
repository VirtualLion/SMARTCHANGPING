//
//  YZLifeMapVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/12.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZLifeMapVC.h"

#import "YZLifeListVC.h"
#import "YZLifeDetailVC.h"

#import "YZLifeAnnotationView.h"
#import "YZLifePointAnnotation.h"

#import "YZLifeModel.h"

@interface YZLifeMapVC ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) UITableViewCell * bottomCell;

@property (nonatomic, strong) NSMutableArray * titles;

@property (nonatomic, strong) NSMutableArray * listDatas;

@property (nonatomic, copy) NSString * life_id;

@property (nonatomic, assign) BOOL isBtn;

@end

@implementation YZLifeMapVC

#pragma mark --- 事件处理
- (void)onRightBarButton:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    YZLifeListVC * listVC = [YZLifeListVC new];
    listVC.title = @"生活服务列表";
    [self.navigationController pushViewController:listVC animated:YES];
    sender.userInteractionEnabled = YES;
}

- (void)onTitleButtonItem:(NSInteger)item{
    if (item < 0) {
        [self getLifeList:@""];
    }else{
        [self getLifeList:[_titles[item] lc_id]];
    }
}

- (void)onBottomCell:(UITapGestureRecognizer *)sender{
    self.view.userInteractionEnabled = NO;
    if (_life_id) {
        YZLifeDetailVC * detailVC = [YZLifeDetailVC new];
//        detailVC.doubleShare = YES;
        detailVC.life_id = _life_id;
        detailVC.title = @"详情";
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        self.view.userInteractionEnabled = YES;
    }
    
}

#pragma mark --- 获取数据
- (void)getTitleData{
    WeakSelf;
    [YZNetMaster post:SERVER_LIFE_CATE parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * array = responseObject[@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                [weakSelf.titles removeAllObjects];
                NSInteger item = -1;
                NSInteger i = 0;
                for (NSDictionary * dic in array) {
                    YZLifeModel * model = [YZLifeModel modelWithDic:dic];
                    if ([model.lc_id isEqual:weakSelf.lc_id]) {
                        item = i;
                    }
                    [weakSelf.titles addObject:model];
                    i++;
                }
                [weakSelf myScrollTitleButton];
                [weakSelf chooseButtonItem:item];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

- (void)getLifeList:(NSString *)lc_id{
    
    _lc_id = lc_id;
    NSDictionary * parameters = @{@"lc_id":lc_id,
                                  @"page":@(1),
                                  @"pagenum":@(100),
                                  @"longitude":@([YZLocationManager sharedManager].location.coordinate.longitude),
                                  @"latitude":@([YZLocationManager sharedManager].location.coordinate.latitude)};
    WeakSelf;
    [YZNetMaster post:SERVER_LIFE_LIST parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSArray * array = responseObject[@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                [weakSelf.listDatas removeAllObjects];
                for (NSDictionary * dic in array) {
                    [weakSelf.listDatas addObject:[YZLifeModel modelWithDic:dic]];
                }
                [weakSelf reloadAnnotation];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
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
    self.navigationItem.rightBarButtonItems = [self myRightBarButtons];
    [self upView];
    [self getTitleData];
}

- (NSArray *)myRightBarButtons{
    UIButton * btn = [UIButton  new];
    btn.tintColor = [UIColor whiteColor];
    [btn setTitle:@"列表" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [btn addTarget:self action:@selector(onRightBarButton:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(0, 0, 30, 40);
    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10 * WIDTH_RATIO;
    
    return @[spaceItem, buttonItem];
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
    _bottomCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"bottom"];
    _bottomCell.backgroundColor = [UIColor whiteColor];
    _bottomCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _bottomCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBottomCell:)];
    [_bottomCell addGestureRecognizer:tap];
    
    _bottomCell.textLabel.font = [UIFont systemFontOfSize:30*WIDTH_RATIO/2];
    _bottomCell.textLabel.textColor = YZ_COLOR(0x333333);
    
    _bottomCell.detailTextLabel.font = [UIFont systemFontOfSize:22*WIDTH_RATIO/2];
    _bottomCell.detailTextLabel.numberOfLines = 2;
    _bottomCell.detailTextLabel.textColor = YZ_COLOR(0x999999);
    
    _bottomCell.detailTextLabel.sd_layout.minHeightIs(100*WIDTH_RATIO/2);
    
    [self.view sd_addSubviews:@[_bottomCell]];
    _bottomCell.sd_layout
    .heightIs(208*WIDTH_RATIO/2)
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
    
    [self.view sizeToFit];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 86*WIDTH_RATIO/2, self.view.width, self.view.height-294*WIDTH_RATIO/2)];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    ///是否显示交通
    _mapView.showTraffic = NO;
    ///是否显示罗盘
    _mapView.showsCompass = NO;
    ///是否显示比例尺
    _mapView.showsScale = NO;
//    _mapView.zoomLevel = 10;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}

- (void)reloadAnnotation{
    [_mapView removeAnnotations:_mapView.annotations];
    for (YZLifeModel * model in _listDatas) {
        [self addAnnotationWithModel:model];
    }
    
    if (_isBtn) {
        [_mapView selectAnnotation:_mapView.annotations.firstObject animated:YES];
    }else{
        _isBtn = YES;
        [self performSelector:@selector(selectWithObject:) withObject:_mapView.annotations.firstObject afterDelay:0.25];
    }
}
- (void)selectWithObject:(id)object{
    [_mapView selectAnnotation:object animated:YES];
}

#pragma mark - Utility

- (void)addAnnotationWithModel:(YZLifeModel *)model
{
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
    NSString * subTitle = [NSString stringWithFormat:@"联系电话：%@\n地址：%@", model.tel, model.address];
    NSInteger item = 0;
    for (YZLifeModel * mod in _titles) {
        if ([mod.lc_id isEqual:model.lc_id]) {
            break;
        }
        item++;
    }
    
    YZLifePointAnnotation * annotation = [[YZLifePointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title    = model.title;
    annotation.subtitle = subTitle;
    annotation.item = item%_titles.count;
    annotation.life_id = model.life_id;
    
    [_mapView addAnnotation:annotation];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        YZLifeAnnotationView * annotationView = (YZLifeAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[YZLifeAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        }
        [annotationView update];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    _bottomCell.textLabel.text = view.annotation.title;
    _bottomCell.detailTextLabel.text = view.annotation.subtitle;
    _life_id = [(YZLifePointAnnotation *)view.annotation life_id];
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    _bottomCell.textLabel.text = @"";
    _bottomCell.detailTextLabel.text = @"";
    _life_id = nil;
}

@end
