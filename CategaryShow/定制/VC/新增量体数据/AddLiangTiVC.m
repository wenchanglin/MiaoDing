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
#import "HttpRequestTool.h"
@interface AddLiangTiVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,assign)BOOL isHaveDian;

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
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = YES;
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
    diyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-45: SCREEN_HEIGHT - 64 ) style:UITableViewStyleGrouped];
    diyTable.dataSource = self;
    diyTable.delegate = self;
    [diyTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [diyTable registerClass:[HeightAndWeightCell class] forCellReuseIdentifier:@"heightandweights"];
    [diyTable registerClass:[PaiZhaoTestCell class] forCellReuseIdentifier:@"paizhaotests"];
    [self.view addSubview:diyTable];
    buttonAdd = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-92:SCREEN_HEIGHT -64- 49, SCREEN_WIDTH, 49)];
    [self.view addSubview:buttonAdd];
    [buttonAdd setBackgroundColor:getUIColor(Color_DZClolor)];
    [buttonAdd setTitle:@"保存" forState:UIControlStateNormal];
    [buttonAdd.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [buttonAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonAdd addTarget:self action:@selector(saveLiangTiClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)saveLiangTiClick
{
    if ([[heightAndWeightDic stringForKey:@"name"] length]>0) {
        if([[heightAndWeightDic stringForKey:@"height"] length]>0)
        {
            if ([[heightAndWeightDic stringForKey:@"weight"]length]>0) {
                [heightAndWeightDic setObject:[SelfPersonInfo shareInstance].userModel.user_phone forKey:@"phone"];
                [heightAndWeightDic setObject:@(1) forKey:@"is_index"];
                [HttpRequestTool uploadMostImageWithURLString:[NSString stringWithFormat:@"%@/web/cc/cameraAndroidUpload_new", URL_HEADURL] parameters:heightAndWeightDic uploadDatas:@[] success:^{
                    [self alertViewShowOfTime:@"上传成功" time:1];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadAddress" object:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                } failure:^(NSError *error) {
                    //                        WCLLog(@"%@",error);
                }];
                
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
        centerLabel.text = @"若无法完成拍照，请与客服确认型体数据";
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
        [cell.nameTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEnd];
        [cell.weightTextField addTarget:self action:@selector(weighttextfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.weightTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEnd];
        [cell.heightTextField addTarget:self action:@selector(weighttextfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.heightTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEnd];
        
        reCell= cell;
        
    }
    else if (indexPath.section==1)
    {
        PaiZhaoTestCell * cell = [tableView dequeueReusableCellWithIdentifier:@"paizhaotests"];
        if (!cell) {
            cell = [[PaiZhaoTestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paizhaotests"];
        }
        [cell.photoImageView setImage:[UIImage imageNamed:@"xiangji"] forState:UIControlStateNormal];
        cell.shuomingLabel.text = @"系统会自动对脸部进行模糊处理";
        
        [cell.photoImageView addTarget:self action:@selector(xiangji:) forControlEvents:UIControlEventTouchUpInside];
        reCell= cell;
    }
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}
-(void)weighttextfieldDidChange:(UITextField *)textField
{
    if (textField.text.length>0) {
        if (textField.tag==990) {
            [heightAndWeightDic setObject:textField.text forKey:@"name"];
        }
        if (textField.tag==991) {
            CGFloat maxLength = 3;
            NSString *toBeString = textField.text;
            
            //获取高亮部分
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position || !selectedRange)
            {
                if (toBeString.length > maxLength)
                {
                    NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
                    if (rangeIndex.length == 1)
                    {
                        textField.text = [toBeString substringToIndex:maxLength];
                    }
                    else
                    {
                        NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                        textField.text = [toBeString substringWithRange:rangeRange];
                    }
                }
            }
            [heightAndWeightDic setObject:textField.text forKey:@"height"];
        }
        else if (textField.tag==992)
        {
            CGFloat maxLength = 3;
            NSString *toBeString = textField.text;
            
            //获取高亮部分
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position || !selectedRange)
            {
                if (toBeString.length > maxLength)
                {
                    NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
                    if (rangeIndex.length == 1)
                    {
                        textField.text = [toBeString substringToIndex:maxLength];
                    }
                    else
                    {
                        NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                        textField.text = [toBeString substringWithRange:rangeRange];
                    }
                }
            }
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
-(void)showMyMessage:(NSString*)aInfo {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:aInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag ==990) {
        return YES;
    }
    else
    {
        if ([textField.text rangeOfString:@"."].location == NSNotFound)
        {
            _isHaveDian = NO;
        }
        if ([string length] > 0)
        {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
            {
                //首字母不能为0和小数点
                if([textField.text length] == 0)
                {
                    
                    if(single == '.')
                    {
                        
                        [self showMyMessage:@"亲，第一个数字不能为小数点!"];
                        
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        
                        return NO;
                        
                    }
                    
                    if (single == '0')
                    {
                        
                        [self showMyMessage:@"亲，第一个数字不能为0!"];
                        
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        
                        return NO;
                        
                    }
                    
                }
                
                //输入的字符是否是小数点
                
                if (single == '.')
                {
                    
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        
                        _isHaveDian = YES;
                        
                        return YES;
                        
                    }else{
                        
                        [self showMyMessage:@"亲，您已经输入过小数点了!"];
                        
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        
                        return NO;
                        
                    }
                    
                }else{
                    
                    if (_isHaveDian) {//存在小数点
                        
                        //判断小数点的位数
                        
                        NSRange ran = [textField.text rangeOfString:@"."];
                        
                        if (range.location - ran.location <= 2) {
                            
                            return YES;
                            
                        }else{
                            
                            [self showMyMessage:@"亲，您最多输入两位小数!"];
                            
                            return NO;
                            
                        }
                        
                    }else{
                        
                        return YES;
                        
                    }
                    
                }
                
            }else{//输入的数据格式不正确
                
                [self showMyMessage:@"亲，您输入的格式不正确!"];
                
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                
                return NO;
                
            }
            
        }
        
        else
            
        {
            
            return YES;
            
        }
    }
    return YES;
}
-(void)xiangji:(UIButton*)btn
{
    [heightAndWeightDic setObject:[SelfPersonInfo shareInstance].userModel.user_phone forKey:@"phone"];
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
