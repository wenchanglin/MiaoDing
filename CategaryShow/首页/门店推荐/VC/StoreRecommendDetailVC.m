//
//  StoreDetailVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/13.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "StoreRecommendDetailVC.h"
#import "StoresDetailModel.h"
#import "StorePayVC.h"
#import "StoresPicCell.h"
#import <XHWebImageAutoSize.h>
@interface StoreRecommendDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * storeTableView;
@property(nonatomic,strong)NSMutableArray * sourceArr;
@property(nonatomic,strong)UIButton *buttonLike;
@property(nonatomic,strong)UIButton * buyBtn;
@property(nonatomic,strong)BaseDomain * postData;
@property(nonatomic,strong) NSDate *datBegin;
@property(nonatomic)NSInteger is_collect;
@property(nonatomic)NSInteger shop_id;

@end

@implementation StoreRecommendDetailVC
-(void)viewWillAppear:(BOOL)animated
{
    _datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _postData = [BaseDomain getInstance:NO];
    _sourceArr = [NSMutableArray array];
    if (@available(iOS 11.0, *)) {
        self.storeTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self requestData];
    
    //    [self createTableView];
    
    
}

-(void)createTableView
{
    
}

-(void)requestData
{
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@(_model.ID) forKey:@"shop_id"];
    [[wclNetTool sharedTools]request:GET urlString:URL_MenDianInfo parameters:parameter finished:^(id responseObject, NSError *error) {
        //        WCLLog(@"%@",responseObject);
        if (responseObject!=nil) {
            StoresDetailModel * model = [StoresDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (model.factory_img_arr.count>0) {
                _is_collect = model.is_collect;
                [_sourceArr addObject:model];
                [self createLowView];
                [self createCollectAndBuy];
                
            }
        }
        else
        {
            [self createLowView];
            
        }
        [self.storeTableView reloadData];
        
    }];
}

-(void)createCollectAndBuy
{
    
    _buttonLike = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-73: SCREEN_HEIGHT-49, SCREEN_WIDTH/3, 49)];
    _buttonLike.qi_eventInterval=3;
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
    
    _buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-73:SCREEN_HEIGHT-49, SCREEN_WIDTH/3*2, 49)];
    _buyBtn.qi_eventInterval=3;
    [_buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _buyBtn.backgroundColor = [UIColor colorWithHexString:@"#680000"];
    [_buyBtn setTitle:@"购买产品" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_buyBtn];
    
    
}
-(void)createLowView
{
    
    UIImageView * headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 156)];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    if (_sourceArr.count>0) {
        [headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL,((StoresDetailModel*)_sourceArr[0]).bgimg]]];
    }
    headerView.userInteractionEnabled = YES;
    [self.view addSubview:headerView];
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?HitoSafeAreaHeight:20, 45, 45)];
    
    [buttonBack.layer setCornerRadius:33 / 2];
    [buttonBack.layer setMasksToBounds:YES];
    [buttonBack setImage:[UIImage imageNamed:@"baiBack"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    [self.view bringSubviewToFront:buttonBack];
    
    UIButton *rightShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45,[ShiPeiIphoneXSRMax isIPhoneX]?HitoSafeAreaHeight:20, 45, 45)];
    [rightShare.layer setCornerRadius:33 / 2];
    [rightShare.layer setMasksToBounds:YES];
    [rightShare setImage:[UIImage imageNamed:@"shareRight"] forState:UIControlStateNormal];
    [rightShare addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    //    headerView
    UIImageView * tupian = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(buttonBack.frame)+5, 62, 62)];
    tupian.layer.shadowColor = [UIColor colorWithHexString:@"#414141"].CGColor; // 设置阴影颜色
    tupian.layer.shadowOpacity = 0.25; // 设置阴影不透明度
    tupian.layer.shadowOffset = CGSizeMake(0, 3); // 设置阴影位置偏差
    tupian.layer.shadowRadius = 5.0;
    tupian.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tupian];
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tupian.frame)+15, CGRectGetMaxY(buttonBack.frame)+5, SCREEN_WIDTH-104, 22)];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    nameLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    nameLabel.text = _model.name;
    [self.view addSubview:nameLabel];
    UILabel * fansLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tupian.frame)+15, CGRectGetMaxY(nameLabel.frame)+4, SCREEN_WIDTH-104, 17)];
    fansLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    fansLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    fansLabel.text = [NSString stringWithFormat:@"粉丝:%ld",_model.lovenum];
    [self.view addSubview:fansLabel];
    UILabel * addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tupian.frame)+15, CGRectGetMaxY(fansLabel.frame)+6, SCREEN_WIDTH-104, 17)];
    addressLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    addressLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    addressLabel.text = [NSString stringWithFormat:@"地址:%@",_model.address];
    [self.view addSubview:addressLabel];
    UIView * fengeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tupian.frame)+10, SCREEN_WIDTH, 5)];//CGRectGetMaxY(tupian.frame)+18
    fengeView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.view addSubview:fengeView];
    _storeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(fengeView.frame), SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-80-156-CGRectGetHeight(fengeView.frame):SCREEN_HEIGHT-156-42)style:UITableViewStylePlain];
    _storeTableView.delegate =self;
    _storeTableView.dataSource = self;
    _storeTableView.estimatedSectionFooterHeight=0;
    _storeTableView.estimatedRowHeight=0;
    _storeTableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:_storeTableView];
}

-(UIView *)headView
{
    UIView *View = [UIView new];
    View.frame = CGRectMake(0, 0, SCREEN_WIDTH, 156);
    View.backgroundColor = [UIColor clearColor];
    return View;
}
-(void)collect:(UIButton *)btn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"3" forKey:@"type"];
    [params setObject:@(_model.ID) forKey:@"rid"];
    [[wclNetTool sharedTools]request:POST urlString:URL_LoveSave parameters:params finished:^(id responseObject, NSError *error) {
        //                        WCLLog(@"%@",responseObject);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            if ([responseObject[@"status"]integerValue]==1) {
                [_buttonLike setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
                [self requestData];
            }
            else{
                [_buttonLike setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                [self requestData];
            }
        }
    }];
    
}
-(void)buyBtnClick:(UIButton *)button
{
    if (_sourceArr.count>0) {
        StorePayVC * pay = [[StorePayVC alloc]init];
        StoresDetailModel  * model = _sourceArr[0];
        pay.model = model;
        [self.navigationController pushViewController:pay animated:YES];
    }
    else
    {
        [self alertViewShowOfTime:@"当前店铺无商品，请去其他店铺看看" time:1.5];
    }
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
    if (_sourceArr.count != 0) {
        StoresDetailModel * model = _sourceArr[0];
        if (model.factory_img_arr.count>0) {
            return model.factory_img_arr.count;
        }
    }
    return 0;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoresDetailModel * model = _sourceArr[0];
    StoresPicCell * cell = [tableView dequeueReusableCellWithIdentifier:@"storeDesfklajf"];
    if (!cell) {
        cell = [[StoresPicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"storeDesfklajf"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // [cell setmodel:model WithIndex:indexPath];
    NSString * url = [NSString stringWithFormat:@"%@%@",PIC_HEADURL,model.factory_img_arr[indexPath.row]];
    [cell.picIMgView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [XHWebImageAutoSize storeImageSize:image forURL:imageURL completed:^(BOOL result) {
            /** reload  */
            if(result){
                 [tableView xh_reloadRowAtIndexPath:indexPath forURL:imageURL]; //[tableView  xh_reloadDataForURL:imageURL];
            }
        }];
    }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoresDetailModel * model = _sourceArr[0];
    NSString * url = [NSString stringWithFormat:@"%@%@",PIC_HEADURL,model.factory_img_arr[indexPath.row]];
    return [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width estimateHeight:200];
    //    return SCREEN_WIDTH/ [model.img_info[indexPath.row] floatValue];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
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
