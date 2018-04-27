//
//  myHomeSetViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/8.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "myHomeSetViewController.h"
#import "addressSetFirstViewViewController.h"
#import "MyHomeSetTableViewCell.h"
#import "HomeSetForHeadImageTableViewCell.h"
#import "UIViewController+XHPhoto.h"
#import "userInfoModel.h"
#import "AboutCloudFactoryViewController.h"
#import "AppDelegate.h"
#import "LTSDateChoose.h"
#import "DateForBodyViewController.h"
#import "SuggestViewController.h"
#import "LiangTiSureViewController.h"
@interface myHomeSetViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, LTSDateChooseDelegate>
@property (nonatomic, retain) userInfoModel *userInfo;
@end

@implementation myHomeSetViewController
{
    NSArray *arrayTitle;
    UITableView *setTable;
    BaseDomain *postData;
    //    AwAlertView *alertView;
    UITextField *nickName;
    BaseDomain *getData;
    UIView *nickBgName;
    UIImageView *alphaImage;
    NSString *birthday;
    NSString *age;
    UIDatePicker *datePick;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"设置"];
    if (@available(iOS 11.0, *)) {
        setTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    postData = [BaseDomain getInstance:NO];
    getData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSArray *array = [NSArray arrayWithObjects:@"头像",@"昵称",@"年龄", nil];
    arrayTitle = [NSArray arrayWithObjects:array,@"量体数据", @"收货地址", @"清除缓存",@"帮助与反馈", @"关于妙定", nil];
    [self createTable];
    [self createNickName];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)createTable
{
   
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,IsiPhoneX?SCREEN_HEIGHT-88-74:SCREEN_HEIGHT - 64-49) style:UITableViewStyleGrouped];
    [setTable setSeparatorColor :[UIColor colorWithHexString:@"#EDEDED"]];
    setTable.dataSource = self;
    setTable.delegate = self;
    [setTable registerClass:[MyHomeSetTableViewCell class] forCellReuseIdentifier:@"setList"];
    [setTable registerClass:[HomeSetForHeadImageTableViewCell class] forCellReuseIdentifier:@"setImage"];
    [self.view addSubview:setTable];
    
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,IsiPhoneX?SCREEN_HEIGHT-88-74:SCREEN_HEIGHT-64- 49, SCREEN_WIDTH, 49)];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    [button setBackgroundColor:[UIColor colorWithHexString:@"#151515"]];
    [button addTarget:self action:@selector(exitLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)exitLoginClick
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    [params setValue:[userd stringForKey:@"cId"] forKey:@"device_id"];
    [getData getData:URL_ExitLogin PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"exitLogin" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [self.userInfo saveLoginData:@"" userImg:@""];
            NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
            [userd setObject:@"" forKey:@"token"];
        }
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayTitle count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 92;
    }
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *reCell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HomeSetForHeadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setImage" forIndexPath:indexPath];
            [cell.titleLabel setText:[[arrayTitle objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            if ([[SelfPersonInfo getInstance].personImageUrl hasPrefix:@"http"]) {
                 [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[SelfPersonInfo getInstance].personImageUrl] placeholderImage:[UIImage imageNamed:@"headImage"]];
            }
            else
            {
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [SelfPersonInfo getInstance].personImageUrl]] placeholderImage:[UIImage imageNamed:@"headImage"]];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            reCell = cell;
            
        } else {
            MyHomeSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setList" forIndexPath:indexPath];
            [cell.titleLabel setText:[[arrayTitle objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if (indexPath.row == 1) {
                [cell.detaiLabel setText:[SelfPersonInfo getInstance].cnPersonUserName];
            } else {
                [cell.detaiLabel setText:[SelfPersonInfo getInstance].personAge];
            }
            
            
            reCell = cell;
        }
        
    } else {
        MyHomeSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setList" forIndexPath:indexPath];
        [cell.titleLabel setText:[arrayTitle objectAtIndex:indexPath.section]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ([[arrayTitle objectAtIndex:indexPath.section] isEqualToString:@"清除缓存"]) {
            [cell.detaiLabel setText:[NSString stringWithFormat:@"%.2fM", [self filePath]  / 2]];
        }
    
        reCell = cell;
    }
    
    
    
    return reCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                [self showCanEdit:YES photo:^(UIImage *photo) {
                    
                    NSData * imageData = UIImageJPEGRepresentation(photo, 0.7);
                    
                    NSString * base64 = [imageData base64EncodedStringWithOptions:kNilOptions];
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setObject:base64 forKey:@"avatar"];
                    
                    [postData postData:URL_UpdateUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                        
                        if ([self checkHttpResponseResultStatus:postData]) {
                            [SelfPersonInfo getInstance].personImageUrl = [[domain.dataRoot objectForKey:@"data"] stringForKey:@"avatar"];
                            
                            [setTable reloadData];
                            
                        }
                        
                    }];
                    
                }];
                
            } else if(indexPath.row == 1){
                
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.4];
                [alphaImage setAlpha:1];
                [UIView commitAnimations];
                
            } else {
                LTSDateChoose *dateChoose =  [[LTSDateChoose alloc]initWithType:UIDatePickerModeDate title:@"日期选择"];
                
                [dateChoose setNowTime:[NSDate date]];
                
                dateChoose.delegate = self;
                
                [dateChoose showWithAnimation:YES];
                
                
            }
            
            
        }
            
            
            
            
            break;
        case 1:
        {
//            DateForBodyViewController *dateBD = [[DateForBodyViewController alloc] init];
            LiangTiSureViewController* dateBD = [[LiangTiSureViewController alloc]init];
            dateBD.comefromwode = YES;
            [self.navigationController pushViewController:dateBD animated:YES];
            
        }
            break;
        case 2:
        {
            addressSetFirstViewViewController *address = [[addressSetFirstViewViewController alloc] init];
            [self.navigationController pushViewController:address animated:YES];
            
        }
            break;
        case 3:
            [self clearFile];
            break;
            
        case 4:
        {
            SuggestViewController *suggest = [[SuggestViewController alloc] init];
            [self.navigationController pushViewController:suggest animated:YES];
        }
            break;
        case 5:
        {
            AboutCloudFactoryViewController *about = [[AboutCloudFactoryViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
            
            
            break;
        default:
            break;
    }
}


- (void)determine:(LTSDateChoose *)choose date:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval time=[currentDate timeIntervalSinceDate:date];
    CGFloat ageTime  = (CGFloat)time / 3600 / 24 / 365;
    
    age = [NSString stringWithFormat:@"%.f", ageTime];
    
    birthday  = [self stringFromDate:date];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:birthday forKey:@"birthday"];
    [params setObject:age forKey:@"age"];
    [postData postData:URL_UpdateUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:postData]) {
            [SelfPersonInfo getInstance].personBirthday = birthday;
            [SelfPersonInfo getInstance].personAge = age;
            [setTable reloadData];
        }
        
    }];
}

- (NSString*)stringFromDate:(NSDate*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}
-(void)createNickName
{
    
    //    [setTable setAlpha:0];
    
    alphaImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAlpha)];
    [alphaImage addGestureRecognizer:tap];
    [alphaImage setImage:[UIImage imageNamed:@"BGALPHA"]];
    [[AppDelegate getInstance].window addSubview:alphaImage];
    [alphaImage setAlpha:0];
    [alphaImage setUserInteractionEnabled:YES];
    
    nickBgName = [UIView new];
    [alphaImage addSubview:nickBgName];
    
    nickBgName.sd_layout
    .centerXEqualToView(alphaImage)
    .centerYEqualToView(alphaImage)
    .widthIs(SCREEN_WIDTH - 60)
    .heightIs(160);
    [nickBgName.layer setCornerRadius:1];
    [nickBgName.layer setMasksToBounds:YES];
    [nickBgName setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *label = [UILabel new];
    [nickBgName addSubview:label];
    
    label.sd_layout
    .topSpaceToView(nickBgName,15)
    .rightEqualToView(nickBgName)
    .leftEqualToView(nickBgName)
    .heightIs(30);
    [label setText:@"修改昵称"];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    nickName = [UITextField new];
    [nickBgName addSubview:nickName];
    nickName.sd_layout
    .centerXEqualToView(nickBgName)
    .topSpaceToView(label, 15)
    .widthIs(200)
    .heightIs(40);
    [nickName.layer setCornerRadius:1];
    [nickName.layer setMasksToBounds:YES];
    [nickName.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [nickName.layer setBorderWidth:1];
    [nickName setPlaceholder:@"请输入昵称"];
    [nickName setDelegate:self];
    [nickName setTextAlignment:NSTextAlignmentCenter];
    [nickName setFont:[UIFont systemFontOfSize:14]];
    [nickName setReturnKeyType:UIReturnKeyDone];
    
    
    UIButton *cancelButton = [UIButton new];
    [nickBgName addSubview:cancelButton];
    cancelButton.sd_layout
    .leftSpaceToView(nickBgName, 40)
    .bottomSpaceToView(nickBgName, 5)
    .widthIs(80)
    .heightIs(40);
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:getUIColor(Color_myTabIconTitleColor) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(hiddenAlpha) forControlEvents:UIControlEventTouchUpInside];
    UIButton *doneButton = [UIButton new];
    [nickBgName addSubview:doneButton];
    doneButton.sd_layout
    .rightSpaceToView(nickBgName, 40)
    .bottomSpaceToView(nickBgName, 5)
    .widthIs(80)
    .heightIs(40);
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [doneButton setTitleColor:getUIColor(Color_myTabIconTitleColor) forState:UIControlStateNormal];
    [doneButton setTitle:@"修改" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(updateUserInfo) forControlEvents:UIControlEventTouchUpInside];
}

-(void)hiddenAlpha
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [alphaImage setAlpha:0];
    [UIView commitAnimations];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)updateUserInfo
{
    
    if ([nickName.text length] > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:nickName.text forKey:@"name"];
        
        [postData postData:URL_UpdateUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            
            if ([self checkHttpResponseResultStatus:postData]) {
                [SelfPersonInfo getInstance].cnPersonUserName = nickName.text;
                [nickName resignFirstResponder];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.4];
                [alphaImage setAlpha:0];
                [UIView commitAnimations];
                
                
                [setTable reloadData];
                
            }
            
        }];
    }
    
}


// 显示缓存大小
-( float )filePath
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}




// 清理缓存

- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}
-(void)clearCachSuccess
{
    NSLog ( @" 清理成功 " );
    
    [setTable reloadData];
    
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
