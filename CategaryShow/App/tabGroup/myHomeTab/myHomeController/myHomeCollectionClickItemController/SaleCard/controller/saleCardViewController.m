//
//  saleCardViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/20.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "saleCardViewController.h"
#import "alertViewViewController.h"
@interface saleCardViewController ()<alertChooseDelegate>

@end

@implementation saleCardViewController
{
    UILabel *moneyLabel;
    BaseDomain *getData;
    BaseDomain *postData;
    NSMutableDictionary *giftDic;
    UIImageView *nocard;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼品卡";
    getData  = [BaseDomain getInstance:NO];
    postData  = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createView];
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)getData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_GetPoperLastMoney PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            giftDic = [NSMutableDictionary dictionaryWithDictionary:[domain.dataRoot dictionaryForKey:@"info"]];
            [self reloadView];
        }
    }];
}

-(void)reloadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_GetPoperLastMoney PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            giftDic = [NSMutableDictionary dictionaryWithDictionary:[domain.dataRoot dictionaryForKey:@"info"]];
            if (_ifPayContrller) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cardSuccess" object:nil userInfo:giftDic];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self reloadView];
        }
    }];
}

-(void)reloadView
{
    [moneyLabel setText:[NSString stringWithFormat:@"%.2f",[[giftDic stringForKey:@"gift_card"] floatValue]]];
    
    if ([[giftDic stringForKey:@"gift_card"] integerValue] > 0) {
        [nocard setHidden:YES];
        UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 165.0 /  667.0 * SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT  - (49.0 / 667.0 * SCREEN_HEIGHT + 64 + 165.0 /  667.0 * SCREEN_HEIGHT))];
        [self.view addSubview:scroller];
        UIImageView *imageDetailDes = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        [imageDetailDes sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [giftDic stringForKey:@"card_rule"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGFloat scan =imageDetailDes.image.size.width / imageDetailDes.image.size.height;
            scroller.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH / scan);
            [imageDetailDes setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / scan)];
            [scroller addSubview:imageDetailDes];
        }];
    } else {
        [nocard setHidden:NO];
    }
}



-(void)createView
{
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 165.0 /  667.0 * SCREEN_HEIGHT)];
    [self.view addSubview:headImage];
    [headImage setImage:[UIImage imageNamed:@"saleCardHead"]];
    moneyLabel = [UILabel new];
    [headImage addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headImage.mas_centerX);
        make.top.equalTo(headImage.mas_top).with.offset(40);
        make.height.equalTo(@60);
    }];
    [moneyLabel setFont:[UIFont systemFontOfSize:54]];
    [moneyLabel setTextAlignment:NSTextAlignmentCenter];
    [moneyLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *moneyTitle = [UILabel new];
    [headImage addSubview:moneyTitle];
    [moneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(moneyLabel.mas_bottom).with.offset(-5);
        make.right.equalTo(moneyLabel.mas_left);
        make.height.equalTo(@30);
    }];
    [moneyTitle setText:@"¥"];
    [moneyTitle setFont:[UIFont systemFontOfSize:27]];
    [moneyTitle setTextAlignment:NSTextAlignmentCenter];
    [moneyTitle setTextColor:[UIColor whiteColor]];
    
    
    UILabel *lastTitle = [UILabel new];
    [headImage addSubview:lastTitle];
    lastTitle.sd_layout
    .topSpaceToView(moneyLabel, 5)
    .centerXEqualToView(headImage)
    .heightIs(20)
    .widthIs(SCREEN_WIDTH - 20);
    [lastTitle setTextAlignment:NSTextAlignmentCenter];
    [lastTitle setTextColor:[UIColor whiteColor]];
    [lastTitle setFont:[UIFont systemFontOfSize:14]];
    [lastTitle setText:@"（账户余额）"];
    
    
    nocard = [UIImageView new];
    [self.view addSubview:nocard];
    nocard.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(headImage, 106.0 / 375.0 * SCREEN_WIDTH)
    .heightIs(115)
    .widthIs(130);
    [nocard setImage:[UIImage imageNamed:@"haveNoCard"]];
    
    UIButton *addCard = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - 49.0 / 667.0 * SCREEN_HEIGHT, SCREEN_WIDTH, 49.0 / 667.0 * SCREEN_HEIGHT)];
    [addCard setImage:[UIImage imageNamed:@"addCard"] forState:UIControlStateNormal];
    [addCard addTarget:self action:@selector(clickAddAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addCard];
    
}

-(void)clickAddAction
{
    alertViewViewController *successVi = [[alertViewViewController alloc] init];
    successVi.delegate = self;
    successVi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    successVi.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:successVi animated:YES completion:nil];
}

-(void)doneClickActin:(NSString *)code
{
    if (code.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:code forKey:@"exchange_code"];
        [postData postData:URL_GetPoper PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                [self alertViewShowOfTime:@"兑换成功" time:1.0];
                [self reloadData];
                
            }
        }];
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
