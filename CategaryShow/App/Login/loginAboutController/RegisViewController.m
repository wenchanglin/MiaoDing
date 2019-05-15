//
//  RegisViewController.m
//  TakeAuto
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//
#import "Masonry.h"
#import "RegisViewController.h"
#import "JYHColor.h"
#import "JKCountDownButton.h"
#import "NextRegisViewController.h"
#import "BaseTextField.h"
#import "LoginManager.h"
#import "AppDelegate.h"
#import "UserDelegateViewController.h"
@interface RegisViewController ()
@property (nonatomic, retain)UITextField *userName;
@property (nonatomic, retain) UITextField *regisWord;
@property (nonatomic, retain) BaseTextField *firstPassWord;
@property (nonatomic, retain) BaseTextField *CheckPassWord;

@end

@implementation RegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:getUIColor(Color_background)];
    self.title = @"注册";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:getUIColor(Color_mainColor)}];
    // Do any additional setup after loading the view.
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
    
    UIButton *NextClick = [[UIButton alloc] init];
    NextClick.adjustsImageWhenHighlighted = YES;
    NextClick.backgroundColor = getUIColor(Color_mainColor);
    [NextClick addTarget:self action:@selector(NextClick) forControlEvents:UIControlEventTouchUpInside];
    [NextClick setTitle:@"下一步" forState:UIControlStateNormal];
    [NextClick.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [NextClick.layer setCornerRadius:1];
    [NextClick.layer setMasksToBounds:YES];
    [self.view addSubview:NextClick];
    [NextClick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.top.equalTo(_userName.mas_bottom).with.offset(15);
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
-(void)UserDelegate
{
    UserDelegateViewController *userDele = [[UserDelegateViewController alloc] init];
    [self.navigationController pushViewController:userDele animated:YES];
    
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
    if ([self.userName.text length] == 11) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.userName.text forKey:@"account"];
//        [_regisClick postData:@"/buser/accountCheck.do" PostParams:params finish:^(BaseDomain *domain, Boolean success) {
//            NSLog(@"%@", _regisClick.dataRoot);
//            if ([self checkHttpResponseResultStatus:_regisClick]) {
//                
//                NextRegisViewController *next = [[NextRegisViewController alloc] init];
//                next.userNumber = _userName.text;
//                [self.navigationController pushViewController:next animated:YES];
//                
//            }
//        }];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机格式输入有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    NSString *target = @"^(0|86|17951)?(13[0-9]|15[012356789]|16[6]|19[89]]|17[01345678]|18[0-9]|14[579])[0-9]{8}$";
    NSPredicate *targetPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", target];
    if ([targetPredicate evaluateWithObject:mobileNum])
    {
        return YES;
    }
    else
    {
        return NO;
    }
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
