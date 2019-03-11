//
//  YZProgressHUD.h
//  maoyou_ios_app
//
//  Created by 韩云智 on 16/9/27.
//  Copyright © 2016年 茅台酒会－花阳阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface YZProgressHUD : NSObject

+ (MBProgressHUD *)showHud:(UIView*)rootView text:(NSString*)text;//显示HUD
+(void)hideHud:(UIView*)rootView;

+ (void)showHudStr:(NSString *)str rootView:(UIView *)rootView image:(UIImage *)image;
+ (void)showHudSuccess:(NSString *)success rootView:(UIView *)rootView;//成功时，2秒后消隐
+ (void)showHudFailed:(NSString *)failed rootView:(UIView *)rootView;//失败时，2秒后消隐

+ (MBProgressHUD *)showHudText:(NSString*)text;//显示HUD
+(void)hideHud;

+ (void)showHudStr:(NSString *)str image:(UIImage *)image;
+ (void)showHudSuccess:(NSString *)success;//成功时，2秒后消隐
+ (void)showHudFailed:(NSString *)failed;//失败时，2秒后消隐

@end
