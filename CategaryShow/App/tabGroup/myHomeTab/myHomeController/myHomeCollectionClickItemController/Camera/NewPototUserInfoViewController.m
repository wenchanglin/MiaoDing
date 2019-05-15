//
//  NewPototUserInfoViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/7/18.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "NewPototUserInfoViewController.h"
#import "NewPhotoInfoTableViewCell.h"
#import "tablePhotoViewController.h"
@interface NewPototUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource,NewPhotoInfoTableViewCellDelegate>

@end

@implementation NewPototUserInfoViewController
{
    UITableView *infoTable;
    NSMutableArray *titleArray;
    NSMutableDictionary* params;
    NSArray *keyType;
    NSMutableDictionary * dic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"用户信息"];
    dic = [NSMutableDictionary dictionary];
    
    params = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];
    titleArray = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:@"姓   名：", @"手机号：",@"身   高：",@"体   重：", nil],[NSArray arrayWithObjects:@"店铺号：", @"胸   围：",@"腰   围：",@"臀   围：", nil], nil];
    if (@available(iOS 11.0, *)) {
        infoTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = YES;
    
    
    
    
    [self CreateTableViewForInfo];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar =NO;
}
-(void)CreateTableViewForInfo
{
    infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-74:SCREEN_HEIGHT - 64 - 49)];
    
    infoTable.dataSource = self;
    infoTable.delegate = self;
    [self.view addSubview:infoTable];
    [infoTable setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];
    [infoTable registerClass:[NewPhotoInfoTableViewCell class] forCellReuseIdentifier:@"infoUser"];
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingAction)];
    //    [infoTable addGestureRecognizer:tap];
    
    UIButton *buttonTake = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-74-64:SCREEN_HEIGHT -64- 49, SCREEN_WIDTH, 49)];
    [buttonTake setBackgroundColor:getUIColor(Color_TKClolor)];
    [buttonTake.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [buttonTake addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [buttonTake setTitle:@"立即拍照" forState:UIControlStateNormal];
    [self.view addSubview:buttonTake];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
    [titleSection setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_tap:)];
    titleSection.tag = 900 + section;
    [titleSection addGestureRecognizer:tap];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 160, 42)];
    //    titleLabel.backgroundColor = [UIColor blueColor];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    UILabel * rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-200-12, 0, 200, 42)];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = [UIColor colorWithHexString:@"#A6A6A6"];
    rightLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:13];
    [titleSection addSubview:rightLabel];
    [titleSection addSubview:titleLabel];
    UIButton * jiantouBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-27, 17, 14, 10)];
    if(section==0)
    {
        [titleLabel setText:@"基本信息"];
        rightLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame)-55, 0, 250, 42);
        rightLabel.textAlignment = NSTextAlignmentLeft;
        rightLabel.textColor = [UIColor colorWithHexString:@"#B10909"];
        rightLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:10];
        rightLabel.text = @"为了确保衣服合身，请准确输入你的净身高、净体重";
    }
    else if (section==1)
    {
        [titleLabel setText:@"选填信息"];
        [titleSection addSubview:jiantouBtn];
        
        //        rightLabel.text = @"⊙帮助";
    }
    if([dic[@"1"] integerValue]==1)
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
    
    if (tap.view.tag ==901) {
        NSString *str = [NSString stringWithFormat:@"%ld",tap.view.tag-900];
        if ([dic[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
            [dic setObject:@"1" forKey:str];
        }else{//反之关闭cell
            [dic setObject:@"0" forKey:str];
        }
        [infoTable reloadData];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        NSString *string = [NSString stringWithFormat:@"%ld",section];
        if ([dic[string] integerValue] == 1 ) {  //打开cell返回数组的count
            return  [[titleArray objectAtIndex:section] count];
        }else{
            return 0;
        }
    }
    return [[titleArray objectAtIndex:section] count];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 0.01;
    }
    return 9;
}
- (void)textFieldDidChange:(UITextField*)sender
{
    if (sender.text.length > 11)  // MAXLENGTH为最大字数
    {
        sender.text = [sender.text substringToIndex: 11]; // MAXLENGTH为最大字数
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewPhotoInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoUser" forIndexPath:indexPath];
    cell.delegate = self;
    [cell.titleLabel setText:[[titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    if (indexPath.section == 0) {
        [cell.detailText setPlaceholder:@"请输入必填项"];
        if(indexPath.row==1)
        {
            [cell.detailText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        if (indexPath.row == 2) {
            [cell.unitLabel setHidden:NO];
            [cell.unitLabel setText:@"cm"];
            
        } else if(indexPath.row == 3){
            [cell.unitLabel setHidden:NO];
            [cell.unitLabel setText:@"kg"];
        } else {
            [cell.unitLabel setHidden:YES];
        }
        
    } else {
        [cell.detailText setPlaceholder:@"请输入非必填项"];
        if (indexPath.row == 0) {
            [cell.unitLabel setHidden:YES];
            
            
        } else{
            [cell.unitLabel setHidden:NO];
            [cell.unitLabel setText:@"cm"];
        }
        
    }
    
    
    cell.tag = indexPath.section * 5 + indexPath.row + 1;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    //    [titleView setBackgroundColor:getUIColor(Color_saveColor)];
    
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 12, 35)];
    //    [label setTextColor:[UIColor lightGrayColor]];
    //    if (section == 0) {
    //        [label setText:@"以上为必填信息"];
    //    } else {
    //        [label setText:@"以上为非必填信息"];
    //    }
    //    [label setFont:[UIFont systemFontOfSize:12]];
    //    [label setTextAlignment:NSTextAlignmentRight];
    //
    //    [titleView addSubview:label];
    
    
    return titleView;
}

-(void)textDetail:(NSString *)detail :(NSInteger)index
{
    NSInteger section = (index - 1) / 5;
    NSInteger row = (index - 1) % 5;
    
    if (section == 0) {
        switch (row) {
            case 0:
                [params setObject:detail forKey:@"name"];
                
                break;
            case 1:
                [params setObject:detail forKey:@"sh_phone"];
                break;
            case 2:
                [params setObject:detail forKey:@"height"];
                
                break;
            case 3:
                [params setObject:detail forKey:@"weight"];
                
                break;
                
                
            default:
                break;
        }
    } else {
        switch (row) {
            case 0:
                [params setObject:detail forKey:@"factory_id"];
                
                break;
            case 1:
                [params setObject:detail forKey:@"xw"];
                
                break;
            case 2:
                [params setObject:detail forKey:@"yw"];
                
                break;
            case 3:
                [params setObject:detail forKey:@"tw"];
                
                break;
                
            default:
                break;
        }
    }
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188 198
     * 联通：130 131 132 145 155 156 166 171 175 176 185 186
     * 电信：133 149 153 173 177 180 181 189 199
     * 虚拟运营商: 170
     */
    NSString *target = @"^(0|86|17951)?(13[0-9]|15[012356789]|16[6]|19[89]]|17[01345678]|18[0-9]|14[579])[0-9]{8}$";
    NSPredicate *targetPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", target];
    if ([targetPredicate evaluateWithObject:mobileNum])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void)takePhoto{
    
    if ([[params stringForKey:@"height"] length] > 0 && [[params stringForKey:@"weight"] length] > 0 && [[params stringForKey:@"name"] length] > 0 &&[[params stringForKey:@"sh_phone"] length] > 0) {
        if([self isMobileNumber:[params stringForKey:@"sh_phone"]])
        {
            tablePhotoViewController *takePhoto = [[tablePhotoViewController alloc] init];
            takePhoto.params = params;
            takePhoto.bodyHeight = [[params stringForKey:@"height"] floatValue];
            [self.navigationController pushViewController:takePhoto animated:YES];
        }
        else
        {
            [self alertViewShowOfTime:@"输入的电话号码有问题" time:1];
        }
    } else {
        
        [self alertViewShowOfTime:@"必填项不能为空" time:1];
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
