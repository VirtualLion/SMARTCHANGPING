//
//  YZNetMaster.h
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/4.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZNetMaster : NSObject

+ (void)postHub:(NSString * _Nonnull)url
     parameters:(NSDictionary * _Nullable)parameters
        success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
        failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure;
+ (void)post:(NSString * _Nonnull)url
  parameters:(NSDictionary * _Nullable)parameters
     success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
     failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure;
+ (NSURLSessionDownloadTask * _Nullable)download:(NSString * _Nonnull)url progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress))downloadProgressBlock destination:(nullable NSURL * _Nonnull(^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination completionHandler:(nullable void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;
@end
