//
//  YZYellowModel.h
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/15.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZBaseModel.h"

@interface YZYellowModel : YZBaseModel

@property (nonatomic, strong) NSString * yp_id;// : 黄页id
@property (nonatomic, strong) NSString * mechanism_name;// : 机构名称
@property (nonatomic, strong) NSString * telephone;// ： 电话
@property (nonatomic, strong) NSString * create_time;// : 创建时间
@property (nonatomic, strong) NSString * longitude;// ： 经度
@property (nonatomic, strong) NSString * latitude;// : 纬度
@property (nonatomic, strong) NSString * address;// : 机构地址


@end
