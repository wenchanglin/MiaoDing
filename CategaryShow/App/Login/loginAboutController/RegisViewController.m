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
@property (nonatomic, retain) BaseDomain *regisClick;
@property (nonatomic, retain) UITextField *regisWord;
@property (nonatomic, retain) BaseTextField *firstPassWord;
@property (nonatomic, retain) BaseTextField *CheckPassWord;

@end

@implementation RegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:getUIColor(Color_background)];
    self.title = @"注册";
    self.regisClick = [BaseDomain getInstance:YES];
    
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
        [_regisClick postData:@"/buser/accountCheck.do" PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            NSLog(@"%@", _regisClick.dataRoot);
            if ([self checkHttpResponseResultStatus:_regisClick]) {
                
                NextRegisViewController *next = [[NextRegisViewController alloc] init];
                next.userNumber = _userName.text;
                [self.navigationController pushViewController:next animated:YES];
                
            }
        }];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机格式输入有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189
     22 */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
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
