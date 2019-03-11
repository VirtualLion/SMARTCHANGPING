//
//  YZProgressHUD.m
//  maoyou_ios_app
//
//  Created by 韩云智 on 16/9/27.
//  Copyright © 2016年 茅台酒会－花阳阳. All rights reserved.
//

#import "YZProgressHUD.h"

@implementation YZProgressHUD

+ (MBProgressHUD *)showHud:(UIView*)rootView text:(NSString*)text{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:rootView animated:YES];
    HUD.label.text = text;
//    HUD.detailsLabelText = text;//详情
//    HUD.color = [UIColor colorWithWhite:0 alpha:0.7];
    [rootView addSubview:HUD];
    return HUD;
}
+(void)hideHud:(UIView*)rootView{
    [MBProgressHUD hideHUDForView:rootView animated:YES];
}

+ (void)showHudStr:(NSString *)str rootView:(UIView *)rootView image:(UIImage *)image{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:rootView];
//    HUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    [rootView addSubview:HUD];
    
    if (image) {
        UIImageView * customView = [[UIImageView alloc] initWithImage:image];
        customView.frame = CGRectMake(0, 0, 69*WIDTH_RATIO/2, 76*WIDTH_RATIO/2);
        HUD.customView = customView;
        HUD.detailsLabel.text = str;
    }else{
        HUD.label.text = str;
    }
    HUD.mode = MBProgressHUDModeCustomView;
    
    
    
    HUD.removeFromSuperViewOnHide = YES;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
}
+ (void)showHudSuccess:(NSString *)success rootView:(UIView *)rootView{
    [self showHudStr:success rootView:rootView image:[UIImage imageNamed:@"okey"]];
}
+ (void)showHudFailed:(NSString *)failed rootView:(UIView *)rootView{
    [self showHudStr:failed rootView:rootView image:[UIImage imageNamed:@"warn"]];
}


+ (MBProgressHUD *)showHudText:(NSString*)text{
    return [self showHud:[[UIApplication sharedApplication].delegate window] text:text];
}
+(void)hideHud{
    [self hideHud:[[UIApplication sharedApplication].delegate window]];
}

+ (void)showHudStr:(NSString *)str image:(UIImage *)image{
    [self showHudStr:str rootView:[[UIApplication sharedApplication].delegate window] image:image];
}
+ (void)showHudSuccess:(NSString *)success{
    [self showHudSuccess:success rootView:[[UIApplication sharedApplication].delegate window]];
}
+ (void)showHudFailed:(NSString *)failed{
    [self showHudFailed:failed rootView:[[UIApplication sharedApplication].delegate window]];
}

@end
