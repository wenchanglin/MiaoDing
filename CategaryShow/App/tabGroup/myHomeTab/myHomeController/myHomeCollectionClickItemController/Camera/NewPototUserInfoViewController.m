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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户信息";
    params = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:getUIColor(Color_background)];
    titleArray = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:@"姓   名：", @"手机号：",@"身   高：",@"体   重：", nil],[NSArray arrayWithObjects:@"店铺号：", @"胸   围：",@"腰   围：",@"臀   围：", nil], nil];
    
    
    
    
    
    
    
    [self CreateTableViewForInfo];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)CreateTableViewForInfo
{
    infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    infoTable.dataSource = self;
    infoTable.delegate = self;
    [self.view addSubview:infoTable];
    [infoTable setBackgroundColor:getUIColor(Color_background)];
    [infoTable registerClass:[NewPhotoInfoTableViewCell class] forCellReuseIdentifier:@"infoUser"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingAction)];
    [infoTable addGestureRecognizer:tap];
    
    UIButton *buttonTake = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)];
    [buttonTake setBackgroundColor:getUIColor(Color_TKClolor)];
    [buttonTake.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [buttonTake addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [buttonTake setTitle:@"立即拍照" forState:UIControlStateNormal];
    [self.view addSubview:buttonTake];
    
}

-(void)endEditingAction
{
    [self.view endEditing:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewPhotoInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoUser" forIndexPath:indexPath];
    cell.delegate = self;
    [cell.titleLabel setText:[[titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    if (indexPath.section == 0) {
        [cell.detailText setPlaceholder:@"请输入必填项"];
        
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
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 12, 35)];
    [label setTextColor:[UIColor lightGrayColor]];
    if (section == 0) {
        [label setText:@"以上为必填信息"];
    } else {
        [label setText:@"以上为非必填信息"];
    }
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentRight];
    
    [titleView addSubview:label];
    
    
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

-(void)takePhoto{
    
    if ([[params stringForKey:@"height"] length] > 0 && [[params stringForKey:@"weight"] length] > 0 && [[params stringForKey:@"name"] length] > 0 &&[[params stringForKey:@"sh_phone"] length] > 0) {
        tablePhotoViewController *takePhoto = [[tablePhotoViewController alloc] init];
        takePhoto.params = params;
        takePhoto.bodyHeight = [[params stringForKey:@"height"] floatValue];
        [self.navigationController pushViewController:takePhoto animated:YES];
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
