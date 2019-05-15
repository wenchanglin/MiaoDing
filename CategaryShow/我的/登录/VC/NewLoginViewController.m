//
//  NewLoginViewController.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/6.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "NewLoginViewController.h"
#import "EnterViewController.h"
#import "JYHNavigationController.h"
#import <ShareSDK/ShareSDK.h>
#import "BangDingPhotoVC.h"
#import "SelfPersonInfo.h"
@interface NewLoginViewController ()
@property(nonatomic,strong)UIImageView * mainImageView;
@property(nonatomic,strong)UIButton * closeBtn;
@property(nonatomic,strong)UILabel * firstLabel;
@property(nonatomic,strong)UILabel * secondLabel;
@property(nonatomic,strong)UIButton * wechatBtn;
@property(nonatomic,strong)UIButton * qqBtn;
@property(nonatomic,strong)UIButton * sinaBtn;
@property(nonatomic,strong)UIButton * moreBtn;
@end

@implementation NewLoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.view.backgroundColor = [UIColor blackColor];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _mainImageView = [UIImageView new];
    _mainImageView.userInteractionEnabled = YES;
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.image = [UIImage imageNamed:@"登录背景图"];
    [self.view addSubview:_mainImageView];
    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _closeBtn = [UIButton new];
    [_closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:(UIControlStateNormal)];
    [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [_mainImageView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32);
        make.top.mas_equalTo(NavHeight+44);
    }];
    _moreBtn = [UIButton new];
    [_moreBtn setImage:[UIImage imageNamed:@"more"] forState:(UIControlStateNormal)];
    [_moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [_mainImageView addSubview:_moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-29);
        make.centerX.equalTo(_mainImageView.mas_centerX);
    }];
    _wechatBtn = [UIButton new];
    [_wechatBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
    _wechatBtn.tag = 11;
    [_wechatBtn setImage:[UIImage imageNamed:@"wechat登录"] forState:UIControlStateNormal];
    [_mainImageView addSubview:_wechatBtn];
    [_wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_moreBtn.mas_top).offset(-38);
        make.left.mas_equalTo(47);
    }];
    UIView * firstV = [UIView new];
    firstV.alpha =0.56;
    firstV.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [_mainImageView addSubview:firstV];
    [firstV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_moreBtn.mas_top).offset(-48.7);
        make.left.equalTo(_wechatBtn.mas_right).offset(28);
        make.height.mas_equalTo(34.3);
        make.width.mas_equalTo(1);
    }];
    _qqBtn = [UIButton new];
    _qqBtn.tag=12;
    [_qqBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_qqBtn setImage:[UIImage imageNamed:@"QQ登录"] forState:UIControlStateNormal];
    [_mainImageView addSubview:_qqBtn];
    [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_moreBtn.mas_top).offset(-38);
        make.left.equalTo(_wechatBtn.mas_right).offset(58);
    }];
    UIView * secondV = [UIView new];
    secondV.alpha =0.56;
    secondV.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [_mainImageView addSubview:secondV];
    [secondV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_moreBtn.mas_top).offset(-48.7);
        make.left.equalTo(_qqBtn.mas_right).offset(28);
        make.height.mas_equalTo(34.3);
        make.width.mas_equalTo(1);
    }];
    _sinaBtn = [UIButton new];
    _sinaBtn.tag = 13;
    [_sinaBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_sinaBtn setImage:[UIImage imageNamed:@"Sina登录"] forState:UIControlStateNormal];
    [_mainImageView addSubview:_sinaBtn];
    [_sinaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_moreBtn.mas_top).offset(-38);
        make.left.equalTo(_qqBtn.mas_right).offset(58);
    }];
    _secondLabel = [UILabel new];
    _secondLabel.numberOfLines =0;
    _secondLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:34];
    _secondLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _secondLabel.text = @"定制每一个细节";
    [_mainImageView addSubview:_secondLabel];
    [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.bottom.equalTo(_qqBtn.mas_top).offset(-34);
    }];
    _firstLabel = [UILabel new];
    _firstLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:27];
    _firstLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _firstLabel.text = @"为不讲究的你";
    [_mainImageView addSubview:_firstLabel];
    [_firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.bottom.equalTo(_secondLabel.mas_top).offset(-6);
    }];
}
-(void)thirdLogin:(UIButton *)btn
{
    switch (btn.tag) {
        case 11:
        {
            [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
                [parameter setObject:user.uid forKey:@"userid"];
                [parameter setObject:@"1" forKey:@"is_type"];
                [[wclNetTool sharedTools]request:POST urlString:@"/index/login/partLogin" parameters:parameter finished:^(id responseObject, NSError *error) {
                    if([responseObject[@"code"] intValue]==1)
                    {
                        NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
                        [used setObject:responseObject[@"data"][@"token"] forKey:@"token"];
//                        [[userInfoModel getInstance] saveLoginData:responseObject[@"data"][@"name"] userImg:@""];
//                        [[SelfPersonInfo shareInstance].userModel setPersonInfoFromJsonData:responseObject[@"data"]];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];

                    }
                    else
                    {
                        BangDingPhotoVC * bvc = [[BangDingPhotoVC alloc]init];
                        bvc.userid = user.uid;
                        bvc.is_type = 1;
                        bvc.icon = user.icon;
                        bvc.nickname = user.nickname;
                        [self.navigationController pushViewController:bvc animated:YES];
                    }
                }];
            }];
        }
            break;
         case 12:
        {
            [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                WCLLog(@"uid=%@",user.uid);
                WCLLog(@"%@",user.credential);
                WCLLog(@"token=%@",user.credential.token);
                WCLLog(@"nickname=%@",user.nickname);
                NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
                [parameter setObject:user.uid forKey:@"userid"];
                [parameter setObject:@"2" forKey:@"is_type"];
                [[wclNetTool sharedTools]request:POST urlString:@"/index/login/partLogin" parameters:parameter finished:^(id responseObject, NSError *error) {
                    if([responseObject[@"code"] intValue]==1)
                    {
                        NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
                        [used setObject:responseObject[@"data"][@"token"] forKey:@"token"];
//                        [[userInfoModel getInstance] saveLoginData:responseObject[@"data"][@"name"] userImg:@""];
//                        [[SelfPersonInfo shareInstance].userModel setPersonInfoFromJsonData:responseObject[@"data"]];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                        
                    }
                    else
                    {
                        BangDingPhotoVC * bvc = [[BangDingPhotoVC alloc]init];
                        bvc.userid = user.uid;
                        bvc.is_type = 2;
                        bvc.icon = user.icon;
                        bvc.nickname = user.nickname;
                        [self.navigationController pushViewController:bvc animated:YES];
                    }
                }];
            }];
        }break;
            case 13:
        {
            [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                WCLLog(@"uid=%@",user.uid);
                WCLLog(@"%@",user.credential);
                WCLLog(@"token=%@",user.credential.token);
                WCLLog(@"nickname=%@",user.nickname);
                NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
                [parameter setObject:user.uid forKey:@"userid"];
                [parameter setObject:@"3" forKey:@"is_type"];
                [[wclNetTool sharedTools]request:POST urlString:@"/index/login/partLogin" parameters:parameter finished:^(id responseObject, NSError *error) {
                    if([responseObject[@"code"] intValue]==1)
                    {
                        NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
                        [used setObject:responseObject[@"data"][@"token"] forKey:@"token"];
//                        [[userInfoModel getInstance] saveLoginData:responseObject[@"data"][@"name"] userImg:@""];
//                        [[SelfPersonInfo shareInstance].userModel setPersonInfoFromJsonData:responseObject[@"data"]];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                        
                    }
                    else
                    {
                        BangDingPhotoVC * bvc = [[BangDingPhotoVC alloc]init];
                        bvc.userid = user.uid;
                        bvc.is_type = 3;
                        bvc.icon = user.icon;
                        bvc.nickname = user.nickname;
                        [self.navigationController pushViewController:bvc animated:YES];
                    }
                }];
            }];
        }
            break;
        default:
            break;
    }
}
-(void)close:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelLogin" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)more:(UIButton *)btn
{
    EnterViewController * enter = [[EnterViewController alloc]init];
    enter.loginId = _loginID;
    [self.navigationController pushViewController:enter animated:YES];
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
