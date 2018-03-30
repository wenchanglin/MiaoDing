//
//  StorePayVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/14.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "StorePayVC.h"
#import "payForView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
@interface StorePayVC ()<UITextFieldDelegate,payForViewDelegate>
@property(nonatomic,strong)UITextField * moneyTextField;
@property(nonatomic,strong)UILabel * moneyLabel;
@property(nonatomic,strong)UIButton * loginBtn;
@property(nonatomic,strong) BaseDomain *postData;

@property(nonatomic,strong)BaseDomain * postDomain;
@property(nonatomic,strong)BaseDomain * postpayDomain;
@property(nonatomic,strong)payForView * payView;
@end

@implementation StorePayVC
{
    UIImageView *imageAlpha;
    BOOL ZFB;
    NSString *orderId;
    NSString * price;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"男装定制"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSucess) name:@"PaySuccess" object:nil];
    ZFB = YES;
    _postData = [BaseDomain getInstance:NO];
    _postDomain = [BaseDomain getInstance:NO];
    _postpayDomain = [BaseDomain getInstance:NO];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    UIImageView * imgView = [UIImageView new];
    imgView.layer.cornerRadius =3;
    imgView.layer.masksToBounds = YES;
    imgView.layer.borderWidth = 1;
    imgView.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    imgView.image = [UIImage imageNamed:@"navi"];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(12+NavHeight);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(46);
    }];
    UILabel * leftLabel = [UILabel new];
    leftLabel.text = @"订单金额(元)";
    leftLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24+NavHeight);
        make.left.mas_equalTo(27);
        make.height.mas_equalTo(22);
    }];
    _moneyTextField = [UITextField new];
    _moneyTextField.placeholder = @"咨询店内人员输入";
    _moneyTextField.returnKeyType =UIReturnKeyDone;
    _moneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _moneyTextField.textAlignment = NSTextAlignmentRight;
    [_moneyTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _moneyTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _moneyTextField.delegate = self;
    [self.view addSubview:_moneyTextField];
    [_moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.right.mas_equalTo(-27);
        make.height.mas_equalTo(22);
    }];
    
    UIImageView * imgView2 = [UIImageView new];
    imgView2.image = [UIImage imageNamed:@"navi"];
    [self.view addSubview:imgView2];
    [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(12);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(46);
    }];
    UILabel * shiFuLabel = [UILabel new];
    shiFuLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    shiFuLabel.text = @"实付金额";
    [self.view addSubview:shiFuLabel];
    [shiFuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(24);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(22);
    }];
    _moneyLabel = [UILabel new];
    _moneyLabel.font = [UIFont systemFontOfSize:16];
    _moneyLabel.text = @"¥0.00";
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    _moneyLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
    [self.view addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shiFuLabel.mas_centerY);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(20);
    }];
    _loginBtn = [UIButton new];
    _loginBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
    [_loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _loginBtn.backgroundColor = [UIColor blackColor];
    [_loginBtn setTitle:@"已和店员确认，立即购买" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(dengluBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView2.mas_bottom).offset(60);
        make.left.mas_equalTo(42);
        make.right.mas_equalTo(-42);
        make.height.mas_equalTo(44);
    }];
    [self createPayView];

}
-(void)showSucess
{
    [self alertViewShowOfTime:@"支付成功" time:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)dengluBtn:(UIButton *)button
{
    [_moneyTextField resignFirstResponder];
    if (_moneyTextField.text.length>0) {
        NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
        [parameters setObject:@(_model.ID) forKey:@"shop_id"];
        [parameters setObject:_moneyTextField.text forKey:@"price"];
        [parameters setObject:_model.img forKey:@"goods_thumb"];
        [parameters setObject:_model.name forKey:@"goods_name"];
        [_postDomain postData:URL_StoreJoinShop PostParams:parameters finish:^(BaseDomain *domain, Boolean success) {
            if(domain.result ==1)
            {
                NSMutableDictionary * parame = [NSMutableDictionary dictionary];
                [parame setObject:@([[domain.dataRoot dictionaryForKey:@"data"]integerForKey:@"car_id"])  forKey:@"car_ids"];
                [parame setObject:@"2" forKey:@"quick_type"];
                [_postpayDomain postData:URL_StoreOrder PostParams:parame finish:^(BaseDomain *domain, Boolean success) {
                  //  WCLLog(@"%@",domain.dataRoot);
                    if (domain.result==1) {
                          orderId = [[domain.dataRoot objectForKey:@"data"]objectForKey:@"order_id"];
                    }
                  
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.5];
                    [_payView setAlpha:1];
                    [imageAlpha setAlpha:1];
                    [UIView commitAnimations];
                }];
            }
            else
            {
                [self alertViewShowOfTime:domain.resultMessage time:1.5];
            }
        }];
    }
   
}
-(void)createPayView
{
    imageAlpha = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageAlpha setImage:[UIImage imageNamed:@"BGALPHA"]];
    [imageAlpha setAlpha:0];
    [self.view addSubview:imageAlpha];
    
    _payView = [payForView new];
    _payView.priceLable.hidden = YES;
    _payView.hejiLabel.hidden =YES;
    [_payView setAlpha:0];
    [self.view addSubview:_payView];
    _payView.delegate = self;
    _payView.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .heightIs(526 / 2);
   
    
}

-(void)cancelClick
{
    _payView.alpha =0;
    imageAlpha.alpha =0;
}
-(void)payClick
{
    if (ZFB) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:orderId forKey:@"order_id"];
        [params setObject:@"1" forKey:@"pay_type"];
        NSString *appScheme = @"CloudFactory";
        [_postData postData:URL_APAY PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([domain.dataRoot integerForKey:@"code"] == 1) {
                NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
                [userd setObject:[domain.dataRoot stringForKey:@"pay_code"] forKey:@"payId"];
                [[AlipaySDK defaultService] payOrder:[domain.dataRoot stringForKey:@"data"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }
            
            
        }];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:orderId forKey:@"order_id"];
        [params setObject:@"2" forKey:@"pay_type"];
        [_postData postData:URL_WXPAY PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                
                NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
                [userd setObject:[domain.dataRoot stringForKey:@"pay_code"] forKey:@"payId"];
                NSDictionary *dic = [domain.dataRoot objectForKey:@"data"];
                PayReq *request = [[PayReq alloc] init] ;
                request.partnerId = [dic stringForKey:@"partnerid"];
                request.prepayId= [dic stringForKey:@"prepayid"];
                request.package = @"Sign=WXPay";
                request.nonceStr= [dic stringForKey:@"noncestr"];
                request.timeStamp= [[dic objectForKey:@"timestamp"] intValue];
                request.sign= [dic stringForKey:@"sign"];
                [WXApi sendReq:request];
            }
        }];
    }
}
-(void)clickItem:(NSInteger)item
{
    switch (item) {
        case 0:
            ZFB = YES;
            break;
        case 1:
            ZFB = NO;
            break;
        default:
            break;
    }
}
-(void)textFieldChanged:(UITextField*)textfield
{
    if (textfield.text.length ==0) {
        _moneyLabel.text = @"¥0.00";
    }
    else
    {
    price = [NSString stringWithFormat:@"¥%@",textfield.text];
    _moneyLabel.text = price;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
