//
//  YZLifeVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/6.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZLifeVC.h"

#import "YZLifeModel.h"

#import "YZLifeMapVC.h"
#import "YZLifeDetailVC.h"

#import "ADCarouselView.h"

#import "YZLifeAnnotationView.h"
#import "YZLifePointAnnotation.h"

@interface YZLifeVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,MAMapViewDelegate,ADCarouselViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) UICollectionView * myCollectionView;
@property (nonatomic, strong) NSMutableArray * datas;

@property (nonatomic, strong) UILabel * adLabel;

@property (nonatomic, strong) ADCarouselView * carouselView;
@property (nonatomic, strong) NSMutableArray * carouselDatas;

@property (nonatomic, strong) NSMutableArray * lifeDatas;

@end

@implementation YZLifeVC
- (void)reloadADCarouselView:(NSInteger)item{
    if (item == 2) {
        _carouselView.automaticallyScrollDuration = 2.5;
    }else{
        _carouselView.automaticallyScrollDuration = 0;
    }
}
#pragma mark --- 事件处理
- (void)onAllButton:(UIButton *)sender{
    self.view.userInteractionEnabled = NO;
    
    YZLifeMapVC * mapVC = [YZLifeMapVC new];
    mapVC.title = @"生活服务地图";
    [[YZRootVC sharedManager].navigationController pushViewController:mapVC animated:YES];
    
}

#pragma mark --- 请求数据
- (void)getLifeData{
    
    WeakSelf;
    [YZLocationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        [weakSelf.mapView setCenterCoordinate:location.coordinate];
        NSDictionary * parameters = @{@"longitude":@(location.coordinate.longitude),@"latitude":@(location.coordinate.latitude)};
        [YZNetMaster post:SERVER_LIFE_HOME parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject[@"status"] integerValue] == 1) {
                NSDictionary * dataDic = responseObject[@"data"];
                if ([dataDic isKindOfClass:[NSDictionary class]]) {
                    NSArray * lifeSlideList = dataDic[@"lifeSlideList"];
                    if ([lifeSlideList isKindOfClass:[NSArray class]]) {
                        NSMutableArray * mut = [NSMutableArray new];
                        [weakSelf.carouselDatas removeAllObjects];
                        for (NSDictionary * dic in lifeSlideList) {
                            YZLifeModel * model = [YZLifeModel modelWithDic:dic];
                            [weakSelf.carouselDatas addObject:model];
                            [mut addObject:model.slide_img_url];
                        }
                        weakSelf.carouselView.imgs = mut;
                        weakSelf.carouselView.pageControlView.hidden = YES;
                    }
                    NSArray * lifeCategoryList = dataDic[@"lifeCategoryList"];
                    if ([lifeCategoryList isKindOfClass:[NSArray class]]) {
                        [weakSelf.datas removeAllObjects];
                        for (NSDictionary * dic in lifeCategoryList) {
                            [weakSelf.datas addObject:[YZLifeModel modelWithDic:dic]];
                        }
                        [weakSelf.myCollectionView reloadData];
                    }
                    NSArray * lifeData = dataDic[@"lifeData"];
                    if ([lifeData isKindOfClass:[NSArray class]]) {
                        for (NSDictionary * dic in lifeData) {
                            [weakSelf.lifeDatas addObject:[YZLifeModel modelWithDic:dic]];
                        }
                    }
                    [weakSelf reloadAnnotation];
                    weakSelf.mapView.superview.hidden = NO;
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        }];
    }];
    
}

#pragma mark --- 懒加载
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray new];
        [self getLifeData];
    }
    return _datas;
}
- (NSMutableArray *)carouselDatas{
    if (!_carouselDatas) {
        _carouselDatas = [NSMutableArray new];
    }
    return _carouselDatas;
}
- (NSMutableArray *)lifeDatas{
    if (!_lifeDatas) {
        _lifeDatas = [NSMutableArray new];
    }
    return _lifeDatas;
}

#pragma mark --- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self upView];
}

- (void)upView{
    YZCollectionViewFlowLayout * flowLayout = [YZCollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _myCollectionView.backgroundColor = [UIColor clearColor];
    _myCollectionView.bounces = NO;
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    
    [_myCollectionView registerClass:[YZBaseCollectionCell class] forCellWithReuseIdentifier:@"baseCell"];
    [_myCollectionView registerClass:NSClassFromString(@"YZHomeThingsCell") forCellWithReuseIdentifier:@"cell"];
    
    
    UIView * mapView = [UIView new];
    mapView.backgroundColor = [UIColor whiteColor];
    
    [self.view sd_addSubviews:@[_myCollectionView, mapView]];
    _myCollectionView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightSpaceToView(self.view, -0.1*WIDTH_RATIO)
    .heightIs(600*WIDTH_RATIO/2);
    
    mapView.sd_layout
    .topSpaceToView(_myCollectionView, 15*WIDTH_RATIO/2)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    UIView * adView = [UIView new];
    adView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    
    [mapView sizeToFit];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT-113-615*WIDTH_RATIO/2)];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    ///是否显示交通
    _mapView.showTraffic = NO;
    ///是否显示罗盘
    _mapView.showsCompass = NO;
    ///是否显示比例尺
    _mapView.showsScale = NO;
    _mapView.zoomLevel = 10;
    
    _mapView.delegate = self;
    [mapView addSubview:_mapView];
    
    [mapView sd_addSubviews:@[adView]];
    adView.sd_layout
    .topSpaceToView(mapView, 6*WIDTH_RATIO/2)
    .leftEqualToView(mapView)
    .rightEqualToView(mapView)
    .heightIs(84*WIDTH_RATIO/2);
    
    _adLabel = [UILabel new];
    _adLabel.font = [UIFont systemFontOfSize:26*WIDTH_RATIO/2];
    _adLabel.textColor = YZ_COLOR(0x333333);
    UIButton * allBtn = [UIButton new];
    [allBtn setTitle:@"全部 >" forState:UIControlStateNormal];
    [allBtn setTitleColor:YZ_COLOR(0x333333) forState:UIControlStateNormal];
    [allBtn.titleLabel setFont:[UIFont systemFontOfSize:26*WIDTH_RATIO/2]];
    [allBtn addTarget:self action:@selector(onAllButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [adView sd_addSubviews:@[allBtn, _adLabel]];
    allBtn.sd_layout
    .rightEqualToView(adView)
    .topEqualToView(adView)
    .bottomEqualToView(adView)
    .widthIs(150*WIDTH_RATIO/2);
    _adLabel.sd_layout
    .leftSpaceToView(adView, 40*WIDTH_RATIO/2)
    .topEqualToView(adView)
    .bottomEqualToView(adView)
    .rightSpaceToView(allBtn, 0);
    
    
    [mapView sd_addSubviews:@[_mapView]];
    _mapView.sd_layout
    .topEqualToView(mapView)
    .leftEqualToView(mapView)
    .rightEqualToView(mapView)
    .bottomEqualToView(mapView);
    
    [mapView bringSubviewToFront:adView];
    
    mapView.hidden = YES;

}

#pragma mark --- collection

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(MY_WIDTH, 260*WIDTH_RATIO/2);
        case 1:
            return CGSizeMake((MY_WIDTH-WIDTH_RATIO*3)/4, 169*WIDTH_RATIO/2);
        default:
            return CGSizeMake(0, 0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return WIDTH_RATIO;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return WIDTH_RATIO;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 1) {
        return self.datas.count;
    }
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YZBaseCollectionCell * cell;
    if (indexPath.section == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"baseCell" forIndexPath:indexPath];
        
        if (!_carouselView) {
            cell.backgroundColor = [UIColor clearColor];
            _carouselView = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, MY_WIDTH, 260*WIDTH_RATIO/2)];
            _carouselView.backgroundColor = [UIColor clearColor];
            _carouselView.loop = YES;
            _carouselView.delegate = self;
            _carouselView.automaticallyScrollDuration = 2.5;
            _carouselView.placeholderImage = [UIImage imageNamed:PLACEHOLDER_IMG];
            _carouselView.pageControlView.hidden = YES;
            _carouselView.titleLabel.hidden = YES;
            [cell.contentView addSubview:_carouselView];
        }
        
        return cell;
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.model = _datas[indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.view.userInteractionEnabled = NO;
    if (indexPath.section == 1) {
        YZLifeMapVC * mapVC = [YZLifeMapVC new];
        mapVC.lc_id = [_datas[indexPath.item] lc_id];
        mapVC.title = @"生活服务地图";
        [[YZRootVC sharedManager].navigationController pushViewController:mapVC animated:YES];
    }else{
        self.view.userInteractionEnabled = YES;
    }
}

- (void)carouselView:(ADCarouselView *)carouselView didSelectItemAtIndex:(NSInteger)didSelectItemAtIndex{
    self.view.userInteractionEnabled = NO;
    YZLifeDetailVC * detailVC = [YZLifeDetailVC new];
    detailVC.life_id = [_carouselDatas[(didSelectItemAtIndex-1)%_carouselDatas.count] ls_id];
//    detailVC.doubleShare = YES;
    detailVC.title = @"详情";
    [[YZRootVC sharedManager].navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - 定位功能
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void)reloadAnnotation{
    [_mapView removeAnnotations:_mapView.annotations];
    for (YZLifeModel * model in _lifeDatas) {
        [self addAnnotationWithModel:model];
    }
    [_mapView selectAnnotation:_mapView.annotations.firstObject animated:YES];
}

#pragma mark - Utility

- (void)addAnnotationWithModel:(YZLifeModel *)model
{
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
    NSString * subTitle = [NSString stringWithFormat:@"联系电话：%@\n地址：%@", model.tel, model.address];
    NSInteger item = 0;
    for (YZLifeModel * mod in _datas) {
        if ([mod.lc_id isEqual:model.lc_id]) {
            break;
        }
        item++;
    }
    
    YZLifePointAnnotation * annotation = [[YZLifePointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title    = model.title;
    annotation.subtitle = subTitle;
    annotation.item = item%_datas.count;
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
    _adLabel.text = view.annotation.title;
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    _adLabel.text = @"";
}


@end
