//
//  YZMainTBC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/4.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZMainTBC.h"
#import "YZLifeVC.h"

@interface YZMainTBC ()

@end

@implementation YZMainTBC 

#pragma mark --- 生命周期
//单例
+ (YZMainTBC *)sharedManager
{
    static YZMainTBC *sharedYZMainTBC = nil;
    static dispatch_once_t predicateMain;
    dispatch_once(&predicateMain, ^{
        sharedYZMainTBC = [[self alloc] init];
    });
    return sharedYZMainTBC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self upView];
}

//创建tabbar
-(void)upView{
    self.tabBar.tintColor = [UIColor blackColor];
    self.tabBar.translucent = NO;
    
    NSArray * titles = TBC_ITEM_TITLES;
    NSArray * classes = TBC_ITEM_CLASSES;
    NSArray * imgs = TBC_ITEM_IMGS;
    NSUInteger count = MIN(imgs.count, MIN(titles.count, classes.count));
    
    NSMutableArray * array = [NSMutableArray new];
    for (NSInteger i = 0; i < count; i++) {
        YZBaseVC * vc = [NSClassFromString(classes[i]) new];
        vc.title = titles[i];
        
        vc.tabBarItem.image = [[UIImage imageNamed:imgs[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:TBC_ITEM_IMGS_ON[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.title = titles[i];
        [vc.tabBarItem setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];
        vc.tabBarItem.tag = i;
        
        [array addObject:vc];
    }
    self.viewControllers = array;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:TBC_NAVBAR_TITLES forKeys:TBC_ITEM_TITLES];
    [YZRootVC sharedManager].title = dict[item.title];
    
    YZLifeVC * lifeVC = self.viewControllers[2];
    [lifeVC reloadADCarouselView:item.tag];
}

@end
