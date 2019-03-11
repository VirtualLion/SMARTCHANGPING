//
//  YZLifeDetailVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/12.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZLifeDetailVC.h"

@interface YZLifeDetailVC ()

@property (nonatomic, strong) UIScrollView * myScrollView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * imgView;

@end

@implementation YZLifeDetailVC

#pragma mark --- 数据请求
- (void)getDetailData{
    NSDictionary * parameters = @{@"life_id":_life_id};
    WeakSelf;
    [YZNetMaster post:SERVER_LIFE_DETAILS parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            NSDictionary * dic = responseObject[@"data"];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                weakSelf.titleLabel.text = dic[@"title"];
                [weakSelf.imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"shop_img_url"]] placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMG]];
                
                [weakSelf contentLabelWithTexts:@[[NSString stringWithFormat:@"电话：%@",dic[@"tel"]],
                                                  [NSString stringWithFormat:@"地址：%@",dic[@"address"]],
                                                  [NSString stringWithFormat:@"营业时间：%@",dic[@"open_time"]],
                                                  [NSString stringWithFormat:@"品牌故事：%@",dic[@"brand_story"]]]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

#pragma mark --- 懒加载


#pragma mark --- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self changeBackBarButton];
    [self upView];
    [self getDetailData];
}

- (void)upView{
    
    _myScrollView = [UIScrollView new];
    _myScrollView.backgroundColor = [UIColor whiteColor];
    _myScrollView.bounces = NO;
    [self.view sd_addSubviews:@[_myScrollView]];
    _myScrollView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = YZ_COLOR(0x333333);
    _titleLabel.font = [UIFont systemFontOfSize:34*WIDTH_RATIO/2];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    
    UILabel * line = [UILabel new];
    line.backgroundColor = YZ_COLOR(0xcccccc);
    
    _imgView = [UIImageView new];
    
    [_myScrollView sd_addSubviews:@[_titleLabel, line, _imgView]];
    
    line.sd_layout
    .topSpaceToView(_myScrollView, 108*WIDTH_RATIO/2)
    .leftSpaceToView(_myScrollView, 50*WIDTH_RATIO/2)
    .rightSpaceToView(_myScrollView, 50*WIDTH_RATIO/2)
    .heightIs(WIDTH_RATIO/2);
    
    _titleLabel.sd_layout
    .topEqualToView(_myScrollView)
    .leftSpaceToView(_myScrollView, 20*WIDTH_RATIO/2)
    .rightSpaceToView(_myScrollView, 20*WIDTH_RATIO/2)
    .bottomSpaceToView(line, 0);
    
    _imgView.sd_layout
    .topSpaceToView(line, 20*WIDTH_RATIO/2)
    .leftSpaceToView(_myScrollView, 55*WIDTH_RATIO/2)
    .rightSpaceToView(_myScrollView, 55*WIDTH_RATIO/2)
    .heightIs(350*WIDTH_RATIO/2);
}

- (void)contentLabelWithTexts:(NSArray *)texts{
    for (NSInteger i = 0; i<texts.count; i++) {
        UILabel * label = [UILabel new];
        label.textColor = YZ_COLOR(0x333333);
        label.font = [UIFont systemFontOfSize:26*WIDTH_RATIO/2];
        label.text = texts[i];
        
        [_myScrollView sd_addSubviews:@[label]];
        
        label.sd_layout
        .topSpaceToView(_imgView, (70+56*i)*WIDTH_RATIO/2)
        .leftSpaceToView(_myScrollView, 50*WIDTH_RATIO/2)
        .rightSpaceToView(_myScrollView, 50*WIDTH_RATIO/2)
        .autoHeightRatio(0);
    }
}

@end
