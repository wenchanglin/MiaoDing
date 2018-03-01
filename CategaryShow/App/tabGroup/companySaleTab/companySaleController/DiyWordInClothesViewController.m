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
@interface DiyWordInClothesViewController ()<UITableViewDelegate, UITableViewDataSource, positionDelegate, colorDelegate, fontDelegate,UITextFieldDelegate>



@end

@implementation DiyWordInClothesViewController
{
    BaseDomain *getData;
    UITableView *diyTable;
    NSMutableDictionary *dataDic;
    NSMutableArray *diyArray;
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
    is_english = YES;
    dataDic = [NSMutableDictionary dictionary];
    diyArray = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    isViewYFisrt = YES;
    textFildString = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"个性绣花";
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(nextStepNoDiy) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeClothes:) name:@"change" object:nil];
    
    [self createDiyView];
    
    [self getDatas];
    
    // Do any additional setup after loading the view.
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
            
            [diyTable reloadData];
            
        }
    }];
    
}

-(void)createDiyView
{
    diyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
    diyTable.dataSource = self;
    diyTable.delegate = self;
    [diyTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [diyTable registerClass:[positionTableViewCell class] forCellReuseIdentifier:@"position"];
    [diyTable registerClass:[colorChooseTableViewCell class] forCellReuseIdentifier:@"color"];
    [diyTable registerClass:[fontTableViewCell class] forCellReuseIdentifier:@"font"];
    
    [diyTable registerClass:[textFieldWordDiyTableViewCell class] forCellReuseIdentifier:@"textField"];
    [self.view addSubview:diyTable];
    

   
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 40, SCREEN_WIDTH , 40)];
    [button2 setBackgroundColor:getUIColor(Color_buyColor)];
    [button2 addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [button2.layer setCornerRadius:1];
    [button2.layer setMasksToBounds:YES];
    [button2 setTitle:@"预览" forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 20, 42)];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleSection addSubview:titleLabel];
    
    if (section == 0) {
        [titleLabel setText:@"选择位置"];
    } else if (section == 1) {
        [titleLabel setText:@"选择颜色"];
    } else if (section == 2) {
        [titleLabel setText:@"选择字体"];
    } else if (section == 3) {
        [titleLabel setText:@"绣花内容"];
    }
    
    if (section != 3) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH, 1)];
        [titleSection addSubview:lineView];
        [lineView setBackgroundColor:getUIColor(Color_saveColor)];
    }
    
    
    return titleSection;
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
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return  85;
    } else 
    return 103 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    if (indexPath.section == 0) {
        positionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"position" forIndexPath:indexPath];
        cell.positionArray = [NSMutableArray arrayWithArray:[dataDic arrayForKey:@"position"]];
        cell.delegate = self;
        reCell = cell;
    } else if (indexPath.section == 1)
    {
        colorChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"color" forIndexPath:indexPath];
        cell.colorArray = [NSMutableArray arrayWithArray:[dataDic arrayForKey:@"color"]];
        cell.delegate = self;
        reCell = cell;
       
    } else if (indexPath.section == 2)
    {
        fontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"font" forIndexPath:indexPath];
        cell.delegate = self;
        cell.fontArray = [NSMutableArray arrayWithArray:[dataDic arrayForKey:@"font"]];
        reCell = cell;
    }else if (indexPath.section == 3)
    {
        textFieldWordDiyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textField" forIndexPath:indexPath];
        cell.wordDiy .delegate = self;
        cell.isenglish = is_english;
        reCell = cell;
    }
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollViewToBottom:YES];
    
    if (isViewYFisrt) {
        initViewY = self.view.frame.origin.y;
        isViewYFisrt = NO;
    }
    
    int offset = [self getControlFrameOriginY:textField] + 75 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)scrollViewToBottom:(BOOL)animated

{
    
    if (diyTable.contentSize.height > diyTable.frame.size.height)
        
    {
        
        CGPoint offset = CGPointMake(0, diyTable.contentSize.height - diyTable.frame.size.height);
        
        [diyTable setContentOffset:offset animated:animated];
        
    }
    
}

- (CGFloat) getControlFrameOriginY : (UIView *) curView {
    
    CGFloat resultY = 0;
    
    if ([curView superview] != nil && ![[curView superview] isEqual:self.view]) {
        resultY = [self getControlFrameOriginY:[curView superview]];
    }
    
    return resultY + curView.frame.origin.y;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect frame = self.view.frame;
    
    frame.origin.x = 0;
    frame.origin.y = initViewY;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    [self.view setFrame:frame];
    
    [UIView commitAnimations];
    //    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textFildString setObject:@"文字" forKey:@"a_name"];
    [textFildString setObject:textField.text forKey:@"name"];
    [textField resignFirstResponder];
    return YES;
}

-(void)positionClcik:(NSInteger)index
{
    [diyArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@:%@",[[[dataDic arrayForKey:@"position"] objectAtIndex:index] stringForKey:@"a_name"],[[[dataDic arrayForKey:@"position"] objectAtIndex:index] stringForKey:@"name"]]];
    
    [diydetailArray replaceObjectAtIndex:0 withObject:[[dataDic arrayForKey:@"position"] objectAtIndex:index]];
}

-(void)colorClick:(NSInteger)index
{
    [diyArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@:%@",[[[dataDic arrayForKey:@"color"] objectAtIndex:index] stringForKey:@"a_name"],[[[dataDic arrayForKey:@"color"] objectAtIndex:index] stringForKey:@"name"]]];
    [diydetailArray replaceObjectAtIndex:1 withObject:[[dataDic arrayForKey:@"color"] objectAtIndex:index]];
}

-(void)fontChoose:(NSInteger)index
{
     [diyArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@:%@",[[[dataDic arrayForKey:@"font"] objectAtIndex:index] stringForKey:@"a_name"],[[[dataDic arrayForKey:@"font"] objectAtIndex:index] stringForKey:@"name"]]];
    [diydetailArray replaceObjectAtIndex:2 withObject:[[dataDic arrayForKey:@"font"] objectAtIndex:index]];
    
    if ([[[dataDic arrayForKey:@"font"] objectAtIndex:index] stringForKey:@"is_english"]) {
        is_english = YES;
    } else {
        is_english = NO;
    }
    
}




-(void)nextStep
{
    if ([diydetailArray count] == 3) {
        [diydetailArray addObject:textFildString];
        
    }
    
    if ([textFildString count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入文字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    } else {
        [diyArray addObject:[NSString stringWithFormat:@"%@:%@", [textFildString stringForKey:@"a_name"], [textFildString stringForKey:@"name"]]];
        NSString *contentDiy = [diyArray componentsJoinedByString:@";"];
        [_paramsDic setObject:contentDiy forKey:@"diy_content"];
        
        
        ChooseClothesResultViewController *result = [[ChooseClothesResultViewController alloc] init];
        result.paramsClothes = _paramsDic;
        
        result.goodArray = _goodArray;
        result.goodDic = _goodDic;
        result.price = [_price stringForKey:@"price"];
        result.diyArray = diyArray;
        result.xiuZiDic = _xiuZiDic;
        result.diyDetailArray = diydetailArray;
        result.dateId = _dateId;
        result.dingDate = _dingDate;
        result.banMian = _banMain;
        result.ifTK = _ifTK;
        result.defaultImg = _defaultImg;
        [self.navigationController pushViewController:result animated:YES];
    }
    
    
}

-(void)nextStepNoDiy
{
    
    
    
    
    
    
    ChooseClothesResultViewController *result = [[ChooseClothesResultViewController alloc] init];
    result.paramsClothes = _paramsDic;
    result.goodArray = _goodArray;
    result.goodDic = _goodDic;
    result.price = [_price stringForKey:@"price"];
    result.xiuZiDic = _xiuZiDic;
    result.dateId = _dateId;
    result.dingDate = _dingDate;
    result.banMian = _banMain;
    result.ifTK = _ifTK;
    result.defaultImg = _defaultImg;
//    result.diyArray = diyArray;
//    result.diyDetailArray = diydetailArray;
    [self.navigationController pushViewController:result animated:YES];
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
