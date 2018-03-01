//
//  putInUserInfoViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/13.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "putInUserInfoViewController.h"
#import "cameraUserInfoTableViewCell.h"
#import "MeasureLabelAndTextFieldModel.h"
#import "tablePhotoViewController.h"
#import "takePhotoCollectionViewCell.h"
#import "RDVTabBarController.h"
#import "LodingViewController.h"
@interface putInUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource,cameraUserInfoDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation putInUserInfoViewController
{
    UITableView *userInfoTable;
    NSMutableArray *modelArray;
    NSMutableDictionary *params;
    UICollectionView *photoCollection;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    params = [NSMutableDictionary dictionary];
    modelArray = [NSMutableArray array];
    [self settabTitle:@"用户信息"];
    
    
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"姓名*",@"身高*",@"体重*",@"胸围",@"腰围", @"臀围", nil];
    NSArray *arrayContent = [NSArray arrayWithObjects:@"必填项，输入姓名",@"必填项，输入身高", @"必填项，输入体重", @"非必填项，输入胸围", @"非必填项，输入腰围", @"非必填项，输入臀围", nil];
    NSArray *arrayImg = [NSArray arrayWithObjects:@"name", @"height", @"weight", @"xiongwei", @"yaowei", @"tunwei" ,nil];
    for (int i = 0; i < [arrayTitle count]; i ++) {
        MeasureLabelAndTextFieldModel *model = [MeasureLabelAndTextFieldModel new];
        model.titleName = arrayTitle[i];
        model.placeHolder = arrayContent[i];
        model.backImg = arrayImg[i];
        [modelArray addObject:model];
    }
    
   
    [self createInfoTable];
    
    // Do any additional setup after loading the view.
}




-(void)createInfoTable
{
    
    UILabel *Info = [[UILabel alloc] initWithFrame:CGRectMake(12, 45, SCREEN_WIDTH / 2, 34)];
    [Info setText:@"用户信息"];
    [Info setFont:[UIFont boldSystemFontOfSize:34]];
    [self.view addSubview:Info];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 52, 45, 40, 34)];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button.titleLabel setFont:Font_14];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    userInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT - 83) style:UITableViewStyleGrouped];
    userInfoTable.dataSource = self;
    userInfoTable.delegate = self;
    [userInfoTable setBackgroundColor:[UIColor whiteColor]];
    [userInfoTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [userInfoTable registerClass:[cameraUserInfoTableViewCell class] forCellReuseIdentifier:@"camera"];
    [self.view addSubview:userInfoTable];
}

-(void)closeClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 5) {
        return 150;
    }
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
       return 3;
    } else return 0.0001;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 5) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        UILabel *labelWoring = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 200, 20)];
        [labelWoring setText:@"注:*为必填项"];
        [labelWoring setTextColor:[UIColor blackColor]];
        [labelWoring setFont:[UIFont systemFontOfSize:14]];
        [view addSubview:labelWoring];
        
        UIButton *buttonCamera = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, 33, 60 , 60 )];
        [buttonCamera setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [view addSubview:buttonCamera];
        [buttonCamera addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        return view;
    } else return nil;
    
    
}

-(void)takePhoto{
    
    if ([[params stringForKey:@"height"] length] > 0 && [[params stringForKey:@"weight"] length] > 0) {
        tablePhotoViewController *takePhoto = [[tablePhotoViewController alloc] init];
        takePhoto.params = params;
        takePhoto.bodyHeight = [[params stringForKey:@"height"] floatValue];
        [self.navigationController pushViewController:takePhoto animated:YES];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提醒"
                                                                       message:@"必填项不能为空"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }

    
    
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cameraUserInfoTableViewCell *reCell = [tableView dequeueReusableCellWithIdentifier:@"camera" forIndexPath:indexPath];
    reCell.delegate = self;
    reCell.tag = indexPath.section + 50;
    reCell.model = modelArray[indexPath.section];
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(void)textDetail:(NSString *)detail :(NSInteger)index
{
    switch (index - 50) {
            case 0:
            [params setObject:detail forKeyedSubscript:@"name"];
            
            break;
            case 1:
            [params setObject:detail forKeyedSubscript:@"height"];

            break;
            case 2:
            [params setObject:detail forKeyedSubscript:@"weight"];
            
            break;
            case 3:
            [params setObject:detail forKeyedSubscript:@"xw"];
            
            break;
            case 4:
            [params setObject:detail forKeyedSubscript:@"yw"];
            
            break;
            case 5:
            [params setObject:detail forKeyedSubscript:@"tw"];
            
            break;
            
        default:
            break;
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
