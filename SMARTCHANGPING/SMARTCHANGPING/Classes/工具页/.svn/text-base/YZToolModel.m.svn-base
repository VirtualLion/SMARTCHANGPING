//
//  YZToolModel.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/19.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZToolModel.h"

@implementation YZToolClassModel

- (void)setToolData:(NSArray *)toolData{
    NSMutableArray * mut = [NSMutableArray new];
    if ([toolData isKindOfClass:[NSArray class]]) {
        for (NSDictionary * dic in toolData) {
            [mut addObject:[YZToolModel modelWithDic:dic]];
        }
    }
    _toolData = mut;
}


@end

@implementation YZToolModel

@end
