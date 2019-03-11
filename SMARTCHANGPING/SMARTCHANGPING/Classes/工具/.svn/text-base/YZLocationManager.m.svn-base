//
//  YZLocationManager.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/18.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZLocationManager.h"

@interface YZLocationManager ()

@property (nonatomic, strong) AMapLocationManager * locationManager;

@end

@implementation YZLocationManager

#pragma mark --- 懒加载
- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [AMapLocationManager new];
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，最低2s，此处设置为2s
        _locationManager.locationTimeout =2;
        //   逆地理请求超时时间，最低2s，此处设置为2s
        _locationManager.reGeocodeTimeout = 2;
    }
    return _locationManager;
}

#pragma mark --- 生命周期
//单例
+ (YZLocationManager *)sharedManager
{
    static YZLocationManager *sharedLocationManager = nil;
    static dispatch_once_t predicateMain;
    dispatch_once(&predicateMain, ^{
        sharedLocationManager = [[self alloc] init];
    });
    return sharedLocationManager;
}

+ (BOOL)requestLocationWithReGeocode:(BOOL)withReGeocode completionBlock:(AMapLocatingCompletionBlock)completionBlock{
    
    
    return
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [[self sharedManager].locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed)
            {
                CLLocation * defaultLocation = [[CLLocation alloc]initWithLatitude:LOCATION_LATITUDE longitude:LOCATION_LONGITUDE];
                [self sharedManager].location = defaultLocation;
                completionBlock(defaultLocation, regeocode, error);
                return;
            }
        }
//        NSLog(@"location:%@", location);
//        if (regeocode)
//        {
//            NSLog(@"reGeocode:%@", regeocode);
//        }
        USERDEFAULTS[@"weather_adcode"] = regeocode.adcode;
        [self sharedManager].location = location;
        completionBlock(location, regeocode, error);
    }];
}




@end
