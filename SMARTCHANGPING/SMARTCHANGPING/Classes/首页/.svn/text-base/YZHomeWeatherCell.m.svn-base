//
//  YZHomeWeatherCell.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZHomeWeatherCell.h"

@interface YZHomeWeatherCell ()

@property (nonatomic, strong) UIImageView * imgView;

@property (nonatomic, strong) UILabel * temLabel;
@property (nonatomic, strong) UILabel * weaLabel;

@end

@implementation YZHomeWeatherCell

- (void)upView{
    _imgView = [UIImageView new];
    _imgView.image = [UIImage imageNamed:HOME_WEATHER_IMG];
    self.backgroundView = _imgView;
    
    UIView * weatherView = [UIView new];
    weatherView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    
    [self.contentView sd_addSubviews:@[weatherView]];
    
    weatherView.sd_layout
    .widthIs(312*WIDTH_RATIO/2)
    .heightIs(157*WIDTH_RATIO/2)
    .leftEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 54*WIDTH_RATIO/2);
    
    _temLabel = [UILabel new];
    _temLabel.textColor = YZ_COLOR(0x333333);
    _temLabel.textAlignment = NSTextAlignmentCenter;
    _temLabel.font = [UIFont systemFontOfSize:120*WIDTH_RATIO/2];
    _temLabel.adjustsFontSizeToFitWidth = YES;
    
    _temLabel.textAlignment = NSTextAlignmentRight;
    _weaLabel = [UILabel new];
    _weaLabel.numberOfLines = 0;
    _weaLabel.textColor = YZ_COLOR(0x666666);
    _weaLabel.font = [UIFont boldSystemFontOfSize:23*WIDTH_RATIO/2];
    
    [weatherView sd_addSubviews:@[_temLabel, _weaLabel]];
    
    _temLabel.sd_layout
    .topEqualToView(weatherView)
    .leftEqualToView(weatherView)
    .bottomEqualToView(weatherView)
    .widthRatioToView(weatherView, 0.5);
    
    _weaLabel.sd_layout
    .topEqualToView(weatherView)
    .rightEqualToView(weatherView)
    .bottomEqualToView(weatherView)
    .widthRatioToView(weatherView, 0.5);

    [self setModel:nil];
}

- (void)setModel:(YZBaseModel *)model{
    [super setModel:model];
    
    NSDictionary * modelDic = (id)model;
    
    NSString * tem = @"";
    NSString * wea = @"\n";
    if (modelDic.allKeys.count == 2) {
        AMapLocalWeatherLive * live = modelDic[@"live"];
        AMapLocalDayWeatherForecast * forecast = modelDic[@"forecast"];
        tem = [NSString stringWithFormat:@"%@℃",live.temperature];//@"9℃";
        
        wea = [NSString stringWithFormat:@"%@\n%@/%@℃\n%@风%@级",live.weather,@(MIN(forecast.dayTemp.doubleValue, forecast.nightTemp.doubleValue)),@(MAX(forecast.dayTemp.doubleValue, forecast.nightTemp.doubleValue)),live.windDirection,live.windPower];//@"请转多云\n-2/9℃\n东南风2-3级";
    }
    
    NSMutableAttributedString * attrTem = [[NSMutableAttributedString alloc] initWithString:tem];
    
    [attrTem addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:38*WIDTH_RATIO/2]
                    range:[tem rangeOfString:@"℃"]];
    [attrTem addAttribute:NSBaselineOffsetAttributeName value:@(3*WIDTH_RATIO) range:[tem rangeOfString:tem]];
    
    _temLabel.attributedText = attrTem;
    _temLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSMutableAttributedString * attrWea = [[NSMutableAttributedString alloc] initWithString:wea];
    
    [attrWea addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:27*WIDTH_RATIO/2]
                    range:NSMakeRange(0, [wea rangeOfString:@"\n"].location)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    paragraph.lineSpacing = 5*WIDTH_RATIO/2;
    paragraph.lineBreakMode = NSLineBreakByCharWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    [attrWea addAttribute:NSParagraphStyleAttributeName
                    value:paragraph
                    range:NSMakeRange(0, [wea length])];
    
    _weaLabel.attributedText = attrWea;
}

@end
