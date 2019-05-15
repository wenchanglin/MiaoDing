//
//  NextRegisViewController.m
//  TakeAuto
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//


#import "RegisViewController.h"
#import "JYHColor.h"
#import "JKCountDownButton.h"
#import "NextRegisViewController.h"
#import "BaseTextField.h"
#import "LoginManager.h"
#import "AppDelegate.h"
#import "Masonry.h"


@interface NextRegisViewController ()
@property (nonatomic, retain)UITextField *userName;
@property (nonatomic, retain) UITextField *regisWord;
@property (nonatomic, retain) BaseTextField *firstPassWord;
@property (nonatomic, retain) BaseTextField *CheckPassWord;
@end

@implementation NextRegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:getUIColor(Color_background)];
    self.title = @"注册";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:getUIColor(Color_mainColor)}];
    [self createView];
}

-(void)createView
{
    UIView *topLine = [[UIView alloc] init];
    [topLine setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(15);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@0.5);
    }];
    
    self.userName = [[UITextField alloc] init];
    _userName.delegate = self;
    [_userName setText:_userNumber];
    [self setTextFieldLeftPadding:_userName forWidth:20];
    [_userName setBackgroundColor:[UIColor whiteColor]];
    [_userName setPlaceholder:@"请输入手机号码"];
    [_userName setLeftViewMode:UITextFieldViewModeAlways];
    [_userName setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:_userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLine.mas_left);
        make.top.equalTo(topLine.mas_bottom);
        make.height.equalTo(@40);
        make.width.equalTo(topLine.mas_width);
    }];
    
    UIView *midLine1 = [[UIView alloc] init];
    [midLine1 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:midLine1];
    [midLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName.mas_bottom);
        make.left.equalTo(_userName.mas_left);
        make.width.equalTo(_userName.mas_width);
        make.height.equalTo(@0.5);
    }];
    
    
    UIView *midLine2 = [[UIView alloc] init];
    [midLine2 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:midLine2];
    [midLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midLine1.mas_bottom).with.offset(20);
        make.left.equalTo(midLine1.mas_left);
        make.right.equalTo(midLine1.mas_right).with.offset(-120);
        make.height.equalTo(@0.5);
    }];
    
    
    self.regisWord = [[UITextField alloc] init];
    _regisWord.delegate = self;
    [self setTextFieldLeftPadding:_regisWord forWidth:20];
    [_regisWord setBackgroundColor:[UIColor whiteColor]];
    [_regisWord setPlaceholder:@"请输入验证码"];
    [_regisWord setLeftViewMode:UITextFieldViewModeAlways];
    [_regisWord setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:_regisWord];
    [_regisWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midLine2.mas_left);
        make.top.equalTo(midLine2.mas_bottom);
        make.height.equalTo(@40);
        make.width.equalTo(midLine2.mas_width);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    [bottomLine setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_regisWord.mas_bottom);
        make.left.equalTo(_regisWord.mas_left);
        make.width.equalTo(_regisWord.mas_width);
        make.height.equalTo(@0.5);
    }];
    
    JKCountDownButton *sendButton = [[JKCountDownButton alloc] init];
    [sendButton setBackgroundColor:[UIColor whiteColor]];
    [sendButton.layer setCornerRadius:1];
    [sendButton.layer setMasksToBounds:YES];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];

//    sendButton.enabled = NO;
    [sendButton didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"重新发送(%d)",second];
        return title;
    }];
    [sendButton didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"重新获取";
    }];

    

    [self.view addSubview:sendButton];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomLine.mas_right).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(midLine2.mas_top);
        make.bottom.equalTo(bottomLine.mas_bottom);
    }];
    
    
    
    
    self.firstPassWord = [[BaseTextField alloc] init];
    _firstPassWord.detailField.delegate = self;
    [self setTextFieldLeftPadding:_firstPassWord.detailField forWidth:20];
    [_firstPassWord setBackgroundColor:[UIColor whiteColor]];
    [_firstPassWord.detailField setPlaceholder:@"请输入密码"];
    [_firstPassWord.detailField setSecureTextEntry:YES];
    [_firstPassWord.detailField setLeftViewMode:UITextFieldViewModeAlways];

    [self.view addSubview:_firstPassWord];
    [_firstPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomLine.mas_left);
        make.top.equalTo(bottomLine.mas_bottom).with.offset(15);
        make.height.equalTo(@40);
        make.width.equalTo(topLine.mas_width);
    }];
    
    self.CheckPassWord = [[BaseTextField alloc] init];
    _CheckPassWord.detailField.delegate = self;
    [self setTextFieldLeftPadding:_CheckPassWord.detailField forWidth:20];
    [_CheckPassWord setBackgroundColor:[UIColor whiteColor]];
    [_CheckPassWord.detailField setPlaceholder:@"请再次输入密码"];
     [_CheckPassWord.detailField setSecureTextEntry:YES];
    [_CheckPassWord.detailField setLeftViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:_CheckPassWord];
    [_CheckPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstPassWord.mas_left);
        make.top.equalTo(_firstPassWord.mas_bottom).with.offset(15);
        make.height.equalTo(@40);
        make.width.equalTo(_firstPassWord.mas_width);
    }];
    
    
    UIButton *NextClick = [[UIButton alloc] init];
    NextClick.adjustsImageWhenHighlighted = YES;
    NextClick.backgroundColor = getUIColor(Color_mainColor);
    [NextClick addTarget:self action:@selector(NextClick) forControlEvents:UIControlEventTouchUpInside];
    [NextClick setTitle:@"注册" forState:UIControlStateNormal];
    [NextClick.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [NextClick.layer setCornerRadius:1];
    [NextClick.layer setMasksToBounds:YES];
    [self.view addSubview:NextClick];
    [NextClick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.top.equalTo(_CheckPassWord.mas_bottom).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.height.equalTo(@40);
    }];
    
    UILabel *labelBottom = [[UILabel alloc] init];
    [labelBottom setTextColor:[UIColor grayColor]];
    [labelBottom setText:@"注册代表同意"];
    [labelBottom setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:labelBottom];
    
    [labelBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).with.offset(-1);
        make.top.equalTo(NextClick.mas_bottom).with.offset(20);
        make.height.equalTo(@15);
        
    }];
    UIButton *buttonBottom = [[UIButton alloc] init];
    [buttonBottom setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
    [buttonBottom setTitleColor:getUIColor(Color_mainColor) forState:UIControlStateNormal];
    [buttonBottom.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:buttonBottom];
    
    [buttonBottom addTarget:self action:@selector(UserDelegate) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).with.offset(1);
        make.top.equalTo(NextClick.mas_bottom).with.offset(20);
        make.height.equalTo(@15);
        
    }];
    
}


-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
-(void)NextClick
{
//    if ([_firstPassWord.detailField.text length] < 6) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能少于6位数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    } else {
//        if ([_firstPassWord.detailField.text isEqualToString:_CheckPassWord.detailField.text]) {
//            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            [params setObject:_userName.text forKey:@"account"];
//            [params setObject:_regisWord.text forKey:@"checkCode"];
//            [params setObject:_firstPassWord.detailField.text forKey:@"password"];
//            [params setValue:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@"imei"];
//
//            [_regisClick postData:@"/buser/register.do" PostParams:params finish:^(BaseDomain *domain, Boolean success) {
//                NSLog(@"%@", _regisClick.dataRoot);
//                if ([self checkHttpResponseResultStatus:_regisClick]) {
//                    [[LoginManager getInstance] postLoginAuth:self.userName.text userPwd:self.firstPassWord.detailField.text isAuto:NO finish:^(Boolean success) {
//                        if (success) {
//                            [[AppDelegate getInstance] runMainViewController :self];
//                            //                        SetUserInfoViewController *user = [[SetUserInfoViewController alloc] init];
//                            //                        user.registerBool = @"yes";
//                            //                        [self.navigationController pushViewController:user animated:YES];
//                        }
//                    }];
//                }
//            }];
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两遍输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//
//    }
    
    
}
-(void)sendClick:(JKCountDownButton *)sendButton
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.userName.text forKey:@"account"];
    [params setObject:@"1" forKey:@"codeType"];
//    [_regisClick postData:@"/buser/applyCheckCode.do" PostParams:params finish:^(BaseDomain *domain, Boolean success) {
//        NSLog(@"%@", _regisClick.dataRoot);
//        
//        if ([self checkHttpResponseResultStatus:_regisClick]) {
//
//                sendButton.enabled = NO;
//                [sendButton startWithSecond:120];
//                [sendButton didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
//                    NSString *title = [NSString stringWithFormat:@"重新发送(%d)",second];
//                    return title;
//                }];
//                [sendButton didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
//                    countDownButton.enabled = YES;
//                    return @"重新获取";
//                }];
//
//        }
//    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
