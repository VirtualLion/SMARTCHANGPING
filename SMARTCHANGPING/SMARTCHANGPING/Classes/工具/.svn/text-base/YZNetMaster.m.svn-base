//
//  YZNetMaster.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/4.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZNetMaster.h"

@interface YZNetMaster ()

@property (nonatomic, assign) NSUInteger * hudCount;

@end

@implementation YZNetMaster

+ (void)postHub:(NSString *)url
     parameters:(NSDictionary *)parameters
        success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable))success
        failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull))failure{
    [[self sharedManager]postHub:url parameters:parameters success:success failure:failure];
}
+ (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable))success
     failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull))failure{
    [[self sharedManager]post:url parameters:parameters success:success failure:failure];
}
+ (NSURLSessionDownloadTask * _Nullable)download:(NSString * _Nonnull)url progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress))downloadProgressBlock destination:(nullable NSURL * _Nonnull(^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination completionHandler:(nullable void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler{
    
    return [[self sharedManager] download:url progress:downloadProgressBlock destination:destination completionHandler:completionHandler];
}





//单例
+ (YZNetMaster *)sharedManager
{
    static YZNetMaster *sharedYZNetMaster = nil;
    static dispatch_once_t predicateRoot;
    dispatch_once(&predicateRoot, ^{
        sharedYZNetMaster = [[self alloc] init];
    });
    return sharedYZNetMaster;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hudCount = 0;
    }
    return self;
}

- (void)postHub:(NSString *)url
     parameters:(NSDictionary *)parameters
        success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable))success
        failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull))failure{
    if (_hudCount == 0) {
        [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    }
    _hudCount++;
    [self post:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        success(task, responseObject);
        if (_hudCount > 0) {
            _hudCount--;
            if (_hudCount == 0) {
                [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(task, error);
        if (_hudCount > 0) {
            if (_hudCount-- == 0) {
                [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
            }
        }
    }];
}

- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable))success
     failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull))failure{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@", YZ_SERVER, url];
    
    NSMutableDictionary * parametersDic = [NSMutableDictionary new];
    [parametersDic setObject:YZ_APP_VERSION forKey:@"app_versions"];
    [parametersDic setObject:[YZKeyChain getUUID] forKey:@"userid"];
    [parametersDic setValuesForKeysWithDictionary:parameters];
    
    NSArray* array = [[parametersDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    NSMutableString * mutStr = [NSMutableString stringWithString:MD5_SIGN_CONFUSION];
    for (NSString * key in array) {
        [mutStr appendString:key];
        [mutStr appendString:[NSString stringWithFormat:@"%@",parametersDic[key]]];
    }
    [parametersDic setObject:[mutStr MD5Digest] forKey:@"sign"];
    
    [self postUrl:urlStr parameters:parametersDic success:success failure:failure];
}

- (void)postUrl:(NSString *)url
     parameters:(NSDictionary *)parameters
        success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable))success
        failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull))failure{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    NSLog(@"\n%@\n%@", url, parameters);
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSLog(@"\n%@", responseObject);
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSLog(@"\n%@", error);
        failure(task, error);
    }];
}

- (NSURLSessionDownloadTask * _Nullable)download:(NSString * _Nonnull)urlStr progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress))downloadProgressBlock destination:(nullable NSURL * _Nonnull(^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination completionHandler:(nullable void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler{
    
    if (_hudCount == 0) {
        [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    }
    _hudCount++;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /*
     第一个参数:请求对象
     第二个参数:progress 进度回调
     第三个参数:destination--(downloadTask-)
     在该block中告诉AFN应该把文件存放在什么位置,AFN内部会自动的完成文件的剪切处理
     targetPath:文件的临时存储路径(tmp)
     response:响应头信息
     返回值:文件的最终存储路径
     第四个参数:completionHandler 完成之后的回调
     filePath:文件路径 == 返回值
     */
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (_hudCount > 0) {
            _hudCount--;
            if (_hudCount == 0) {
                [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
            }
        }
        completionHandler(response,filePath,error);
        }];
    
    [download resume];
    
    return download;
}


//使用AFN框架来检测网络状态的改变
-(void)AFNReachability
{
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.监听网络状态的改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
                
            default:
                break;
        }
    }];
    //3.开始监听
    [manager startMonitoring];
}


@end
