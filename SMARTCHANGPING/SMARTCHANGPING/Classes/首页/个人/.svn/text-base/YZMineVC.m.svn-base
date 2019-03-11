//
//  YZMineVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/9.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZMineVC.h"
#import "YZLoginVC.h"

@interface YZMineVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * myTableView;

@end

@implementation YZMineVC

#pragma mark --- 事件处理
- (void)goBackAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark --- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self myNavbar];
    self.title = @"我的";
    [self changeBackBarButton:NAV_DISMISS];
    [self upView];
}

- (void)upView{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.bounces = NO;
    _myTableView.separatorStyle = UITableViewCellAccessoryNone;
    _myTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, WIDTH_RATIO)];
    _myTableView.sectionFooterHeight = 10*WIDTH_RATIO/2;
    _myTableView.sectionHeaderHeight = 10*WIDTH_RATIO/2;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    [self.view sd_addSubviews:@[_myTableView]];
    _myTableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
}

#pragma mark --- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //未登录
    return 3;
    //登录
//    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MINE_CELL_TITLES[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 300*WIDTH_RATIO/2;
        case 3:
            return 110*WIDTH_RATIO/2;
        default:
            return 88*WIDTH_RATIO/2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%@_%@", @(indexPath.section), @(indexPath.row)]];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%@_%@", @(indexPath.section), @(indexPath.row)]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section) {
            case 1:
            case 2:{
                if (indexPath.row > 0) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UILabel * line = [UILabel new];
                    line.backgroundColor = YZ_COLOR(0xefefef);
                    
                    [cell.contentView sd_addSubviews:@[line]];
                    
                    line.sd_layout
                    .topEqualToView(cell.contentView)
                    .leftEqualToView(cell.contentView)
                    .widthIs(tableView.size.width)
                    .heightIs(WIDTH_RATIO);
                }
                cell.imageView.image = [UIImage imageNamed:MINE_CELL_IMGS[indexPath.section][indexPath.row]];
                cell.textLabel.text = MINE_CELL_TITLES[indexPath.section][indexPath.row];
                cell.textLabel.font = [UIFont systemFontOfSize:26*WIDTH_RATIO/2];
                cell.textLabel.textColor = YZ_COLOR(0x333333);
            }break;
            case 0:{
                UIImageView * imageView = [UIImageView new];
                imageView.image = [UIImage imageNamed:MINE_CELL_IMGS[indexPath.section][indexPath.row]];
                UILabel * label = [UILabel new];
                label.font = [UIFont systemFontOfSize:23*WIDTH_RATIO/2];
                label.textColor = YZ_COLOR(0x333333);
                label.textAlignment = NSTextAlignmentCenter;
                
                imageView.tag = 100;
                label.tag = 101;
                
                [cell.contentView sd_addSubviews:@[imageView, label]];
                
                imageView.sd_layout
                .widthIs(118*WIDTH_RATIO/2)
                .heightEqualToWidth()
                .topSpaceToView(cell.contentView, 60*WIDTH_RATIO/2)
                .centerXEqualToView(cell.contentView);
                
                label.sd_layout
                .leftSpaceToView(cell.contentView, 40*WIDTH_RATIO)
                .rightSpaceToView(cell.contentView, 40*WIDTH_RATIO)
                .topSpaceToView(imageView, 25*WIDTH_RATIO/2)
                .autoHeightRatio(0);
                
                
            }break;
            case 3:{
                cell.backgroundColor = [UIColor clearColor];
                UILabel * label = [UILabel new];
                label.backgroundColor = YZ_COLOR(0xd2d2d2);
                label.font = [UIFont systemFontOfSize:27*WIDTH_RATIO/2];
                label.textColor = YZ_COLOR(0x333333);
                label.textAlignment = NSTextAlignmentCenter;
                label.text = MINE_CELL_TITLES[indexPath.section][indexPath.row];
                [cell.contentView sd_addSubviews:@[label]];
                label.sd_layout
                .topSpaceToView(cell.contentView, 18*WIDTH_RATIO/2)
                .leftSpaceToView(cell.contentView, 36*WIDTH_RATIO/2)
                .rightSpaceToView(cell.contentView, 36*WIDTH_RATIO/2)
                .bottomEqualToView(cell.contentView);
                label.sd_cornerRadiusFromHeightRatio = @(0.5);
            }break;
                
            default:
                break;
        }
        
    }
    
    if (indexPath.section == 0) {
        UIImageView * imageView = [cell.contentView viewWithTag:100];
        imageView.image = [UIImage imageNamed:MINE_CELL_IMGS[indexPath.section][indexPath.row]];
        UILabel * label = [cell.contentView viewWithTag:101];
        label.text = MINE_CELL_TITLES[indexPath.section][indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            //跳转登录
            self.view.userInteractionEnabled = NO;
            YZLoginVC * vc = [YZLoginVC new];
            [self presentViewController:vc animated:YES completion:^{
            }];
        }break;
            
        default:
            break;
    }
}

@end
