//
//  YZDynamicModel.h
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/16.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZBaseModel.h"

@interface YZDynamicModel : YZBaseModel

@property (nonatomic, copy) NSString * id;//:	文章id
@property (nonatomic, copy) NSString * title;//:文章标题
@property (nonatomic, copy) NSString * author;//:文章作者
@property (nonatomic, copy) NSString * create_time;//:创建时间

@end
