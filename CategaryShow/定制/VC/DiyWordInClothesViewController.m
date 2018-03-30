//
//  DiyWordInClothesViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/13.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "DiyWordInClothesViewController.h"
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
@interface DiyWordInClothesViewController ()<UITableViewDelegate, UITableViewDataSource, positionDelegate, colorDelegate, fontDelegate,UITextFieldDelegate,banXingDelegate,mianLiaoDelegate>

@property (nonatomic, retain) NSMutableDictionary *paramsClothes;

@end

@implementation DiyWordInClothesViewController
{
    BaseDomain *postData;
    BaseDomain *getData;
    UITableView *diyTable;
    NSMutableArray * twodiyArr;
    NSMutableDictionary *dataDic;
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
    
    NSMutableDictionary *textFildString;
    BOOL is_english;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    postData = [BaseDomain getInstance:NO];
    is_english = YES;
    dic = [NSMutableDictionary dictionary];
    dataDic = [NSMutableDictionary dictionary];
    _paramsClothes = [NSMutableDictionary dictionary];
    diyArray = [NSMutableArray array];
    twodiyArr = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    isViewYFisrt = YES;
    banxingtag = 0;
    mianliaotag = 0;
    colortag =0;
    positiontag =0;
    fonttag =0;
    _banxing = [NSDictionary dictionary];
    textFildString = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self settabTitle:@"个性定制"];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(moreDiy:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeClothes:) name:@"change" object:nil];
    
    
    [self getDatas];
}
-(void)moreDiy:(UIButton *)button
{
    ChooseClothesStyleViewController *chooseStyleCon = [[ChooseClothesStyleViewController alloc] init];
    chooseStyleCon.banxing = _banxing;
    chooseStyleCon.price_Type = [_price stringForKey:@"id"];
    chooseStyleCon.price = _price;
    chooseStyleCon.class_id = _class_id;
    chooseStyleCon.paramsClothes = _paramsClothes;
    chooseStyleCon.xiuZiDic = _xiuZiDic;
    if([textFildString objectForKey:@"name"] ==nil)
    {
        
        chooseStyleCon.diydetailArray = twodiyArr;
    }
    else
    {
    chooseStyleCon.diydetailArray = diydetailArray;
    }
    chooseStyleCon.mianliaoprice = [_price objectForKey:@"price"];
    chooseStyleCon.goodDic = _goodDic;
    chooseStyleCon.dataDic = dataDic;
    chooseStyleCon.banxingtag =banxingtag;
    chooseStyleCon.diyArray =diyArray;
    chooseStyleCon.dateId =_dateId;
    chooseStyleCon.dingDate = _dingDate;
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
    [params setObject:_class_id forKey:@"classify_id"];
    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [params setObject:@"6" forKey:@"phone_type"];
    [getData getData:URL_GetDiyData PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            dataDic = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
            
//            diydetailArray = [NSMutableArray arrayWithObjects:[[dataDic arrayForKey:@"position"] firstObject],[[dataDic arrayForKey:@"color"] firstObject],[[dataDic arrayForKey:@"font"] firstObject], nil];
            diydetailArray = [NSMutableArray array];
            if ([[dataDic arrayForKey:@"classify_id"] count] > 0) {
                [diydetailArray addObject:[[dataDic arrayForKey:@"classify_id"]firstObject]];
                [twodiyArr addObject:[[dataDic arrayForKey:@"classify_id"]firstObject]];
            }
            else
            {
                [diydetailArray addObject:[NSDictionary dictionary]];
            }
            if ([[dataDic arrayForKey:@"mianliao"]count]>0) {
                [diydetailArray addObject:[[dataDic arrayForKey:@"mianliao"]firstObject]];
                [twodiyArr addObject:[[dataDic arrayForKey:@"mianliao"]firstObject]];
            }
            else
            {
                [diydetailArray addObject:[NSDictionary dictionary]];
            }
            if ([[dataDic arrayForKey:@"position"] count] > 0) {
                [diydetailArray addObject:[[dataDic arrayForKey:@"position"] firstObject]];
            } else {
                [diydetailArray addObject:[NSDictionary dictionary]];
            }
           
            if ([[dataDic arrayForKey:@"color"] count] > 0) {
                [diydetailArray addObject:[[dataDic arrayForKey:@"color"] firstObject]];
            }else {
                [diydetailArray addObject:[NSDictionary dictionary]];
            }
            
            if ([[dataDic arrayForKey:@"font"] count] > 0) {
                [diydetailArray addObject:[[dataDic arrayForKey:@"font"] firstObject]];
            }else {
                [diydetailArray addObject:[NSDictionary dictionary]];
            }
            
            
//            _goodArray = [NSMutableArray arrayWithArray:[[[dataDic arrayForKey:@"spec_templets_recommend"] firstObject] arrayForKey:@"list"]];
            
            
            for (NSDictionary *dic in diydetailArray) {
                [diyArray addObject:[NSString stringWithFormat:@"%@:%@", [dic stringForKey:@"a_name"],[dic stringForKey:@"name"]]];
            }
            [self createDiyView];

//            [diyTable reloadData];
            
        }
    }];
    
}

-(void)createDiyView
{
    if (@available(iOS 11.0, *)) {
        diyTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    diyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,IsiPhoneX?SCREEN_HEIGHT-64-95: SCREEN_HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
    diyTable.dataSource = self;
    diyTable.delegate = self;
    [diyTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [diyTable registerClass:[BanXingTableViewCell class] forCellReuseIdentifier:@"banxing"];
    [diyTable registerClass:[MianLiaoCell class] forCellReuseIdentifier:@"mianliao"];

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
    
    
    UILabel *priceDetail = [[UILabel alloc] initWithFrame:CGRectMake(0,IsiPhoneX?SCREEN_HEIGHT-64-95:SCREEN_HEIGHT -64- 50, SCREEN_WIDTH / 3-10, 50)];
    priceDetail.tag = 6000;
    priceDetail.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:priceDetail];
    [priceDetail setText:[NSString stringWithFormat:@"合计:¥%@",[[[dataDic arrayForKey:@"mianliao"]objectAtIndex:0] objectForKey:@"price"]]];
    priceDetail.textColor= [UIColor colorWithHexString:@"#222222"];
    [priceDetail setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:16]];
    
    
//    UILabel *priceTitle = [UILabel new];
//    [self.view addSubview:priceTitle];
//    priceTitle.sd_layout
//    .centerYEqualToView(priceLowView)
//    .rightSpaceToView(priceDetail,0)
//    .widthIs(40)
//    .autoHeightRatio(20);
//    [priceTitle setText:@"合计:"];
//    [priceTitle setFont:[UIFont systemFontOfSize:14]];
    
    
    
    
    UIButton *buttonSave = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3,IsiPhoneX?SCREEN_HEIGHT-64-95: SCREEN_HEIGHT -64- 50, SCREEN_WIDTH / 3 , 50)];
    [buttonSave setBackgroundColor:getUIColor(Color_DZClolor)];
    [self.view addSubview:buttonSave];
    [buttonSave addTarget:self action:@selector(saveTheClothes) forControlEvents:UIControlEventTouchUpInside];
    [buttonSave.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonSave setTitle:@"加入购物袋" forState:UIControlStateNormal];
    
    
    UIButton *buttonBuy = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2,IsiPhoneX?SCREEN_HEIGHT-64-95: SCREEN_HEIGHT -64- 50, SCREEN_WIDTH / 3 , 50)];
    [buttonBuy setBackgroundColor:getUIColor(Color_TKClolor)];
    [self.view addSubview:buttonBuy];
    [buttonBuy addTarget:self action:@selector(payForClothes) forControlEvents:UIControlEventTouchUpInside];
    [buttonBuy.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonBuy setTitle:@"立即购买" forState:UIControlStateNormal];
    
}
-(void)payForClothes
{
    [_paramsClothes setObject:@"1" forKey:@"goods_type"];
    [_paramsClothes setObject:@"1" forKey:@"type"];
    [_paramsClothes setObject:[_price objectForKey:@"price_id"] forKey:@"price_id"];
    [_paramsClothes setObject:[_goodDic objectForKey:@"id"] forKey:@"goods_id"];
    [_paramsClothes setObject:[_price objectForKey:@"price"] forKey:@"price"];
    [_paramsClothes setObject:[_goodDic objectForKey:@"name"] forKey:@"goods_name"];
    if (diyArray != nil) {
        [_paramsClothes setObject:[diyArray componentsJoinedByString:@";"] forKey:@"diy_content"];
    }
    if ([[_price objectForKey:@"goods_img"] length]>0) {
        [_paramsClothes setObject:[_price objectForKey:@"goods_img"] forKey:@"goods_thumb"];
    }
    else
    {
        [_paramsClothes setObject:[_goodDic objectForKey:@"thumb"] forKey:@"goods_thumb"];
    }
    [_paramsClothes setObject:[_paramsDic objectForKey:@"spec_ids"] forKey:@"spec_ids"];
    [_paramsClothes setObject:[_paramsDic objectForKey:@"spec_content"] forKey:@"spec_content"];
    [_paramsClothes setObject:[_price objectForKey:@"id"] forKey:@"mainliao_id"];
    [_paramsDic setObject:[[dataDic arrayForKey:@"classify_id"]objectAtIndex:banxingtag]  forKey:@"banxing_id"];
    if (_ifTK) {
        [_paramsClothes setObject:@"1" forKey:@"is_scan"];
    } else {
        [_paramsClothes setObject:@"0" forKey:@"is_scan"];
    }
    [_paramsClothes setObject:@"1" forKey:@"num"];
    [postData postData:URL_AddClothesCar PostParams:_paramsClothes finish:^(BaseDomain *domain, Boolean success) {
       // WCLLog(@"%@",domain.dataRoot);
        if ([self checkHttpResponseResultStatus:postData]) {
            ClothesFroPay *model = [ClothesFroPay new];
            if ([_paramsClothes stringForKey:@"mian_img"].length > 0) {
                model.clothesImage = [_paramsClothes stringForKey:@"mian_img"];
            } else {
                model.clothesImage = [_paramsClothes stringForKey:@"goods_thumb"];
            }
            
            model.clothesCount = @"1";
            model.clothesName = [_goodDic stringForKey:@"name"];
            model.clothesPrice = [_price objectForKey:@"price"];
            model.clotheMaxCount = @"100";
            NSMutableArray *array = [NSMutableArray arrayWithObjects:model, nil];
            PayForClothesViewController *clothesPay = [[PayForClothesViewController alloc] init];
            clothesPay.dateId = [_goodDic stringForKey:@"id"];
            clothesPay.dingDate =  [NSDate dateWithTimeIntervalSinceNow:0];
            clothesPay.arrayForClothes = array;
            clothesPay.carId = [[domain.dataRoot objectForKey:@"data"] stringForKey:@"car_id"];
            clothesPay.allPrice = [_price objectForKey:@"price"];
            [self.navigationController pushViewController:clothesPay animated:YES];
        }
        
    }];
    
}
-(void)saveTheClothes
{
    [_paramsClothes setObject:@"1" forKey:@"goods_type"];
    [_paramsClothes setObject:@"2" forKey:@"type"];
    [_paramsClothes setObject:[_price objectForKey:@"price_id"] forKey:@"price_id"];
    [_paramsClothes setObject:[_goodDic objectForKey:@"id"] forKey:@"goods_id"];
    [_paramsClothes setObject:[_price objectForKey:@"price"] forKey:@"price"];
    [_paramsClothes setObject:[_goodDic objectForKey:@"name"] forKey:@"goods_name"];
    if ([[_price objectForKey:@"goods_img"] length]>0) {
        [_paramsClothes setObject:[_price objectForKey:@"goods_img"] forKey:@"goods_thumb"];
    }
    else
    {
        [_paramsClothes setObject:[_goodDic objectForKey:@"thumb"] forKey:@"goods_thumb"];
    }
    [_paramsClothes setObject:[_paramsDic objectForKey:@"spec_ids"] forKey:@"spec_ids"];
    [_paramsClothes setObject:[_paramsDic objectForKey:@"spec_content"] forKey:@"spec_content"];
    [_paramsClothes setObject:[_price objectForKey:@"id"] forKey:@"mainliao_id"];
    [_paramsDic setObject:[[dataDic arrayForKey:@"classify_id"]objectAtIndex:banxingtag]  forKey:@"banxing_id"];
     if (diyArray != nil) {
    [_paramsDic setObject:[diyArray componentsJoinedByString:@";"] forKey:@"diy_content"];
     }
    [_paramsClothes setObject:@"1" forKey:@"num"];
    
    if (_ifTK) {
        [_paramsClothes setObject:@"1" forKey:@"is_scan"];
    } else {
        [_paramsClothes setObject:@"0" forKey:@"is_scan"];
    }
    
    [postData postData:URL_AddClothesCar PostParams:_paramsClothes finish:^(BaseDomain *domain, Boolean success) {
        WCLLog(@"%@",domain.dataRoot);
        if ([self checkHttpResponseResultStatus:postData]) {
            [self alertViewShowOfTime:domain.resultMessage time:1.5];
//            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 60, ScreenHeight / 2 - 60, 120, 120)];
//            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_paramsClothes stringForKey:@"goods_thumb"]]]];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addCarSuccess" object:nil];
//            [[PurchaseCarAnimationTool shareTool]startAnimationandView:image andRect:image.frame andFinisnRect:CGPointMake(ScreenWidth - 30, 35) andFinishBlock:^(BOOL finisn){
//                //                UIView *tabbarBtn = self.tabBarController.tabBar.subviews[3];
//                [PurchaseCarAnimationTool shakeAnimation:rightButton];
            
                //                 [self alertViewShowOfTime:@"加入购物车成功" time:1.5];
           // }];
            //
            
            
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
    UIButton * jiantouBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-27, 19, 14, 10)];
    if (section == 0) {
        [titleLabel setText:@"选择版型"];
        rightLabel.tag = 2222;
        if ([[dataDic arrayForKey:@"classify_id"] count]>0) {
            rightLabel.text =[[[dataDic arrayForKey:@"classify_id"] objectAtIndex:banxingtag] stringForKey:@"name"];
            _banxing = [[dataDic arrayForKey:@"classify_id"] objectAtIndex:banxingtag];
            NSMutableDictionary * dic1 = [NSMutableDictionary dictionaryWithDictionary:[[dataDic arrayForKey:@"classify_id"] objectAtIndex:banxingtag]];
            [dic1 setObject:@"版型" forKey:@"a_name"];
            [diydetailArray replaceObjectAtIndex:0 withObject:dic1];
            [twodiyArr replaceObjectAtIndex:0 withObject:dic1];

        }
    } else if (section == 1) {
        [titleLabel setText:@"选择面料(长按可看大图)"];
        rightLabel.tag =2223;
        if ([[dataDic arrayForKey:@"mianliao"]count]>0) {
            rightLabel.text = [[[dataDic arrayForKey:@"mianliao"] objectAtIndex:mianliaotag] stringForKey:@"name"];
            _price = [[dataDic arrayForKey:@"mianliao"]objectAtIndex:mianliaotag];
//            [[[[dataDic arrayForKey:@"mianliao"] objectAtIndex:mianliaotag] copy] setObject:@"面料" forKey:@"a_name"];
            NSMutableDictionary * dic2 = [NSMutableDictionary dictionaryWithDictionary:[[dataDic arrayForKey:@"mianliao"]objectAtIndex:mianliaotag]];
            [dic2 setObject:@"面料" forKey:@"a_name"];
            [diydetailArray replaceObjectAtIndex:1 withObject:dic2];
            [twodiyArr replaceObjectAtIndex:1 withObject:dic2];

        }
    }
    else
    {
        titleLabel.text = @"选择刺绣";
        [titleSection addSubview:jiantouBtn];
        
    }
    if([dic[@"2"] integerValue]==1)
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
    
    if (tap.view.tag ==302) {
         NSString *str = @"2";
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
    return 43;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==2) {
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
    if (indexPath.section == 0) {
        return 35+(SCREEN_WIDTH-60)/4;
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row==0||indexPath.row==2||indexPath.row==4||indexPath.row==6) {
            return 38;
        }else
        {
          return  35+(SCREEN_WIDTH-60)/4;
        }
    }
        
    return 35+(SCREEN_WIDTH-60)/4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    if (indexPath.section == 0) {
        BanXingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"banxing" forIndexPath:indexPath];
        cell.banXingArray = [NSMutableArray arrayWithArray:[dataDic arrayForKey:@"classify_id"]];
        cell.delegate = self;
        reCell =cell;
    
    }
    else if (indexPath.section == 1)
    {
        MianLiaoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mianliao" forIndexPath:indexPath];
        cell.mianLiaoArray =  [NSMutableArray arrayWithArray:[dataDic arrayForKey:@"mianliao"]];
        cell.delegate = self;
        reCell = cell;
    }
    else //2行
    {
        if (indexPath.row==0) {
            DiyHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"diyHead" forIndexPath:indexPath];
            cell.leftLabel.text = @"选择刺绣位置";
            cell.tag = 1000;
            cell.firstView.hidden= YES;
            cell.rightLabel.text = [[[dataDic arrayForKey:@"position"] objectAtIndex:positiontag] stringForKey:@"name"];
            reCell = cell;
        }
        else if (indexPath.row==1) {
            positionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"position" forIndexPath:indexPath];
            cell.positionArray = [NSMutableArray arrayWithArray:[dataDic arrayForKey:@"position"]];
            cell.delegate = self;
            reCell = cell;
        }
        else if(indexPath.row==2)
        {
            DiyHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"diyHead" forIndexPath:indexPath];
            cell.tag =1002;
            cell.leftLabel.text = @"选择字体颜色";
            cell.rightLabel.text = [[[dataDic arrayForKey:@"color"] objectAtIndex:colortag] stringForKey:@"name"];
            reCell = cell;
        }
        else if (indexPath.row==3)
        {
            colorChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"color" forIndexPath:indexPath];
            cell.colorArray = [NSMutableArray arrayWithArray:[dataDic arrayForKey:@"color"]];
            cell.delegate = self;
            reCell = cell;
        }
        else if (indexPath.row==4)
        {
            DiyHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"diyHead" forIndexPath:indexPath];
            cell.leftLabel.text = @"选择字体";
            cell.tag = 1004;
            cell.rightLabel.text = [[[dataDic arrayForKey:@"font"] objectAtIndex:fonttag] stringForKey:@"name"];
            cell.endView.hidden =NO;
            reCell = cell;
        }
        else if (indexPath.row==5)
        {
            fontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"font" forIndexPath:indexPath];
            cell.delegate = self;
            cell.fontArray = [NSMutableArray arrayWithArray:[dataDic arrayForKey:@"font"]];
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
            cell.isenglish = is_english;
            reCell = cell;
        }
    }
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(void)textfieldDidChange:(UITextField *)textfield
{
    [diydetailArray removeObject:textFildString];

    if (textfield.text.length>0) {
        [textFildString setObject:@"文字" forKey:@"a_name"];
        [textFildString setObject:textfield.text forKey:@"name"];
        [diydetailArray addObject:textFildString];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [diydetailArray removeObject:textFildString];
    if (textField.text.length>0) {
        [textFildString setObject:@"文字" forKey:@"a_name"];
        [textFildString setObject:textField.text forKey:@"name"];
        [diydetailArray addObject:textFildString];
    }
    //        NSString *contentDiy = [diyArray componentsJoinedByString:@";"];
    [textField resignFirstResponder];
    return YES;
}
-(void)banXingClick:(NSInteger)index
{
    [diyArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@:%@",[[[dataDic arrayForKey:@"classify_id"] objectAtIndex:index] stringForKey:@"a_name"],[[[dataDic arrayForKey:@"classify_id"] objectAtIndex:index] stringForKey:@"name"]]];
    _banxing = [[dataDic arrayForKey:@"classify_id"]objectAtIndex:index];
    UILabel *Label = [self.view viewWithTag:2222];
    Label.text = [[[dataDic arrayForKey:@"classify_id"] objectAtIndex:index] stringForKey:@"name"];
    banxingtag = index;
    NSMutableDictionary * banxingDic = [NSMutableDictionary dictionaryWithDictionary:[[dataDic arrayForKey:@"classify_id"] objectAtIndex:index]]  ;
    [banxingDic setObject:@"版型" forKey:@"a_name"];
    [diydetailArray replaceObjectAtIndex:0 withObject:banxingDic];
    [twodiyArr replaceObjectAtIndex:0 withObject:banxingDic];
}
-(void)mianLiaoClick:(NSInteger)index
{
    [diyArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@:%@",[[[dataDic arrayForKey:@"mianliao"] objectAtIndex:index] stringForKey:@"a_name"],[[[dataDic arrayForKey:@"mianliao"] objectAtIndex:index] stringForKey:@"name"]]];
    _price = [[dataDic arrayForKey:@"mianliao"]objectAtIndex:index];
    UILabel * label1 = [self.view viewWithTag:6000];
    label1.text = [NSString stringWithFormat:@"合计:¥%@",[_price objectForKey:@"price"]];
    UILabel *Label = [self.view viewWithTag:2223];
    Label.text = [[[dataDic arrayForKey:@"mianliao"] objectAtIndex:index] stringForKey:@"name"];
    mianliaotag = index;
    NSMutableDictionary * mianliaoDic = [NSMutableDictionary dictionaryWithDictionary:[[dataDic arrayForKey:@"mianliao"] objectAtIndex:index]];
    [mianliaoDic setObject:@"面料" forKey:@"a_name"];
    [diydetailArray replaceObjectAtIndex:1 withObject:mianliaoDic];
    [twodiyArr replaceObjectAtIndex:1 withObject:mianliaoDic];
}
-(void)positionClick:(NSInteger)index
{
    [diyArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@:%@",[[[dataDic arrayForKey:@"position"] objectAtIndex:index] stringForKey:@"a_name"],[[[dataDic arrayForKey:@"position"] objectAtIndex:index] stringForKey:@"name"]]];
    positiontag = index;
    DiyHeadCell * positionCell = [self.view viewWithTag:1000];
    positionCell.rightLabel.text = [[[dataDic arrayForKey:@"position"] objectAtIndex:index] stringForKey:@"name"];
    [diydetailArray replaceObjectAtIndex:2 withObject:[[dataDic arrayForKey:@"position"] objectAtIndex:index]];
}

-(void)colorClick:(NSInteger)index
{
    [diyArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@:%@",[[[dataDic arrayForKey:@"color"] objectAtIndex:index] stringForKey:@"a_name"],[[[dataDic arrayForKey:@"color"] objectAtIndex:index] stringForKey:@"name"]]];
    colortag = index;
    DiyHeadCell * colorCell = [self.view viewWithTag:1002];
    colorCell.rightLabel.text = [[[dataDic arrayForKey:@"color"] objectAtIndex:index] stringForKey:@"name"];
    [diydetailArray replaceObjectAtIndex:3 withObject:[[dataDic arrayForKey:@"color"] objectAtIndex:index]];
}

-(void)fontChoose:(NSInteger)index
{
     [diyArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@:%@",[[[dataDic arrayForKey:@"font"] objectAtIndex:index] stringForKey:@"a_name"],[[[dataDic arrayForKey:@"font"] objectAtIndex:index] stringForKey:@"name"]]];
    fonttag = index;
    DiyHeadCell * fontCell = [self.view viewWithTag:1004];
    fontCell.rightLabel.text = [[[dataDic arrayForKey:@"font"] objectAtIndex:index] stringForKey:@"name"];
    if ([[[dataDic arrayForKey:@"font"] objectAtIndex:index] stringForKey:@"is_english"]) {
        is_english = YES;
    } else {
        is_english = NO;
    }
    [diydetailArray replaceObjectAtIndex:4 withObject:[[dataDic arrayForKey:@"font"] objectAtIndex:index]];

}




//-(void)nextStep
//{
//    if ([diydetailArray count] == 5) {
//        [diydetailArray addObject:textFildString];
//
//    }
//
//    if ([textFildString count] == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入文字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//
//        [alert show];
//    } else {
//        [diyArray addObject:[NSString stringWithFormat:@"%@:%@", [textFildString stringForKey:@"a_name"], [textFildString stringForKey:@"name"]]];
//        NSString *contentDiy = [diyArray componentsJoinedByString:@";"];
//        [_paramsDic setObject:contentDiy forKey:@"diy_content"];
//
//
//        ChooseClothesResultViewController *result = [[ChooseClothesResultViewController alloc] init];
//        result.paramsClothes = _paramsDic;
//        result.mianliaoprice = [_price objectForKey:@"price"];
//        result.goodArray = _goodArray;
//        result.goodDic = _goodDic;
//        result.price = _price;
//        result.diyArray = diyArray;
//        result.xiuZiDic = _xiuZiDic;
//        result.diyDetailArray = diydetailArray;
//        result.dateId = _dateId;
//        result.dingDate = _dingDate;
//        result.banxingid = [_banxing stringForKey:@"classify_id"];
//        result.ifTK = _ifTK;
//        result.defaultImg = _defaultImg;
//        [self.navigationController pushViewController:result animated:YES];
//    }
//
//
//}

//-(void)nextStepNoDiy
//{
//    ChooseClothesResultViewController *result = [[ChooseClothesResultViewController alloc] init];
//    result.paramsClothes = _paramsDic;
//    result.goodArray = _goodArray;
//    result.goodDic = _goodDic;
//    result.price = [_price stringForKey:@"price"];
//    result.xiuZiDic = _xiuZiDic;
//    result.dateId = _dateId;
//    result.dingDate = _dingDate;
//    result.banMian = _banMain;
//    result.ifTK = _ifTK;
//    result.defaultImg = _defaultImg;
////    result.diyArray = diyArray;
////    result.diyDetailArray = diydetailArray;
//    [self.navigationController pushViewController:result animated:YES];
//}

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
