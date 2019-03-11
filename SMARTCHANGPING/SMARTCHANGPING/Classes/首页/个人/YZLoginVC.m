//
//  YZLoginVC.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/10.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZLoginVC.h"

@interface YZLoginVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView * backView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UITextField * useTextField;
@property (nonatomic, strong) UITextField * pasTextField;

@end

@implementation YZLoginVC

- (void)onLoginBtn:(UIButton *)sender{
    [self.view endEditing:YES];
}

- (void)goBackAction{
    self.view.userInteractionEnabled = NO;
    // 在这里增加返回按钮的自定义动作
    [self dismissViewControllerAnimated:YES completion:^{
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat height = keyboardFrame.origin.y;
    _backView.frame = CGRectMake(0, 0, MY_WIDTH, height);
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    _backView.frame = CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self upView];
}

- (void)upView{
    
    _backView = [UIScrollView new];
    _backView.backgroundColor = [UIColor clearColor];
    _backView.frame = CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT);
    
    UIButton * backBtn = [UIButton new];
    [backBtn setImage:[UIImage imageNamed:NAV_DISMISS] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(10*WIDTH_RATIO, 30, 30*WIDTH_RATIO, 30*WIDTH_RATIO);
    backBtn.backgroundColor = [UIColor redColor];
    backBtn.layer.cornerRadius = 15*WIDTH_RATIO;
    backBtn.clipsToBounds = YES;
    
    [self.view addSubview:_backView];
    [self.view addSubview:backBtn];
    
    _iconView = [UIImageView new];
    _iconView.image = [UIImage imageNamed:LOGIN_LOGO_IMG];
    
    _useTextField = [self upTextField];
    _pasTextField = [self upTextField];
    [self customTextField];
    
    UIButton * loginBtn = [UIButton new];
    [loginBtn addTarget:self action:@selector(onLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:38*WIDTH_RATIO/2]];
    [loginBtn setBackgroundColor:YZ_COLOR(0xe5322e)];
    
    loginBtn.layer.cornerRadius = 10*WIDTH_RATIO/2;
    loginBtn.layer.shadowColor = [YZ_COLOR(0x9a2422) CGColor];
    loginBtn.layer.shadowOffset =  CGSizeMake(WIDTH_RATIO, WIDTH_RATIO);
    loginBtn.layer.shadowOpacity = 0.8;
    
    [_backView sd_addSubviews:@[_iconView, loginBtn]];
    
    _iconView.sd_layout
    .widthIs(180*WIDTH_RATIO/2)
    .heightEqualToWidth()
    .topSpaceToView(_backView, 242*WIDTH_RATIO/2)
    .centerXEqualToView(_backView);
    
    _useTextField.superview.sd_layout
    .leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .topSpaceToView(_iconView, 88*WIDTH_RATIO/2)
    .heightIs(96*WIDTH_RATIO/2);
    
    _pasTextField.superview.sd_layout
    .leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .topSpaceToView(_useTextField.superview, WIDTH_RATIO)
    .heightIs(96*WIDTH_RATIO/2);
    
    loginBtn.sd_layout
    .topSpaceToView(_pasTextField.superview, 54*WIDTH_RATIO/2)
    .leftSpaceToView(_backView, 56*WIDTH_RATIO/2)
    .rightSpaceToView(_backView, 56*WIDTH_RATIO/2)
    .heightIs(96*WIDTH_RATIO/2);
    
    [_backView setupAutoContentSizeWithBottomView:loginBtn bottomMargin:40*WIDTH_RATIO/2];
}

- (UITextField *)upTextField{
    UITextField * textField = [UITextField new];
    textField.font = [UIFont systemFontOfSize:30*WIDTH_RATIO/2];
    textField.textColor = YZ_COLOR(0x333333);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [_backView sd_addSubviews:@[view]];
    
    [view sd_addSubviews:@[textField]];
    
    textField.sd_layout
    .topEqualToView(view)
    .bottomEqualToView(view)
    .leftSpaceToView(view, 40*WIDTH_RATIO/2)
    .rightSpaceToView(view, 40*WIDTH_RATIO/2);
    
    return textField;
}

- (void)customTextField{
    _useTextField.placeholder = LOGIN_NAME_TEXT;
    _pasTextField.placeholder = LOGIN_PASS_TEXT;
    
    UIView * useView = [UIView new];
    useView.frame = CGRectMake(0, 0, 50*WIDTH_RATIO/2, 40*WIDTH_RATIO/2);
    UIImageView * useImg = [UIImageView new];
    useImg.frame = CGRectMake(0, 0, 33*WIDTH_RATIO/2, 33*WIDTH_RATIO/2);
    useImg.image = [UIImage imageNamed:LOGIN_NAME_IMG];
    
    [useView addSubview:useImg];
    _useTextField.leftView = useView;
    
    UIView * pasView = [UIView new];
    pasView.frame = CGRectMake(0, 0, 50*WIDTH_RATIO/2, 40*WIDTH_RATIO/2);
    UIImageView * pasImg = [UIImageView new];
    pasImg.frame = CGRectMake(0, 0, 33*WIDTH_RATIO/2, 33*WIDTH_RATIO/2);
    pasImg.image = [UIImage imageNamed:LOGIN_PASS_IMG];
    
    [pasView addSubview:pasImg];
    _pasTextField.leftView = pasView;
}

@end
