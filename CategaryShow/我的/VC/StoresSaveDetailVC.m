//
//  StoresSaveDetailVc.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/16.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "StoresSaveDetailVC.h"
#import "StoresDetailModel.h"
#import "StorePayVC.h"
@interface StoresSaveDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * storeTableView;
@property(nonatomic,strong)NSMutableArray * sourceArr;
@property(nonatomic,strong)UIButton *buttonLike;
@property(nonatomic,strong)UIButton * buyBtn;
@property(nonatomic,strong)BaseDomain * postData;
@property(nonatomic,strong) NSDate *datBegin;
@property(nonatomic)NSInteger is_collect;
@property(nonatomic)NSInteger shop_id;
@end

@implementation StoresSaveDetailVC
-(void)viewWillAppear:(BOOL)animated
{
    _datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _postData = [BaseDomain getInstance:NO];
    _sourceArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    [self createLowView];
}
-(void)requestData
{
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@(_model.ID) forKey:@"shop_id"];
    [[wclNetTool sharedTools]request:GET urlString:URL_MenDianInfo parameters:parameter finished:^(id responseObject, NSError *error) {
//        WCLLog  (@"%@",responseObject[@"data"]);
        StoresDetailModel * model = [StoresDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        _is_collect = model.is_collect;
        [_sourceArr addObject:model];
        [self createCollectAndBuy];
    }];
}
-(void)createCollectAndBuy
{
    if (!_buttonLike) {
        _buttonLike = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH/3, 49)];
        [_buttonLike addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
        _buttonLike.backgroundColor = [UIColor blackColor];
        _buttonLike.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_buttonLike setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _buttonLike.titleLabel.font = [UIFont systemFontOfSize:13];
        if(_is_collect == 1){
            [_buttonLike setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
        }
        else
        {
            [_buttonLike setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        }
        [_buttonLike setTitle:@"关注店铺" forState:UIControlStateNormal];
        [self.view addSubview:_buttonLike];
    }
    if (!_buyBtn) {
        _buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT-49, SCREEN_WIDTH/3*2, 49)];
        [_buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.backgroundColor = [UIColor colorWithHexString:@"#680000"];
        [_buyBtn setTitle:@"购买产品" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:_buyBtn];
    }
    
}
-(void)createLowView
{
    
    self.storeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        self.storeTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _storeTableView.delegate =self;
    _storeTableView.dataSource = self;
    [self.view addSubview:_storeTableView];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 156)];
    headerView.backgroundColor = [UIColor grayColor];
    _storeTableView.tableHeaderView = headerView;
    UIImageView * tupian = [[UIImageView alloc]initWithFrame:CGRectMake(15, 71, 62, 62)];
    tupian.layer.shadowColor = [UIColor colorWithHexString:@"#414141"].CGColor; // 设置阴影颜色
    tupian.layer.shadowOpacity = 0.25; // 设置阴影不透明度
    tupian.layer.shadowOffset = CGSizeMake(0, 3); // 设置阴影位置偏差
    tupian.layer.shadowRadius = 5.0;
    tupian.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:tupian];
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tupian.frame)+15, 71, SCREEN_WIDTH-104, 22)];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    nameLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    nameLabel.text = _model.factory_name;
    [headerView addSubview:nameLabel];
    UILabel * fansLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tupian.frame)+15, CGRectGetMaxY(nameLabel.frame)+4, SCREEN_WIDTH-104, 17)];
    fansLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    fansLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    fansLabel.text = [NSString stringWithFormat:@"%ld",_model.lovenum];
    [headerView addSubview:fansLabel];
    UILabel * addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tupian.frame)+15, CGRectGetMaxY(fansLabel.frame)+6, SCREEN_WIDTH-104, 17)];
    addressLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    addressLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    addressLabel.text = [NSString stringWithFormat:@"地址:%@",_model.address];
    [headerView addSubview:addressLabel];
    UIView * fengeView = [[UIView alloc]initWithFrame:CGRectMake(0, 151, SCREEN_WIDTH, 5)];//CGRectGetMaxY(tupian.frame)+18
    fengeView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [headerView addSubview:fengeView];
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 45, 45)];
    
    [buttonBack.layer setCornerRadius:33 / 2];
    [buttonBack.layer setMasksToBounds:YES];
    [buttonBack setImage:[UIImage imageNamed:@"baiBack"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    [self.view bringSubviewToFront:buttonBack];
    
    UIButton *rightShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, 20, 45, 45)];
    [rightShare.layer setCornerRadius:33 / 2];
    [rightShare.layer setMasksToBounds:YES];
    [rightShare setImage:[UIImage imageNamed:@"shareRight"] forState:UIControlStateNormal];
    [rightShare addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    // [self.view addSubview:rightShare];
    //[self.view bringSubviewToFront:rightShare];
    
}
-(void)collect:(UIButton *)btn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"3" forKey:@"type"];
    [params setObject:@(_model.ID) forKey:@"rid"];
    [[wclNetTool sharedTools]request:POST urlString:URL_CollectSave parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            if ([responseObject[@"status"]integerValue]==1) {
                [_buttonLike setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
                [self requestData];

            }
            else
            {
                [_buttonLike setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                [self requestData];
            }
        }
    }];

}
-(void)buyBtnClick:(UIButton *)button
{
    StorePayVC * pay = [[StorePayVC alloc]init];
    StoresDetailModel  * model = _sourceArr[0];
    pay.model = model;
    [self.navigationController pushViewController:pay animated:YES];
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)shareClick:(UIButton *)sender
{
    
    //    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    //    NSString *string = [[[dataDictionary arrayForKey:@"price"] valueForKey:@"price"] componentsJoinedByString:@","];
    //    //1、创建分享参数（必要）
    //    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_goodDic stringForKey:@"thumb"]]]];
    //    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    //    [shareParams SSDKSetupShareParamsByText:[dataDictionary stringForKey:@"content"]
    //                                     images:imageArray
    //                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?goods_id=%@&shop_id=%@&market_id=%@&type=2",URL_HEADURL, URL_SHARE, [_goodDic stringForKey:@"id"],_shopId,_marketId]]
    //                                      title:[dataDictionary stringForKey:@"name"]
    //                                       type:SSDKContentTypeWebPage];
    //
    //    [ShareCustom shareWithContent:shareParams];
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;//_sourceArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ceell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ceell"];
    }
    cell.textLabel.text = @"1";
    cell.backgroundColor = [UIColor magentaColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 375;
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
