//
//  YZYellowMapVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/13.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZYellowMapVC.h"

#import "YZCustomAnnotationView.h"

@interface YZYellowMapVC ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation YZYellowMapVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /* Add a annotation on map center. */
    self.mapView.centerCoordinate = AMapCoordinateConvert(CLLocationCoordinate2DMake(_model.latitude.doubleValue, _model.longitude.doubleValue) , AMapCoordinateTypeBaidu);
    [self addAnnotationWithCooordinate:self.mapView.centerCoordinate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self changeBackBarButton];
    [self upView];
}

- (void)upView{
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
}

#pragma mark - Utility

-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title    = _model.mechanism_name;
    annotation.subtitle = _model.address;
    
    [self.mapView addAnnotation:annotation];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        YZCustomAnnotationView *annotationView = (YZCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[YZCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        }
        
        return annotationView;
    }
    
    return nil;
}

@end
