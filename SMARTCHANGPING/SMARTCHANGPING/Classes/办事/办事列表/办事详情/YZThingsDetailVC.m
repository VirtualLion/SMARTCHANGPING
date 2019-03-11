//
//  YZThingsDetailVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/10.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZThingsDetailVC.h"

#import "YZYellowMapVC.h"

@interface YZThingsDetailVC ()<UITableViewDelegate, UITableViewDataSource, QLPreviewControllerDataSource, UIAlertViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) UILabel * infLabel;
@property (nonatomic, strong) UITextView * infTextView;
@property (nonatomic, strong) UITextView * matTextView;
@property (nonatomic, strong) UITextView * conTextView;

@property (nonatomic, copy) NSString * path;
@property (nonatomic, assign) NSInteger select;

@property (nonatomic, strong) AMapSearchAPI * search;

@end

@implementation YZThingsDetailVC

#pragma mark --- 事件处理

- (void)onRightBarButton:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    self.view.userInteractionEnabled = YES;
    sender.userInteractionEnabled = YES;
}

#pragma mark --- 重写set
- (void)setModel:(YZThingsDetailModel *)model{
    _model = model;
    _infLabel.text = model.base.title;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:26*WIDTH_RATIO/2];
    _infTextView.attributedText =[[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"职权类别：%@\n职权名称：%@\n职权编码：%@\n具体实施部门：%@", model.base.authority_category, model.base.authority_name, model.base.authority_code, model.base.put_section] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26*WIDTH_RATIO/2],NSForegroundColorAttributeName:YZ_COLOR(0x333333),                                                NSParagraphStyleAttributeName:paragraphStyle}];
    
//    _infTextView.text = [NSString stringWithFormat:@"职权类别:%@\n职权名称:%@\n职权编码:%@\n具体实施部门:%@", model.base.authority_category, model.base.authority_name, model.base.authority_code, model.base.put_section];
    
    _matTextView.attributedText =[[NSAttributedString alloc] initWithString: model.approval.approval_content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26*WIDTH_RATIO/2],NSForegroundColorAttributeName:YZ_COLOR(0x333333),                                                NSParagraphStyleAttributeName:paragraphStyle}];
//    _matTextView.text = model.approval.approval_content;
    [_matTextView sizeToFit];
    UITableView * tableView = [[self myScroll] viewWithTag:101];
    [tableView.tableHeaderView layoutSubviews];
    [tableView reloadData];
    
    _conTextView.attributedText =[[NSAttributedString alloc] initWithString: model.condition.accept_condition attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26*WIDTH_RATIO/2],NSForegroundColorAttributeName:YZ_COLOR(0x333333),                                                NSParagraphStyleAttributeName:paragraphStyle}];
//    _conTextView.text = model.condition.accept_condition;
}

#pragma mark --- 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.model = _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self changeBackBarButton];
    [self myScroll];
}

- (NSArray *)myScrollViewTitles{
    return THINGS_DETAIL_SCOLLBTN_TITLES;
}

- (UIView *)myScrollViewContentViewWithItem:(NSInteger)item{
    switch (item) {
        case 0:
        case 1:{

            UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            tableView.tag = 100 + item;
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.tableHeaderView = [self upHeaderView:item];
            tableView.bounces = NO;
            tableView.delegate = self;
            tableView.dataSource = self;
            
            if (item == 1) {
                tableView.rowHeight = 65*WIDTH_RATIO/2;
                tableView.separatorStyle = UITableViewCellAccessoryNone;
            }else{
                tableView.rowHeight = 86*WIDTH_RATIO/2;
            }
            
            return tableView;
        }
        default:{
            UIView * conView = [UIView new];
            conView.backgroundColor = [UIColor whiteColor];
            if (!_conTextView) {
                _conTextView = [UITextView new];
                _conTextView.showsVerticalScrollIndicator = NO;
                _conTextView.showsHorizontalScrollIndicator = NO;
                _conTextView.editable = NO;
                _conTextView.selectable = NO;
                _conTextView.bounces = NO;
                _conTextView.font = [UIFont systemFontOfSize:26*WIDTH_RATIO/2];
                _conTextView.textColor = YZ_COLOR(0x333333);
                
                [conView sd_addSubviews:@[_conTextView]];
                _conTextView.sd_layout
                .topSpaceToView(conView, 25*WIDTH_RATIO/2)
                .leftSpaceToView(conView, 50*WIDTH_RATIO/2)
                .rightSpaceToView(conView, 50*WIDTH_RATIO/2)
                .bottomSpaceToView(conView, 25*WIDTH_RATIO/2);
            }
            return conView;
        }
    }
}

- (UIView *)upHeaderView:(NSInteger)item{
    
    UIView * headerView = [UIView new];
    
    UITextView * textView = [UITextView new];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.selectable = NO;
    textView.userInteractionEnabled = NO;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.bounces = NO;
    textView.font = [UIFont systemFontOfSize:26*WIDTH_RATIO/2];
    textView.textColor = YZ_COLOR(0x333333);
    
    if (item == 1) {
        _matTextView = textView;
        
        UILabel * line = [UILabel new];
        line.backgroundColor = YZ_COLOR(0xefefef);
        
        headerView.userInteractionEnabled = NO;
        
        [headerView sd_addSubviews:@[_matTextView, line]];
        
        _matTextView.sd_layout
        .topSpaceToView(headerView, 25*WIDTH_RATIO/2)
        .leftSpaceToView(headerView, 50*WIDTH_RATIO/2)
        .rightSpaceToView(headerView, 50*WIDTH_RATIO/2);
        
        line.sd_layout
        .heightIs(15*WIDTH_RATIO/2)
        .topSpaceToView(_matTextView, 25*WIDTH_RATIO/2)
        .leftEqualToView(headerView)
        .rightEqualToView(headerView);
        
        [headerView setupAutoHeightWithBottomView:_matTextView bottomMargin:55*WIDTH_RATIO/2];
        
    }else{
        headerView.frame = CGRectMake(0, 0, MY_WIDTH, 380*WIDTH_RATIO/2);
        
        _infLabel = [UILabel new];
        _infLabel.textColor = YZ_COLOR(0x333333);
        _infLabel.font = [UIFont boldSystemFontOfSize:26*WIDTH_RATIO/2];
        _infLabel.textAlignment = NSTextAlignmentCenter;
        
        _infTextView = textView;
        
        UIView * backView = [UIView new];
        backView.backgroundColor = YZ_COLOR(0xefefef);
        
        [headerView sd_addSubviews:@[_infLabel, backView]];
        
        _infLabel.sd_layout
        .topEqualToView(headerView)
        .leftEqualToView(headerView)
        .rightEqualToView(headerView)
        .heightIs(100*WIDTH_RATIO/2);
        
        backView.sd_layout
        .topSpaceToView(headerView, 100*WIDTH_RATIO/2)
        .leftSpaceToView(headerView, 10*WIDTH_RATIO/2)
        .rightSpaceToView(headerView, 10*WIDTH_RATIO/2)
        .bottomEqualToView(headerView);
        
        [backView sd_addSubviews:@[_infTextView]];
        _infTextView.sd_layout
        .topSpaceToView(backView, 20*WIDTH_RATIO/2)
        .bottomSpaceToView(backView, 20*WIDTH_RATIO/2)
        .leftSpaceToView(backView, 40*WIDTH_RATIO/2)
        .rightSpaceToView(backView, 40*WIDTH_RATIO/2);
    }
    
    return headerView;
}

#pragma mark --- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return 4;
    }
    return _model.approval.download.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%@_%@", @(indexPath.section), @(indexPath.row)]];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%@_%@", @(indexPath.section), @(indexPath.row)]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:26*WIDTH_RATIO/2];
        cell.textLabel.textColor = YZ_COLOR(0x333333);
    }
    
    if (tableView.tag == 101) {
        cell.imageView.image = [UIImage imageNamed:CELL_POINT_IMG];
        cell.textLabel.text = [_model.approval.download[indexPath.row] down_name];
    }else{
        cell.imageView.image = [UIImage imageNamed:THINGS_DETAIL_CELL_IMGS[indexPath.row]];
        cell.textLabel.text = THINGS_DETAIL_CELL_TITLES[indexPath.row];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.view.userInteractionEnabled = NO;
    if (tableView.tag == 101) {
        _path = @"";
        _select = 0;
        _select = indexPath.row;
        [self presentWithName:[_model.approval.download[indexPath.row] down_name]];
    }else{
        switch (indexPath.row) {
            case 0:{
                [self mapAddress];
            }break;
            case 1:case 2:{
                [self showTelephoneAlertTag:indexPath.row];
                self.view.userInteractionEnabled = YES;
            }break;
            case 3:{
                YZWabVC * webVC = [YZWabVC new];
                [webVC loadUrl:_model.base.flow_chart];
                webVC.title = THINGS_DETAIL_CELL_TITLES[indexPath.row];
                [[YZRootVC sharedManager].navigationController pushViewController:webVC animated:YES];
            }break;
            default:
                self.view.userInteractionEnabled = YES;
                break;
        }
    }
}

- (void)mapAddress{
    if (_model.base.accept_address.length > 0) {
        if (!_search) {
            _search = [[AMapSearchAPI alloc] init];
            _search.delegate = self;
        }
        AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
        geo.address = _model.base.accept_address;
        [_search AMapGeocodeSearch:geo];
    }else {
        [YZProgressHUD showHudFailed:@"暂无地址"];
        self.view.userInteractionEnabled = YES;
    }
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
//    if (response.geocodes.count == 0)
//    {
//        self.view.userInteractionEnabled = YES;
//        return;
//    }
    
    AMapGeoPoint *location = response.geocodes.firstObject.location;
    
    YZYellowModel * model = [YZYellowModel new];
    model.mechanism_name = _model.base.title;
    model.address = _model.base.accept_address;
    model.longitude = (id)@(location.longitude);
    model.latitude = (id)@(location.latitude);
    
    if (response.geocodes.count == 0) {
        model.longitude = @"116.217158";
        model.latitude = @"40.227113";
    }
    
    YZYellowMapVC * mapVC = [YZYellowMapVC new];
    mapVC.title = @"受理地点";
    mapVC.model = model;
    [[YZRootVC sharedManager].navigationController pushViewController:mapVC animated:YES];
}

- (void)showTelephoneAlertTag:(NSInteger)tag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"呼叫电话：%@", tag==1?_model.base.hotline:_model.base.complaints_hotline] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    alert.tag = 100+tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
        NSString * phoneStr = [[alertView.tag==101?_model.base.hotline:_model.base.complaints_hotline componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneStr]]];
    }
}

#pragma mark 用于将cell分割线补全
-(void)viewDidLayoutSubviews {
    
    UITableView * tableView = [[self myScroll] viewWithTag:100];
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 0, 10*WIDTH_RATIO/2)];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 0, 10*WIDTH_RATIO/2)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 0, 10*WIDTH_RATIO/2)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10*WIDTH_RATIO/2, 0, 10*WIDTH_RATIO/2)];
    }
}

- (void)presentWithName:(NSString *)name{
    
    QLPreviewController *qlPC = [[QLPreviewController alloc]init];
    //设置代理
    qlPC.dataSource = self;
    [[UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil] setTintColor:[UIColor whiteColor]];
    
    [UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil].translucent = NO;//首先要将当前的navigationBar的半透明设置为Yes;为NO的导航栏不透明
    [UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil].hidden = NO;
    //这里设置navigationBar的背景图片为一张 1像素 的透明背景图片
    [[UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil] setBackgroundImage:[UIImage imageNamed:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [qlPC.navigationItem setHidesBackButton:YES];
    qlPC.navigationController.navigationBar.tintColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 40, 60);
    
    [btn setImage:[UIImage imageNamed:NAV_BACK] forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -20 * WIDTH_RATIO;
    
    qlPC.navigationItem.leftBarButtonItems = @[spaceItem, back];
    
    qlPC.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    
    //读取沙盒中的文件
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    _path = [docStr stringByAppendingPathComponent:name];
    
    if ([self isFileExist:_path]) {
        [self.navigationController
         pushViewController:qlPC animated:YES];
    }else{
        //下载文件
        WeakSelf;
        [YZNetMaster download:[_model.approval.download[_select] down_url] progress:^(NSProgress * _Nonnull downloadProgress) {
            //进度回调,可在此监听下载进度(已经下载的大小/文件总大小)
            NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:_path];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            [weakSelf.navigationController
             pushViewController:qlPC animated:YES];
        }];
    }
}

#pragma mark -- datasource协议方法
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    return [NSURL fileURLWithPath:_path];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//判断文件是否已经在沙盒中已经存在？
-(BOOL)isFileExist:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

@end
