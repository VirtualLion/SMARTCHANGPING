//
//  YZHomeModel.h
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/9.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZBaseModel.h"

@interface YZHomeModel : YZBaseModel

//todayData —— 今日关注
@property (nonatomic, copy) NSString * id;//:	文章id
//title:文章标题
@property (nonatomic, copy) NSString * author;//:文章作者
@property (nonatomic, copy) NSString * create_time;//:创建时间

//mythemeData —— 我得主题
//"theme_id": 主题id
//"theme_name": 主题标题
//"theme_img_url": 主题图标

//lifeFourData —— 本地特惠
@property (nonatomic, copy) NSString * life_id;// ：生活id
//Title : 标题
@property (nonatomic, copy) NSString * shop_img_url;// ： 商品图片
@property (nonatomic, copy) NSString * original_price;// ： 原价
@property (nonatomic, copy) NSString * bargin_price;// : 促销价

//办事
@property (nonatomic, copy) NSString * matter_id;// : 事项id
@property (nonatomic, copy) NSString * title;// : 事项名称
//section_name ： 办理机构名称

@property (nonatomic, copy) NSString * section_id;// : 部门id
@property (nonatomic, copy) NSString * section_name;// : 部门名称

@property (nonatomic, copy) NSString * theme_id;// : 主题id
@property (nonatomic, copy) NSString * theme_name;// : 主题名称
@property (nonatomic, copy) NSString * theme_img_url;// ：主题图标url

@property (nonatomic, assign) BOOL isChoose;

@end
