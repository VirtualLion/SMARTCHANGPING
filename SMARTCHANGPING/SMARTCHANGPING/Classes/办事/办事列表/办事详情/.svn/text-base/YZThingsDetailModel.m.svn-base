//
//  YZThingsDetailModel.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/15.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZThingsDetailModel.h"

@implementation YZThingsDetailConditionModel
@end

@implementation YZThingsDetailDownloadModel
@end

@implementation YZThingsDetailApprovalModel

- (void)setDownload:(NSArray *)download{
    NSMutableArray * mutArray = [NSMutableArray new];
    if ([download isKindOfClass:[NSArray class]]) {
        for (NSDictionary * dic in download) {
            [mutArray addObject:[YZThingsDetailDownloadModel modelWithDic:dic]];
        }
    }
    _download = mutArray;
}

@end

@implementation YZThingsDetailBaseModel
@end

@implementation YZThingsDetailModel

- (void)setBase:(YZThingsDetailBaseModel *)base{
    _base = [YZThingsDetailBaseModel modelWithDic:(id)base];
}

- (void)setApproval:(YZThingsDetailApprovalModel *)approval{
    _approval = [YZThingsDetailApprovalModel modelWithDic:(id)approval];
}

- (void)setCondition:(YZThingsDetailConditionModel *)condition{
    _condition = [YZThingsDetailConditionModel modelWithDic:(id)condition];
}

@end
