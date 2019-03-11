//
//  YZBaseModel.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZBaseModel.h"

@implementation YZBaseModel

+ (instancetype)modelWithDic:(NSDictionary *)dic{
    YZBaseModel * model = [self new];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        [model setValuesForKeysWithDictionary:dic];
    }
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
