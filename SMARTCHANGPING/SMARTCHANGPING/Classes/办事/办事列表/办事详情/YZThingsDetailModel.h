//
//  YZThingsDetailModel.h
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/15.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZBaseModel.h"

@interface YZThingsDetailConditionModel : YZBaseModel
//受理条件
@property (nonatomic, copy) NSString * accept_condition;// ：受理条件

@end

@interface YZThingsDetailDownloadModel : YZBaseModel

@property (nonatomic, copy) NSString * down_name;//：下载文档标题
@property (nonatomic, copy) NSString * down_url;// ： 下载地址

@end

@interface YZThingsDetailApprovalModel : YZBaseModel
//申报材料
@property (nonatomic, copy) NSString * approval_content;// : 审批材料
@property (nonatomic, strong) NSArray * download;// : 下载集合

@end

@interface YZThingsDetailBaseModel : YZBaseModel
//基本信息
@property (nonatomic, copy) NSString * title;//:事项标题
@property (nonatomic, copy) NSString * authority_category;// :职权类别
@property (nonatomic, copy) NSString * authority_name;// : 职权名称
@property (nonatomic, copy) NSString * authority_code;// ： 职权编码
@property (nonatomic, copy) NSString * put_section;// ： 实施部门
@property (nonatomic, copy) NSString * accept_address;// ：受理地点
@property (nonatomic, copy) NSString * hotline;// ：咨询电话
@property (nonatomic, copy) NSString * complaints_hotline;// ：投诉电话
@property (nonatomic, copy) NSString * flow_chart;// ：流程图

@end

@interface YZThingsDetailModel : YZBaseModel

@property (nonatomic, strong) YZThingsDetailBaseModel * base;//基本信息
@property (nonatomic, strong) YZThingsDetailApprovalModel * approval;//申报材料
@property (nonatomic, strong) YZThingsDetailConditionModel * condition;//受理条件

@end
