//
//  NewDiyPersonalityVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/4/3.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "NewDiyPersonalityVC.h"
#import "ChooseClothesResultViewController.h"
#import "positionTableViewCell.h"
#import "colorChooseTableViewCell.h"
#import "fontTableViewCell.h"
#import "textFieldWordDiyTableViewCell.h"
#import "ChooseClothesStyleViewController.h"
#import "ChooseStyleNewViewController.h"
#import "BanXingTableViewCell.h"
#import "DiyHeadCell.h"
#import "MianLiaoCell.h"
#import "ClothesFroPay.h"
#import "PayForClothesViewController.h"
#import "HeightAndWeightCell.h"
#import "PaiZhaoTestCell.h"
#import "QuickPhotoYinDaoVC.h"
#import "QuickPhotoVC.h"
#import "LiangTiModel.h"
#import "HttpRequestTool.h"
#import "newDiyAllDataModel.h"
#import "newDiyMianLiaoModel.h"
#import "SingleNavigationController.h"
@interface NewDiyPersonalityVC ()<UITableViewDelegate, UITableViewDataSource, positionDelegate, colorDelegate, fontDelegate,UITextFieldDelegate,banXingDelegate,mianLiaoDelegate>
@property (nonatomic, retain) NSMutableDictionary *paramsClothes;
@property(nonatomic,assign)BOOL isHaveDian;

@property(nonatomic,assign)BOOL isFirstZero;

@end

@implementation NewDiyPersonalityVC
{
    BaseDomain *postData;
    UITableView *diyTable;
    NSMutableArray * twodiyArr;
    NSMutableArray *dataArr;
    NSMutableArray*banxingArr;
    NSMutableArray*mianliaoArr;
    NSMutableArray*positionArr;
    NSMutableArray*colorArr;
    NSMutableArray*fontArr;
    NSMutableArray *diyArray;
    NSMutableDictionary *dic;//创建一个字典进行判断收缩还是展开
    NSInteger banxingtag;
    NSInteger mianliaotag;
    NSInteger positiontag;
    NSInteger colortag;
    NSInteger fonttag;
    NSMutableArray *diydetailArray;
    CGFloat initViewY;
    Boolean isViewYFisrt;
    NSInteger isopencv;
    NSString * heightStr;
    NSString * weightStr;
    NSString * nameStr;
    NSMutableDictionary *textFildString;
    NSMutableDictionary * heightAndWeightDic;
    BOOL is_english;
    NSMutableArray *YDImgArray;
    UIImageView *imag;
    UIView *titleView;
    UIView *lineView;
    UIButton *seleBtn;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.rdv_tabBarController.tabBarHidden=YES;
    [MobClick beginLogPageView:@"新个性定制"];
    
}
-(void)clickAction:(UIButton *)sender
{
    [seleBtn setSelected:NO];
    seleBtn = sender;
    [seleBtn setSelected:YES];
    [UIView commitAnimations];
    if (sender.tag ==81) {
        [self moreDiy:sender];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick endLogPageView:@"新个性定制"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postData = [BaseDomain getInstance:NO];
    is_english = YES;
    banxingArr = [NSMutableArray array];
    mianliaoArr = [NSMutableArray array];
    positionArr=[NSMutableArray array];
    colorArr= [NSMutableArray array];
    fontArr=[NSMutableArray array];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = YES;
    dic = [NSMutableDictionary dictionary];
    heightAndWeightDic = [NSMutableDictionary dictionary];
    dataArr = [NSMutableArray array];
    _paramsClothes = [NSMutableDictionary dictionary];
    diyArray = [NSMutableArray array];
    twodiyArr = [NSMutableArray array];
    YDImgArray = [NSMutableArray array];
    isViewYFisrt = YES;
    banxingtag = 0;
    mianliaotag = 0;
    colortag =0;
    positiontag =0;
    fonttag =0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(request:) name:@"quickuploadsucess" object:nil];
    _banxing = [NSDictionary dictionary];
    textFildString = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (!titleView) {
        NSArray* array = @[@"快速定制",@"个性定制"];
        titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,iPadDevice?SCREEN_WIDTH/2:80 * array.count, 40)];
        lineView = [[UIView alloc] initWithFrame:CGRectMake(1, 31, 60, 2)];
        [titleView addSubview:lineView];
        [lineView setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(iPadDevice?-15:-15,5, 80, 30)];
        [titleView addSubview:button];
        [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:14]];
        [button setTitle:array[0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateNormal)];
        button.tag =  80;
        seleBtn = button;
        [seleBtn setSelected:YES];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        lineView.centerX = seleBtn.centerX;
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(iPadDevice?SCREEN_WIDTH/3:100,5, 80, 30)];
        [titleView addSubview:button2];
        [button2.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:14]];
        [button2 setTitle:array[1] forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateNormal)];
        button2.tag =  81;
        [button2 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    self.navigationItem.titleView = titleView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeClothes:) name:@"change" object:nil];
    [self getDatas];
}

-(void)request:(NSNotification*)notification
{
    isopencv = [[notification.userInfo stringForKey:@"isopencv"] integerValue];
    [diyTable reloadData];
}
-(void)getMoreYinDao
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(8) forKey:@"id"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_GetYinDaoForID_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            YDImgArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"data"] arrayForKey:@"img_urls"]];
            [self createNewUser];
        }}];
}
-(void)moreDiy:(UIButton *)button
{

                    ChooseClothesStyleViewController *chooseStyleCon = [[ChooseClothesStyleViewController alloc] init];
//                    chooseStyleCon.banxing = _banxing;
//                    chooseStyleCon.price_Type = [_price stringForKey:@"id"];
                    chooseStyleCon.price = _price;
                    chooseStyleCon.class_id = [NSString stringWithFormat:@"%@",@([_paramsClothes integerForKey:@"class_id"])];
                    chooseStyleCon.paramsClothes = _paramsClothes;
//                    chooseStyleCon.xiuZiDic = _xiuZiDic;
//                    chooseStyleCon.mianliaoprice = [_price objectForKey:@"price"];
//                    chooseStyleCon.goodDic = _goodDic;
//                    chooseStyleCon.dataDic = dataDic;
//                    chooseStyleCon.banxingtag =banxingtag;
                    chooseStyleCon.diyArray =diyArray;
//                    chooseStyleCon.dateId =_dateId;
//                    chooseStyleCon.dingDate = _dingDate;
                    [self.navigationController pushViewController:chooseStyleCon animated:YES];

}
-(void)changeClothes:(NSNotification *)noti
{
    _goodArray = [noti.userInfo objectForKey:@"clothes"];
    if ([[_xiuZiDic allValues] count] > 0) {
        _xiuZiDic = [NSMutableDictionary dictionaryWithDictionary:[noti.userInfo objectForKey:@"xiuzi"]];
    } else {
        _xiuZiDic = nil;
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(_diyDetailModel.ID) forKey:@"goods_id"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_DingZhiDetailAndPeiJian_String] parameters:params finished:^(id responseObject, NSError *error) {
//        WCLLog(@"%@",responseObject);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            newDiyAllDataModel*model = [newDiyAllDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            [dataArr addObject:model];
            diyArray = model.must_display_part.mutableCopy;
            mianliaoArr = model.fabric.mutableCopy;
            _price = @{@"price":model.sell_price};
            newDiyMianLiaoModel*model5 = [mianliaoArr firstObject];
            [_paramsClothes setObject:@(model.if_liz) forKey:@"class_id"];
            [_paramsClothes setObject:@(model5.ID) forKey:@"mianliao"];
            [_paramsClothes setObject:model5.name forKey:@"mianliao2"];
            [_paramsClothes setObject:@(model.ID) forKey:@"goods_id"];
            for (secondDataModel*model2 in model.special_mark_part) {
                if (model2.special_mark==1) { //1版型2绣花位置3绣花字体4绣花颜色
                    [banxingArr addObjectsFromArray:model2.son];
                    [_paramsClothes setObject:model2.son[0] forKey:@"banxing"];
                }
                else if(model2.special_mark==2)
                {
                    [positionArr addObjectsFromArray:model2.son];
                    [_paramsClothes setObject:model2.son[0] forKey:@"position"];
                }
                else if (model2.special_mark==4)
                {
                    [colorArr addObjectsFromArray:model2.son];
                    [_paramsClothes setObject:model2.son[0] forKey:@"color"];
                }
                else//3
                {
                    [fontArr addObjectsFromArray:model2.son];
                    [_paramsClothes setObject:model2.son[0] forKey:@"font"];
                }
            }
            [self createDiyView];
        }
    }];
}
-(void)createNewUser
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 这里判断是否第一次
        imag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [imag addGestureRecognizer:tap];
        [imag setUserInteractionEnabled:YES];
        UIWindow *win = self.view.window;
        [imag sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, YDImgArray[0]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                CGFloat scan = image.size.width / image.size.height;
                imag.frame = CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?20:0, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?150+SCREEN_WIDTH/scan: SCREEN_WIDTH/scan);
            }
            else
            {
                [imag setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH )];
            }
        }];
        [win addSubview:imag];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
}
-(void)tap
{
    [imag removeFromSuperview];
    imag = nil;
}
-(void)createDiyView
{
    if (@available(iOS 11.0, *)) {
        diyTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    diyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-95: SCREEN_HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
    diyTable.dataSource = self;
    diyTable.delegate = self;
    [diyTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [diyTable registerClass:[BanXingTableViewCell class] forCellReuseIdentifier:@"banxing"];
    [diyTable registerClass:[MianLiaoCell class] forCellReuseIdentifier:@"mianliao"];
    [diyTable registerClass:[PaiZhaoTestCell class] forCellReuseIdentifier:@"paizhaotest"];
    [diyTable registerClass:[HeightAndWeightCell class] forCellReuseIdentifier:@"heightandweight"];
    [diyTable registerClass:[positionTableViewCell class] forCellReuseIdentifier:@"position"];
    [diyTable registerClass:[colorChooseTableViewCell class] forCellReuseIdentifier:@"color"];
    [diyTable registerClass:[fontTableViewCell class] forCellReuseIdentifier:@"font"];
    [diyTable registerClass:[DiyHeadCell class] forCellReuseIdentifier:@"diyHead"];
    [diyTable registerClass:[textFieldWordDiyTableViewCell class] forCellReuseIdentifier:@"textField"];
    [self.view addSubview:diyTable];
    
    
    
    //    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-64-40, SCREEN_WIDTH , 40)];
    //    [button2 setBackgroundColor:getUIColor(Color_buyColor)];
    //    [button2 addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    //    [button2.layer setCornerRadius:1];
    //    button2.tag = 5000;
    //    [button2.layer setMasksToBounds:YES];
    //    [button2 setTitle:@"预览" forState:UIControlStateNormal];
    //    [self.view addSubview:button2];
    //    UIView *priceLowView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -64- 50, SCREEN_WIDTH / 3, 50)];
    //    priceLowView.tag = 5000;
    //    [priceLowView setBackgroundColor:[UIColor whiteColor]];
    //    [self.view addSubview:priceLowView];
    
    
    UILabel *priceDetail = [[UILabel alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-95:SCREEN_HEIGHT -64- 50, SCREEN_WIDTH / 3-10, 50)];
    priceDetail.tag = 6000;
    priceDetail.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:priceDetail];
    newDiyAllDataModel*model2 = [dataArr firstObject];
    [priceDetail setText:[NSString stringWithFormat:@"合计:¥%@",model2.sell_price]];
    priceDetail.textColor= [UIColor colorWithHexString:@"#222222"];
    [priceDetail setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:16]];
    
    UIButton *buttonSave = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-95: SCREEN_HEIGHT -64- 50, SCREEN_WIDTH / 3 , 50)];
    [buttonSave setBackgroundColor:getUIColor(Color_DZClolor)];
    [self.view addSubview:buttonSave];
    [buttonSave addTarget:self action:@selector(saveTheClothes) forControlEvents:UIControlEventTouchUpInside];
    [buttonSave.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonSave setTitle:@"加入购物袋" forState:UIControlStateNormal];
    buttonSave.qi_eventInterval=3;
    
    UIButton *buttonBuy = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-95: SCREEN_HEIGHT -64- 50, SCREEN_WIDTH / 3 , 50)];
    [buttonBuy setBackgroundColor:getUIColor(Color_TKClolor)];
    buttonBuy.qi_eventInterval=3;
    [self.view addSubview:buttonBuy];
    [buttonBuy addTarget:self action:@selector(payForClothes) forControlEvents:UIControlEventTouchUpInside];
    [buttonBuy.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonBuy setTitle:@"立即购买" forState:UIControlStateNormal];
}
-(void)payForClothes
{
    NSMutableString*string = [[NSMutableString alloc]init];
    threeDataModel*banxingmodel = [_paramsClothes objectForKey:@"banxing"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(banxingmodel.part_id)]];
    threeDataModel*positionmodel = [_paramsClothes objectForKey:@"position"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(positionmodel.part_id)]];
    threeDataModel*colormodel = [_paramsClothes objectForKey:@"color"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(colormodel.part_id)]];
    threeDataModel*fontmodel = [_paramsClothes objectForKey:@"font"];
    [string appendString:[NSString stringWithFormat:@"%@",@(fontmodel.part_id)]];
    NSMutableDictionary*parrment = [NSMutableDictionary dictionary];
    [parrment setObject:string forKey:@"special_mark_part_ids"];
    [parrment setObject:@"1" forKey:@"goods_num"];
    [parrment setObject:@(ShoppingCarTypeBuy) forKey:@"type"];
    [parrment setObject:[_paramsClothes stringForKey:@"goods_id"] forKey:@"goods_id"];
    [parrment setObject:[_paramsClothes stringForKey:@"mianliao"] forKey:@"fabric_id"];
    [parrment setObject:[[_paramsClothes dictionaryForKey:@"re_marks"]stringForKey:@"name"] forKey:@"re_marks"];
    newDiyAllDataModel*models = [dataArr firstObject];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_AddShoppingCar_String] parameters:parrment finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
             [MobClick event:@"place_order" label:[NSString stringWithFormat:@"%@--%@",[SelfPersonInfo shareInstance].userModel.username,models.name]];//cart_id
            PayForClothesViewController *clothesPay = [[PayForClothesViewController alloc] init];
            clothesPay.carId = [responseObject stringForKey:@"cart_id"];
            clothesPay.allPrice = models.sell_price;
            [self.navigationController pushViewController:clothesPay animated:YES];
        }
    }];
}
-(void)saveTheClothes
{
    NSMutableString*string = [[NSMutableString alloc]init];
    threeDataModel*banxingmodel = [_paramsClothes objectForKey:@"banxing"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(banxingmodel.part_id)]];
    threeDataModel*positionmodel = [_paramsClothes objectForKey:@"position"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(positionmodel.part_id)]];
    threeDataModel*colormodel = [_paramsClothes objectForKey:@"color"];
    [string appendString:[NSString stringWithFormat:@"%@,",@(colormodel.part_id)]];
    threeDataModel*fontmodel = [_paramsClothes objectForKey:@"font"];
    [string appendString:[NSString stringWithFormat:@"%@",@(fontmodel.part_id)]];
    NSMutableDictionary*parrment = [NSMutableDictionary dictionary];
    [parrment setObject:string forKey:@"special_mark_part_ids"];
    [parrment setObject:@"1" forKey:@"goods_num"];
    [parrment setObject:@(ShoppingCarTypeAdd) forKey:@"type"];
    [parrment setObject:[_paramsClothes stringForKey:@"goods_id"] forKey:@"goods_id"];
    [parrment setObject:[_paramsClothes stringForKey:@"mianliao"] forKey:@"fabric_id"];
    [parrment setObject:[[_paramsClothes dictionaryForKey:@"re_marks"]stringForKey:@"name"] forKey:@"re_marks"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_AddShoppingCar_String] parameters:parrment finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
        [MobClick event:@"add_cart" label:[NSString stringWithFormat:@"%@--%@",[SelfPersonInfo shareInstance].userModel.username,[_goodDic stringForKey:@"name"]]];
        [self alertViewShowOfTime:@"添加购物车成功" time:1.5];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addCarSuccess" object:nil];
    }
    }];
}

-(void)changeStep
{
    //    ChooseStyleNewViewController *chooseStyle = [[ChooseStyleNewViewController alloc] init];
    //    chooseStyle.price_Type = _price_type;
    //    chooseStyle.price = _price;
    //    chooseStyle.class_id = _class_id;
    //    chooseStyle.goodDic = _goodDic;
    //    [self.navigationController pushViewController:chooseStyle animated:YES];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
    [titleSection setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_tap:)];
    titleSection.tag = 300 + section;
    [titleSection addGestureRecognizer:tap];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 160, 42)];
    //    titleLabel.backgroundColor = [UIColor blueColor];
    [titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:13]];
    titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    UILabel * rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-200-12, 0, 200, 42)];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = [UIColor colorWithHexString:@"#A6A6A6"];
    rightLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:13];
    [titleSection addSubview:rightLabel];
    [titleSection addSubview:titleLabel];
    UIButton * jiantouBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-27, 17, 14, 10)];
    if (section==0) {
        titleLabel.hidden=YES;
        rightLabel.hidden=YES;
        titleSection.hidden=YES;
    }
    else if (section == 1) {
        [titleLabel setText:@"选择版型"];
        rightLabel.tag = 2222;
        threeDataModel*model1 = banxingArr[0];
        rightLabel.text = model1.part_name;
    } else if (section == 2) {
        [titleLabel setText:@"选择面料(长按可看大图)"];
        rightLabel.tag =2223;
        newDiyMianLiaoModel*model2 = mianliaoArr[0];
        rightLabel.text =model2.name;
    }
    else//3
    {
        titleLabel.text = @"选择刺绣";
        [titleSection addSubview:jiantouBtn];
        
    }
    if([dic[@"3"] integerValue]==1)
    {
        [jiantouBtn setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
    }
    else
    {
        [jiantouBtn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
        
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH, 1)];
    [titleSection addSubview:lineView];
    [lineView setBackgroundColor:getUIColor(Color_saveColor)];
    return titleSection;
}
- (void)action_tap:(UIGestureRecognizer *)tap{
    if (tap.view.tag ==303) {
        NSString *str = [NSString stringWithFormat:@"%ld",tap.view.tag-300];
        if ([dic[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
            [dic setObject:@"1" forKey:str];
        }else{//反之关闭cell
            [dic setObject:@"0" forKey:str];
        }
        [diyTable reloadData];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    return 43;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==3) {
        NSString *string = [NSString stringWithFormat:@"%ld",section];
        if ([dic[string] integerValue] == 1 ) {  //打开cell返回数组的count
            return 8;
        }else{
            return 0;
        }
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        return 109;
//    }
     if (indexPath.section==0)
    {
        return 0.01;
    }
    else if (indexPath.section==1)
    {
        return 3+(SCREEN_WIDTH-60)/4;
    }
    else if(indexPath.section==3)
    {
        if (indexPath.row==0||indexPath.row==2||indexPath.row==4||indexPath.row==6) {
            return 38;
        }
        else
        {
            return  35+(SCREEN_WIDTH-60)/4;
        }
    }
    return 35+(SCREEN_WIDTH-60)/4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    if (indexPath.section==0) {
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cess"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cess"];
        }
        cell.imageView.backgroundColor= [UIColor magentaColor];
        reCell=cell;
    }
    else if (indexPath.section == 1) {
        BanXingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"banxing" forIndexPath:indexPath];
        cell.banXingArray = banxingArr;
        cell.delegate = self;
        reCell =cell;
        
    }
    else if (indexPath.section == 2)
    {
        MianLiaoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mianliao" forIndexPath:indexPath];
        cell.mianLiaoArray = mianliaoArr;
        cell.delegate = self;
        reCell = cell;
    }
    else //3组
    {
        if (indexPath.row==0) {
            DiyHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"diyHead" forIndexPath:indexPath];
            cell.leftLabel.text = @"选择刺绣位置";
            cell.tag = 1000;
            cell.firstView.hidden= YES;
            threeDataModel*model0 = positionArr[positiontag];
            cell.rightLabel.text = model0.part_name;
            reCell = cell;
        }
        else if (indexPath.row==1) {
            positionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"position" forIndexPath:indexPath];
            cell.positionArray = positionArr;
            cell.delegate = self;
            reCell = cell;
        }
        else if(indexPath.row==2)
        {
            DiyHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"diyHead" forIndexPath:indexPath];
            cell.tag =1002;
            cell.leftLabel.text = @"选择字体颜色";
            threeDataModel*model2 = colorArr[colortag];
            cell.rightLabel.text =model2.part_name;
            reCell = cell;
        }
        else if (indexPath.row==3)
        {
            colorChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"color" forIndexPath:indexPath];
            cell.colorArray = colorArr;
            cell.delegate = self;
            reCell = cell;
        }
        else if (indexPath.row==4)
        {
            DiyHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"diyHead" forIndexPath:indexPath];
            threeDataModel*model4 = fontArr[fonttag];
            cell.leftLabel.text = @"选择字体";
            cell.tag = 1004;
            cell.rightLabel.text = model4.part_name;
            cell.endView.hidden =NO;
            reCell = cell;
        }
        else if (indexPath.row==5)
        {
            fontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"font" forIndexPath:indexPath];
            cell.delegate = self;
            cell.fontArray = fontArr;
            reCell = cell;
        }
        else if (indexPath.row==6)
        {
            DiyHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"diyHead" forIndexPath:indexPath];
            cell.leftLabel.text = @"选择绣花内容";
            cell.tag =1006;
            cell.rightLabel.text = @"";//[[[dataDic arrayForKey:@"position"] objectAtIndex:0] stringForKey:@"name"];
            cell.endView.hidden =YES;
            reCell = cell;
        }
        else if (indexPath.row==7)
        {
            textFieldWordDiyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textField" forIndexPath:indexPath];
            cell.wordDiy .delegate = self;
            [cell.wordDiy addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [cell.wordDiy addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEnd];
            cell.isenglish = is_english;
            reCell = cell;
        }
    }
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}


-(void)textfieldDidChange:(UITextField *)textfield
{
    if (textfield.tag==993) {
        [_paramsClothes removeObjectForKey:@"re_marks"];
        if (textfield.text.length>0) {
            [textFildString setObject:@"文字" forKey:@"a_name"];
            [textFildString setObject:textfield.text forKey:@"name"];
            [_paramsClothes setObject:textFildString forKey:@"re_marks"];
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length>0) {
      if (textField.tag==993) {
          [_paramsClothes removeObjectForKey:@"re_marks"];
            if (textField.text.length>0) {
                [textFildString setObject:@"文字" forKey:@"a_name"];
                [textFildString setObject:textField.text forKey:@"name"];
                [_paramsClothes setObject:textFildString forKey:@"re_marks"];
            }
        }
    }
    
    [textField resignFirstResponder];
    return YES;
}
-(void)showMyMessage:(NSString*)aInfo {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:aInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(void)banXingClick:(NSInteger)index
{
    threeDataModel*model1= banxingArr[index];
    [_paramsClothes setObject:model1 forKey:@"banxing"];
    UILabel *Label = [self.view viewWithTag:2222];
    Label.text = model1.part_name;
    banxingtag = index;
}
-(void)mianLiaoClick:(NSInteger)index
{
    newDiyMianLiaoModel*model1= mianliaoArr[index];
    [_paramsClothes setObject:@(model1.ID) forKey:@"mianliao"];
    [_paramsClothes setObject:model1.name forKey:@"mianliao2"];
    UILabel *Label = [self.view viewWithTag:2223];
    Label.text = model1.name;
    mianliaotag = index;
}
-(void)positionClick:(NSInteger)index
{
    threeDataModel*model3 = positionArr[index];
    [_paramsClothes setObject:model3 forKey:@"position"];
    positiontag = index;
    DiyHeadCell * positionCell = [self.view viewWithTag:1000];
    positionCell.rightLabel.text = model3.part_name;
}

-(void)colorClick:(NSInteger)index
{
    threeDataModel*model3 = colorArr[index];
    [_paramsClothes setObject:model3 forKey:@"color"];
    colortag = index;
    DiyHeadCell * colorCell = [self.view viewWithTag:1002];
    colorCell.rightLabel.text = model3.part_name;
}

-(void)fontChoose:(NSInteger)index
{
    threeDataModel*model3 = fontArr[index];
    [_paramsClothes setObject:model3 forKey:@"font"];
    colortag = index;
    DiyHeadCell * colorCell = [self.view viewWithTag:1004];
    colorCell.rightLabel.text = model3.part_name;
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
