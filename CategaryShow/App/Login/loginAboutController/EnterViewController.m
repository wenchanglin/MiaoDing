
//  EnterViewController.m
//  TakeAuto
//
//  Created by apple on 15/6/30.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "EnterViewController.h"
#import "JYHColor.h"
#import "RegisViewController.h"
#import "LoginManager.h"
#import "JKCountDownButton.h"
#import "DJRegisterView.h"
#import "LYTextField.h"
#import "LYButton.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "UserDelegateViewController.h"
@interface EnterViewController ()<YBAttributeTapActionDelegate,UITextFieldDelegate>

@property (retain,nonatomic) BaseDomain *loginDomain;

@property (nonatomic, retain) UISwitch *remenber;
//- (void)onLoginClickEvent:(id)sender;

@end

@implementation EnterViewController
{
    BaseDomain *getDataCount;
    UITextField *username;
    UITextField *checkCount;
    JKCountDownButton *sendButton;
    UIButton *login;
    CGFloat initViewY;
    Boolean isViewYFisrt;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperview];
//    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self setUp];

}

-(void)quitClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelLogin" object:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUp{
   
    UIImageView * mainImageView = [UIImageView new];
    mainImageView.userInteractionEnabled = YES;
    mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    mainImageView.image =[UIImage imageNamed:@"loginBackImg"];
    [self.view addSubview:mainImageView];
    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIButton *buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 40, 40, 40)];
    [buttonClose addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonClose setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    [self.view addSubview:buttonClose];
    username = [UITextField new];
    [self.view addSubview:username];
    [username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCREEN_HEIGHT/2-64);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(30);
    }];
//    username.sd_layout
//    .leftSpaceToView(self.view, 60)
//    .rightSpaceToView(self.view, 60)
//    .topSpaceToView(self.view, (95 / 667.0) * SCREEN_HEIGHT)
//    .heightIs(30);新版本
    
    username.placeholder = @"请输入11位手机号码";
    username.keyboardType = UIKeyboardTypeNumberPad;
    [username setTextColor:[UIColor colorWithHexString:@"#222222"]];
    [username setFont:[UIFont fontWithName:@"PingFangSC-Light" size:16]];
    username.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    username.delegate = self;
    [username setValue:[UIColor colorWithHexString:@"#A6A6A6"] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *lineUserName = [UIView new];
    [lineUserName setBackgroundColor:[UIColor colorWithHexString:@"#979797"]];
    [self.view addSubview:lineUserName];
    lineUserName.sd_layout
    .leftSpaceToView(self.view, 60)
    .rightSpaceToView(self.view, 60)
    .topSpaceToView(username, 0)
    .heightIs(1);
    
    checkCount = [UITextField new];
    [self.view addSubview:checkCount];
    checkCount.sd_layout
    .leftSpaceToView(self.view, 60)
    .rightSpaceToView(self.view, 60)
    .topSpaceToView(lineUserName, 30)
    .heightIs(30);
    [checkCount setFont:[UIFont fontWithName:@"PingFangSC-Light" size:16]];
    [checkCount setTextColor:[UIColor colorWithHexString:@"#222222"]];
    checkCount.placeholder = @"请输入验证码";
    [checkCount setSecureTextEntry:YES];
    checkCount.keyboardType = UIKeyboardTypeNumberPad;
    [checkCount setValue:[UIColor colorWithHexString:@"#A6A6A6"] forKeyPath:@"_placeholderLabel.textColor"];
//    UIImageView *imageViewCheck = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140 / 2, 36 / 2)];
//    imageViewCheck.image=[UIImage imageNamed:@"Check"];
//    checkCount.leftView=imageViewCheck;
    checkCount.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    checkCount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    checkCount.delegate = self;
    
//    UIView *lineCheck = [[UIView alloc] initWithFrame:CGRectMake(30, 340, SCREEN_WIDTH - 60, 1)];
    
    UIView *lineCheck = [UIView new];
    [lineCheck setBackgroundColor:[UIColor colorWithHexString:@"#979797"]];
    [self.view addSubview:lineCheck];
    lineCheck.sd_layout
    .leftSpaceToView(self.view, 60)
    .rightSpaceToView(self.view, 60)
    .topSpaceToView(checkCount, 0)
    .heightIs(1);
    
    
    sendButton = [JKCountDownButton new];
     [self.view addSubview:sendButton];
    
    sendButton.sd_layout
    .rightSpaceToView(self.view, 60)
    .bottomSpaceToView(lineCheck, 4)
    .heightIs(30)
    .widthIs(90);
    [sendButton.layer setCornerRadius:3];
    [sendButton.layer setMasksToBounds:YES];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setUserInteractionEnabled:NO];
    [sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundColor:[UIColor lightGrayColor]];
    [sendButton didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"重发(%d)",second];
        return title;
    }];
    [sendButton didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"重新获取";
    }];
    
    login = [UIButton new];
    [login setTitle:@"进入妙定" forState:(UIControlStateNormal)];
    login.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.view addSubview:login];
    
    login.sd_layout
    .topSpaceToView(lineCheck, 57)
    .leftSpaceToView(self.view, 42)
    .rightSpaceToView(self.view, 42)
    .heightIs(44);
    [login setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [login.layer setCornerRadius:3];
    [login.layer setMasksToBounds:YES];
    [login addTarget:self action:@selector(LoginClick) forControlEvents:UIControlEventTouchUpInside];

   

    NSString *label_text2 = @"温馨提示:未注册的手机号将自动注册为妙定用户,且代表已阅读并同意《妙定用户协议》";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:NSMakeRange(0, label_text2.length)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:getUIColor(Color_TKClolor) range:NSMakeRange(32, 7)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label_text2 length])];
//
    UILabel *ybLabel2 = [UILabel new];
    [self.view addSubview:ybLabel2];
    ybLabel2.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 40)
    .heightIs(15);
    [ybLabel2 setTextColor:getUIColor(Color_loginNoUserName)];
    [ybLabel2 setFont:[UIFont systemFontOfSize:8]];
    ybLabel2.numberOfLines = 2;
    [ybLabel2 setText:label_text2];
    ybLabel2.attributedText = attributedString2;
    [ybLabel2 setTextAlignment:NSTextAlignmentCenter];


     [ybLabel2 yb_addAttributeTapActionWithStrings:@[@"妙定用户协议"] delegate:self];
    //设置是否有点击效果，默认是YES
    
}



//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//
//    if (isViewYFisrt) {
//        initViewY = self.view.frame.origin.y;
//        isViewYFisrt = NO;
//    }
//
//    int offset = [self getControlFrameOriginY:textField] + 75 - (self.view.frame.size.height - 216.0);//键盘高度216
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset > 0)
//        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//
//    [UIView commitAnimations];
//}
//
//- (CGFloat) getControlFrameOriginY : (UIView *) curView {
//
//    CGFloat resultY = 0;
//
//    if ([curView superview] != nil && ![[curView superview] isEqual:self.view]) {
//        resultY = [self getControlFrameOriginY:[curView superview]];
//    }
//
//    return resultY + curView.frame.origin.y;
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    CGRect frame = self.view.frame;
//
//    frame.origin.x = 0;
//    frame.origin.y = initViewY;
//
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//
//    [self.view setFrame:frame];
//
//    [UIView commitAnimations];
//    //    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//}



- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    UserDelegateViewController *userd = [[UserDelegateViewController alloc] init];
    [self presentViewController:userd animated:NO completion:nil];
}


-(void)sendClick:(JKCountDownButton *)sender
{
    
    if (username.text.length == 0) {
        
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:username.text forKey:@"phone"];
        [params setObject:@"1" forKey:@"type"];
        [getDataCount postData:URL_GetCheckCount PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            NSLog(@"%@", getDataCount.dataRoot);
            
            if ([self checkHttpResponseResultStatus:getDataCount]) {
                
                NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
                [used setObject:[[getDataCount.dataRoot objectForKey:@"data"] stringForKey:@"token"] forKey:@"token"];
                
                sender.enabled = NO;
                [sender startWithSecond:120];
                [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                    NSString *title = [NSString stringWithFormat:@"重发(%d)",second];
                    return title;
                }];
                [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                    countDownButton.enabled = YES;
                    return @"重新获取";
                }];
                
            }
        }];
        

    }
    
}

-(void)textFiledEditChanged:(NSNotification *)obj
{
    
    
    UITextField *textField = (UITextField *)obj.object;
    
    
    if (textField == username) {
        
        NSString *toBeString = textField.text;
        
        if ([toBeString length] > 0) {
            [sendButton setUserInteractionEnabled:YES];
            [sendButton setBackgroundColor:getUIColor(Color_loginHaveName)];
        } else {
            [sendButton setUserInteractionEnabled:NO];
             [sendButton setBackgroundColor:getUIColor(Color_loginNoUserName)];
        }
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > 11)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:11];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:11];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 11)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    } else {
        NSString *toBeString = textField.text;
        if ([toBeString length] > 0 && [username.text length] > 0) {
            [login setUserInteractionEnabled:YES];
            login.backgroundColor = [UIColor colorWithHexString:@"#151515"];
        } else {
            [login setUserInteractionEnabled:NO];
            login.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
        }
    }
    
}



-(CAGradientLayer *)backgroundLayer{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0.65,@1];
    return gradientLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"手机登录"];
    isViewYFisrt = YES;
    [self.view.layer addSublayer: [self backgroundLayer]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)name:@"UITextFieldTextDidChangeNotification" object:username];
    getDataCount = [BaseDomain getInstance:NO];
    if (self.loginDomain == nil) {
        self.loginDomain = [BaseDomain getInstance:NO];
    }

   

    
    
}


- (void)LoginClick{
    
    // 检测手机号码是否输入
    if (username.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_title_tip", nil) message:NSLocalizedString(@"login_auth_isemptrytip", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_okknow", nil) otherButtonTitles: nil];
        
        [alertView show];
        
        [username becomeFirstResponder];
        
        return;
    }
    
    // 检测密码是否输入
    if (checkCount.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_title_tip", nil) message:NSLocalizedString(@"login_auth_isemptrytip", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_okknow", nil) otherButtonTitles: nil];
        
        [alertView show];
        
        [checkCount becomeFirstResponder];
        
        return;
    }
    
    
    
    
    
    [[LoginManager getInstance] postLoginAuth:username.text userPwd:checkCount.text loginId:_loginId isAuto:YES finish:^(Boolean success) {
        if (success) {
//            [[AppDelegate getInstance] runMainViewController : self];
            [self dismissViewControllerAnimated:YES completion:nil];
//            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            
        } else {
            
        }
    }];
//    [[AppDelegate getInstance] runMainViewController : self];
}


-(void)regisClick
{
    RegisViewController *regisViewController = [[RegisViewController alloc] init];
    [self.navigationController pushViewController:regisViewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MD5加密方式
-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    
    /*
     
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     
     */
    return [NSString stringWithFormat:
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
    
    /*
     
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     
     NSLog("%02X", 0x888);  //888
     
     NSLog("%02X", 0x4); //04
     
     */
    
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
