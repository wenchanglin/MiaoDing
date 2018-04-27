//
//  AddLiangTiVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/4/25.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "AddLiangTiVC.h"
#import "QuickPhotoYinDaoVC.h"
#import "PaiZhaoTestCell.h"
#import "HeightAndWeightCell.h"
#import "QuickPhotoVC.h"
@interface AddLiangTiVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@end

@implementation AddLiangTiVC
{
    UITableView * diyTable;
    NSInteger isopencv;
    NSMutableDictionary *textFieldString;
    NSMutableDictionary * heightAndWeightDic;
    NSMutableDictionary *nameString;
    UIButton *buttonAdd;
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"添加量体数据"];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = YES;
    heightAndWeightDic = [NSMutableDictionary dictionary];
    if (@available(iOS 11.0, *)) {
        diyTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self createDiyView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"增加量体数据"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"增加量体数据"];
}

-(void)createDiyView
{
    diyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,IsiPhoneX?SCREEN_HEIGHT-64-45: SCREEN_HEIGHT - 64 ) style:UITableViewStyleGrouped];
    diyTable.dataSource = self;
    diyTable.delegate = self;
    [diyTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [diyTable registerClass:[HeightAndWeightCell class] forCellReuseIdentifier:@"heightandweights"];
    [diyTable registerClass:[PaiZhaoTestCell class] forCellReuseIdentifier:@"paizhaotests"];
    [self.view addSubview:diyTable];
    //    buttonAdd = [[UIButton alloc] initWithFrame:CGRectMake(0,IsiPhoneX?SCREEN_HEIGHT-64-92:SCREEN_HEIGHT -64- 49, SCREEN_WIDTH, 49)];
    //    [self.view addSubview:buttonAdd];
    //    [buttonAdd setBackgroundColor:getUIColor(Color_DZClolor)];
    //    [buttonAdd setTitle:@"保存" forState:UIControlStateNormal];
    //    [buttonAdd.titleLabel setFont:[UIFont systemFontOfSize:16]];
    //    [buttonAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [buttonAdd addTarget:self action:@selector(saveLiangTiClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43;
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
    if(section==0)
    {
        [titleLabel setText:@"输入基本信息"];
        rightLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame)-55, 0, 250, 42);
        rightLabel.textAlignment = NSTextAlignmentLeft;
        rightLabel.textColor = [UIColor colorWithHexString:@"#B10909"];
        rightLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:10];
        rightLabel.text = @"为了确保衣服合身，请准确输入你的净身高、净体重";
    }
    else if (section==1)
    {
        [titleLabel setText:@"拍照量体"];
        UILabel * centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)-95, 0, 250, 42)];
        [titleSection addSubview:centerLabel];
        centerLabel.textAlignment = NSTextAlignmentLeft;
        centerLabel.textColor = [UIColor colorWithHexString:@"#B10909"];
        centerLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:10];
        centerLabel.text = @"若不方便即时拍照量体可稍后与客服确认体型数据";
        rightLabel.text = @"⊙帮助";
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH, 1)];
    [titleSection addSubview:lineView];
    [lineView setBackgroundColor:getUIColor(Color_saveColor)];
    return titleSection;
}
- (void)action_tap:(UIGestureRecognizer *)tap{
    if(tap.view.tag==301)
    {
        QuickPhotoYinDaoVC * qvc = [[QuickPhotoYinDaoVC alloc]init];
        qvc.ishelp = YES;
        [self.navigationController pushViewController:qvc animated:YES];
    }
    if (tap.view.tag ==304) {
        
    }
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 109;
    }
    else if (indexPath.section==1)
    {
        return 77;
    }
    return 43;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    if (indexPath.section==0) {
        HeightAndWeightCell * cell = [tableView dequeueReusableCellWithIdentifier:@"heightandweights"];
        if (!cell) {
            cell = [[HeightAndWeightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"heightandweights"];
        }
        cell.weightTextField.delegate = self;
        cell.heightTextField.delegate = self;
        cell.nameTextField.delegate = self;
        [cell.nameTextField addTarget:self action:@selector(weighttextfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.weightTextField addTarget:self action:@selector(weighttextfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.heightTextField addTarget:self action:@selector(weighttextfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        reCell= cell;
        
    }
    else if (indexPath.section==1)
    {
        PaiZhaoTestCell * cell = [tableView dequeueReusableCellWithIdentifier:@"paizhaotests"];
        if (!cell) {
            cell = [[PaiZhaoTestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paizhaotests"];
        }
        [cell.photoImageView setImage:[UIImage imageNamed:@"xiangji"] forState:UIControlStateNormal];
        cell.shuomingLabel.text = @"图像拍摄后会自动对脸部进行模糊处理，请放心拍摄。";
        
        [cell.photoImageView addTarget:self action:@selector(xiangji:) forControlEvents:UIControlEventTouchUpInside];
        reCell= cell;
    }
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}
-(void)weighttextfieldDidChange:(UITextField *)textfield
{
    if (textfield.text.length>0) {
        if (textfield.tag==990) {
            [heightAndWeightDic setObject:textfield.text forKey:@"name"];
        }
        if (textfield.tag==991) {
            //            [heightAndWeightDic removeObjectForKey:@"height"];
            [heightAndWeightDic setObject:textfield.text forKey:@"height"];
        }
        else if (textfield.tag==992)
        {
            //            [heightAndWeightDic removeObjectForKey:@"weight"];
            [heightAndWeightDic setObject:textfield.text forKey:@"weight"];
            
        }
    }
    else
    {
        switch (textfield.tag) {
            case 990:
            {
                [heightAndWeightDic removeObjectForKey:@"name"];
            }
                break;
            case 991:
            {
                [heightAndWeightDic removeObjectForKey:@"height"];
            }
                break;
            case 992:
            {
                [heightAndWeightDic removeObjectForKey:@"weight"];
            }
                break;
                
            default:
                break;
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length>0) {
        if (textField.tag ==990) {
            [heightAndWeightDic setObject:textField.text forKey:@"name"];
        }
        if (textField.tag==991) {
            
            [heightAndWeightDic setObject:textField.text forKey:@"height"];
        }
        else if (textField.tag==992)
        {
            [heightAndWeightDic setObject:textField.text forKey:@"weight"];
            
        }
    }
    else
    {
        switch (textField.tag) {
            case 990:
            {
                [heightAndWeightDic removeObjectForKey:@"name"];
                
            }
                break;
            case 991:
            {
                [heightAndWeightDic removeObjectForKey:@"height"];
            }
                break;
            case 992:
            {
                [heightAndWeightDic removeObjectForKey:@"weight"];
            }
                break;
                
            default:
                break;
        }
    }
    [textField resignFirstResponder];
    return YES;
}
-(void)xiangji:(UIButton*)btn
{
    
    [heightAndWeightDic setObject:[SelfPersonInfo getInstance].personPhone forKey:@"phone"];
    if (_chenpingbool) {
        if ([[heightAndWeightDic stringForKey:@"name"] length]>0) {
            if([[heightAndWeightDic stringForKey:@"height"] length]>0)
            {
                if ([[heightAndWeightDic stringForKey:@"weight"]length]>0) {
                        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                            QuickPhotoYinDaoVC * vc = [[QuickPhotoYinDaoVC alloc]init];
                            vc.params = heightAndWeightDic;
                            vc.comefromGeXingDingZhi = NO;
                            vc.bodyHeight = [[heightAndWeightDic stringForKey:@"height"] floatValue];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        else
                        {
                            [self alertViewShowOfTime:@"该设备不支持相机功能" time:1];
                        }
                }
                else
                {
                    [self alertViewShowOfTime:@"体重不能为空" time:1];
                    
                }
            }
            else
            {
                [self alertViewShowOfTime:@"身高不能为空" time:1];
            }
        }
        else
        {
            [self alertViewShowOfTime:@"姓名或昵称不能为空" time:1];
            
        }
    }
    else
    {
    if([[heightAndWeightDic stringForKey:@"name"] length]>0)
    {
        if([[heightAndWeightDic stringForKey:@"height"] length]>0)
        {
            if ([[heightAndWeightDic stringForKey:@"weight"]length]>0) {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    QuickPhotoVC * qvc = [[QuickPhotoVC alloc]init];
                    qvc.params = heightAndWeightDic;
                    qvc.comefromGeXingDingZhi = NO;
                    qvc.bodyHeight = [[heightAndWeightDic stringForKey:@"height"] floatValue];
                    [self.navigationController pushViewController:qvc animated:YES];
                }
                else
                {
                    [self alertViewShowOfTime:@"该设备不支持相机功能" time:1];
                }
                
            }
            else
            {
                [self alertViewShowOfTime:@"体重不能为空" time:1];
                
            }
        }
        else
        {
            [self alertViewShowOfTime:@"身高不能为空" time:1];
        }
    }
    else
    {
        [self alertViewShowOfTime:@"姓名不能为空" time:1];
        
    }
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
