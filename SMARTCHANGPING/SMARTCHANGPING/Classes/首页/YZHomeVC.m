//
//  YZHomeVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/7.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZHomeVC.h"

#import "YZHomeModel.h"

#import "YZThingsListVC.h"
#import "YZDynamicVC.h"
#import "YZInteractionVC.h"
#import "YZYellowVC.h"
#import "YZLifeDetailVC.h"

#import "YZChooseVC.h"

@interface YZHomeVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,AMapSearchDelegate>

@property (nonatomic, strong) UICollectionView * myCollectionView;
@property (nonatomic, strong) NSMutableArray * datas;

@property (nonatomic, strong) AMapSearchAPI * weatherSearch;
@property (nonatomic, strong) NSMutableDictionary * weatherModel;

@property (nonatomic, assign) BOOL notFirst;

@end

@implementation YZHomeVC

#pragma mark --- 数据请求
- (void)getHomeData{
    WeakSelf;
    [YZNetMaster post:SERVER_HOME_LIST parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf.myCollectionView.mj_header endRefreshing];
        if ([responseObject[@"status"] integerValue] == 1) {
            NSDictionary * dataDic = responseObject[@"data"];
            if ([dataDic isKindOfClass:[NSDictionary class]]) {
                [weakSelf loadDataDic:dataDic];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf.myCollectionView.mj_header endRefreshing];
    }];
}

#pragma mark --- 懒加载
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray new];
        [self getHomeData];
    }
    return _datas;
}

#pragma mark --- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_myCollectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self upView];
}

- (void)loadDataDic:(NSDictionary *)dic{
    
    [_datas removeAllObjects];
    //天气
    [_datas addObject:@[_weatherModel]];
    //button
    NSMutableArray * mut = [NSMutableArray new];
    for (NSString * str in HOME_BUTTON_TITLES) {
        YZHomeModel * model = [YZHomeModel new];
        model.title = str;
        [mut addObject:model];
    }
    [_datas addObject:mut];
    //todayData —— 今日关注
    NSArray * todayData = dic[@"todayData"];
    NSMutableArray * mutTodayData = [NSMutableArray new];
    if ([todayData isKindOfClass:[NSArray class]]) {
        for (NSDictionary * di in todayData) {
            [mutTodayData addObject:[YZHomeModel modelWithDic:di]];
        }
    }
    [_datas addObject:@[mutTodayData]];
    //mythemeData —— 我得主题
    NSArray * mythemeData = dic[@"mythemeData"];
    NSMutableArray * mutMythemeData = [NSMutableArray new];
    if ([mythemeData isKindOfClass:[NSArray class]]) {
        for (NSDictionary * di in mythemeData) {
            [mutMythemeData addObject:[YZHomeModel modelWithDic:di]];
        }
    }
    [mutMythemeData addObject:@""];//添加
    [_datas addObject:mutMythemeData];
    //查看全部
    [_datas addObject:@[[YZHomeModel new]]];
    //lifeFourData —— 本地特惠
    NSArray * lifeFourData = dic[@"lifeFourData"];
    NSMutableArray * mutLifeFourData = [NSMutableArray new];
    [mutLifeFourData addObject:[YZHomeModel new]];
    if ([lifeFourData isKindOfClass:[NSArray class]]) {
        for (NSDictionary * di in lifeFourData) {
            [mutLifeFourData addObject:[YZHomeModel modelWithDic:di]];
        }
    }
    for (NSInteger i = mutLifeFourData.count; i<6; i++) {
        [mutLifeFourData addObject:[YZHomeModel new]];
    }
    [_datas addObject:mutLifeFourData];
    
    [_myCollectionView reloadData];
}

- (void)loadThingsData:(NSArray *)datas{
    [_datas setObject:datas atIndexedSubscript:3];
    [_myCollectionView reloadData];
}

- (void)getWeather{
    [YZLocationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        AMapWeatherSearchRequest * request = [[AMapWeatherSearchRequest alloc] init];
        request.city = regeocode.adcode;
        request.type = AMapWeatherTypeLive;
        [_weatherSearch AMapWeatherSearch:request];
//        USERDEFAULTS[@"weather_adcode"] = regeocode.adcode;
    }];
}
- (void)getWeatherFirst{
    _notFirst = NO;
    NSString * adcode = USERDEFAULTS[@"weather_adcode"];
    if (!adcode) {
        adcode = @"北京";
    }
    AMapWeatherSearchRequest * request = [[AMapWeatherSearchRequest alloc] init];
    request.city = adcode;
    request.type = AMapWeatherTypeLive;
    [_weatherSearch AMapWeatherSearch:request];
}

- (void)upView{
    
    _weatherSearch = [[AMapSearchAPI alloc] init];
    _weatherSearch.delegate = self;
    _weatherModel = [NSMutableDictionary new];
    
    [self getWeatherFirst];
    
    YZCollectionViewFlowLayout * flowLayout = [YZCollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _myCollectionView.backgroundColor = [UIColor clearColor];
    
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    
    for (NSString * classStr in HOME_CELL_CLASSES) {
        [_myCollectionView registerClass:NSClassFromString(classStr) forCellWithReuseIdentifier:classStr];
    }
    
    [self.view sd_addSubviews:@[_myCollectionView]];
    _myCollectionView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightSpaceToView(self.view, -0.1*WIDTH_RATIO)
    .bottomEqualToView(self.view);
    
    WeakSelf;
    _myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getWeather];
        [weakSelf getHomeData];
    }];
    
}

- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response{
    //解析response获取天气信息，具体解析见 Demo
    
    if (response.forecasts.count == 0) {
        [_weatherModel setObject:response.lives.firstObject forKey:@"live"];
        request.type = AMapWeatherTypeForecast;
        [_weatherSearch AMapWeatherSearch:request];
    }else{
        [_weatherModel setObject:[response.forecasts.firstObject casts].firstObject forKey:@"forecast"];
        [_myCollectionView reloadData];
        if (!_notFirst) {
            _notFirst = YES;
            [self getWeather];
        }
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
}

#pragma mark --- collection

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(MY_WIDTH, 330*WIDTH_RATIO/2);
        case 1:
            return CGSizeMake(MY_WIDTH/4, 186*WIDTH_RATIO/2);
        case 2:
            return CGSizeMake(MY_WIDTH, 162*WIDTH_RATIO/2);
        case 3:
            return CGSizeMake((MY_WIDTH-WIDTH_RATIO*3)/4, 198*WIDTH_RATIO/2);
        case 4:
            return CGSizeMake(MY_WIDTH, 90*WIDTH_RATIO/2);
        case 5:
            if (indexPath.item%6 == 0 ||indexPath.item%6 == 5) {
                return CGSizeMake((MY_WIDTH - 180*WIDTH_RATIO/2*4)/2, 228*WIDTH_RATIO/2);
            }
            return CGSizeMake(180*WIDTH_RATIO/2, 228*WIDTH_RATIO/2);
            
        default:
            return CGSizeMake(0, 0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 3) {
        return WIDTH_RATIO;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 3 || section == 5) {
        return WIDTH_RATIO;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 3:{
            NSInteger count = [_datas[section] count];
            if (count%4>0) {
                count += 4-count%4;
            }
            return count;
        }
        case 5:{
            return 6;
        }
        default:
            return [_datas[section] count];
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * classes = HOME_CELL_CLASSES;
    YZBaseCollectionCell * cell;
    if (indexPath.section == 5 && (indexPath.item%6 == 0 ||indexPath.item%6 == 5)) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:classes[3] forIndexPath:indexPath];
        
        cell.model = nil;
        
        return cell;
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:classes[indexPath.section] forIndexPath:indexPath];
        
        NSArray * array = _datas[indexPath.section];
        if (indexPath.item < array.count) {
            cell.model = array[indexPath.item];
        }else{
            cell.model = nil;
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.view.userInteractionEnabled = NO;
    switch (indexPath.section) {
        case 1:{
            YZBaseVC * vc;
            switch (indexPath.row) {
                case 0:
                    [[YZMainTBC sharedManager] setSelectedIndex:1];
                    [YZRootVC sharedManager].title = @"办事指南";
                    self.view.userInteractionEnabled = YES;
                    break;
                case 1:{
                    YZDynamicVC * dynamicVC = [YZDynamicVC new];
                    dynamicVC.title = HOME_BUTTON_TITLES[indexPath.row];
                    vc = dynamicVC;
                }break;
                case 2:{
                    YZInteractionVC * interactionVC = [YZInteractionVC new];
                    interactionVC.title = HOME_BUTTON_TITLES[indexPath.row];
                    vc = interactionVC;
                }break;
                case 3:{
                    YZYellowVC * yellowVC = [YZYellowVC new];
                    yellowVC.title = @"黄页";
                    vc = yellowVC;
                }break;
                default:
                    self.view.userInteractionEnabled = YES;
                    break;
            }
            if (vc) {
                [[YZRootVC sharedManager].navigationController pushViewController:vc animated:YES];
            }
            
        }break;
        case 2:{
            YZBaseCollectionCell * cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
            YZWabVC * webVC = [YZWabVC new];
            [webVC loadId:[(id)cell.model id]];
            webVC.title = @"今日关注";
            [[YZRootVC sharedManager].navigationController pushViewController:webVC animated:YES];
        }break;
        case 3:{
            YZBaseCollectionCell * cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
            if (cell.model) {
                if ([cell.model isKindOfClass:[YZHomeModel class]]) {
                    YZThingsListVC * listVC = [YZThingsListVC new];
                    listVC.title = @"办事指南";
                    listVC.section_id = [NSString stringWithFormat:@"%@", [(id)cell.model section_id]?[(id)cell.model section_id ]:@""];
                    listVC.theme_id = [NSString stringWithFormat:@"%@", [(id)cell.model theme_id]?[(id)cell.model theme_id]:@""];
                    [[YZRootVC sharedManager].navigationController pushViewController:listVC animated:YES];
                }else{
                    YZChooseVC * chooseVC = [YZChooseVC new];
                    NSMutableArray * mutArray = [NSMutableArray new];
                    for (YZHomeModel * model in _datas[3]) {
                        if ([model isKindOfClass:[YZHomeModel class]]) {
                            [mutArray addObject:model.theme_id];
                        }
                    }
                    chooseVC.themes = mutArray;
                    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:chooseVC];
                    [[YZRootVC sharedManager] presentViewController:nvc animated:YES completion:^{
                        self.view.userInteractionEnabled = YES;
                    }];
                }
            }else{
                self.view.userInteractionEnabled = YES;
            }
            
        }break;
        case 5:{
            YZBaseCollectionCell * cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
            if (cell.model) {
                YZLifeDetailVC * detailVC = [YZLifeDetailVC new];
                detailVC.life_id = [(id)cell.model life_id];
//                detailVC.doubleShare = YES;
                detailVC.title = @"详情";
                [[YZRootVC sharedManager].navigationController pushViewController:detailVC animated:YES];
            }else{
                self.view.userInteractionEnabled = YES;
            }
        }break;
            
        default:
            self.view.userInteractionEnabled = YES;
            break;
    }
}

@end
