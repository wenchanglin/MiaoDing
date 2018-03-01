//
//  joinDesDetailViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/22.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "joinDesDetailViewController.h"
#import "MeasureLabelAndTextFieldModel.h"
#import "MeasureLabelAndTextField.h"
#import "joinDesTableViewCell.h"
#import "joinDesResultViewController.h"
#import "TZImagePickerController.h"
@interface joinDesDetailViewController ()<UITableViewDelegate, UITableViewDataSource, measureLabelAndTextDelegate, joinDesDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@end

@implementation joinDesDetailViewController
{
    UITableView *applyTable;
    NSMutableArray *modelArray;
    NSMutableArray *photoArray;
    NSString *photoProjectInfo;
    NSString *photoWorkRoom;
    NSInteger flog;
    BaseDomain *postData;
    NSMutableDictionary *params;
    NSMutableArray *selectedAssets;
    NSMutableArray *selectedAssets1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    [lineView setBackgroundColor:getUIColor(Color_background)];
    [self.view addSubview:lineView];
    self.title = @"申请入驻";
    params = [NSMutableDictionary dictionary];
    
    UIImage *image = [UIImage imageNamed:@"add"];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:image, nil];
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:image, nil];
    photoArray  = [NSMutableArray arrayWithObjects:array,array1, nil];
    
    
    
    modelArray = [NSMutableArray array];
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"姓名", @"手机号",@"微信号",@"邮箱", nil];
    
    NSArray *arrayDetail = [NSArray arrayWithObjects:@"请输入您的真实姓名", @"请输入您的手机号码",  @"请输入您的微信号", @"请输入您的常用邮箱", nil];
    
    for (int i = 0; i < [arrayTitle count]; i ++) {
        MeasureLabelAndTextFieldModel *model = [[MeasureLabelAndTextFieldModel alloc] init];
        model.titleName = arrayTitle[i];
        model.placeHolder = arrayDetail[i];
        [modelArray addObject:model];
    }
    [self createTable];
    
    // Do any additional setup after loading the view.
}

-(void)createTable
{
    applyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    applyTable.dataSource = self;
    applyTable.delegate = self;
    [applyTable setBackgroundColor:[UIColor whiteColor]];
    [applyTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    applyTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [applyTable registerClass:[MeasureLabelAndTextField class] forCellReuseIdentifier:NSStringFromClass([MeasureLabelAndTextField class])];
    [applyTable registerClass:[joinDesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([joinDesTableViewCell class])];
    [self.view addSubview:applyTable];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 50, SCREEN_WIDTH - 40, 40)];
    [button setBackgroundColor:getUIColor(Color_measureTableTitle)];
    [self.view addSubview:button];
    [button.layer setCornerRadius:1];
    [button.layer setMasksToBounds:YES];
    [button addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"提交申请" forState:UIControlStateNormal];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSArray *array = [NSArray arrayWithObjects:@"个人信息", @"作品信息", nil];
    
    UIView *bgVie = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [bgVie setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12,0, SCREEN_WIDTH, 40)];
    [label setText:array[section]];
    [label setFont:Font_16];
    [bgVie addSubview:label];
    
    return bgVie;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    } else 
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger re;
    if (section == 0) {
        re = 4;
    } else {
        re = 2;
    }
    return re;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"请上传一组您的作品图片(建议3-4张)", @"请上传一组您在工作室的图片(建议1-2张)", nil];
    if (indexPath.section == 0) {
        MeasureLabelAndTextFieldModel *model = modelArray[indexPath.row];
        Class currentClass = [MeasureLabelAndTextField class];
        MeasureLabelAndTextField *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        cell.model = model;
        cell.delegate = self;
        cell.tag = indexPath.row +5;
        reCell = cell;
    } else {
        

        Class currentClass = [joinDesTableViewCell class];
        joinDesTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        cell.photoArrayM = photoArray[indexPath.row];
        cell.delegate = self;
        cell.tag = indexPath.row + 100;
        [cell.remarkLabel setText:arrayTitle[indexPath.row]];
        [cell.collectionV reloadData];
        reCell = cell;

    }
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(void)collectionClick:(NSInteger)item :(NSInteger)tag
{
    if (tag == 100) {
        if (item == 0) {
            flog = 100;

            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
            imagePickerVc.selectedAssets = selectedAssets;
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        }
    } else if (tag == 101) {
        flog = 101;
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:2 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        imagePickerVc.selectedAssets = selectedAssets1;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    photoProjectInfo = @"";
    photoWorkRoom = @"";
    
    [photoArray[flog - 100] removeObjectsInRange:NSMakeRange(1, [photoArray[flog - 100] count] - 1)];
    for (UIImage *img in photos) {
        [photoArray[flog - 100] addObject:img];
    }
    if (flog == 100) {
        selectedAssets = [NSMutableArray arrayWithArray:assets];
        
        for (UIImage *image in photos) {
            NSData * imageData = UIImageJPEGRepresentation(image, 0.3);
            
            NSString * base64 = [imageData base64EncodedStringWithOptions:kNilOptions];
            
            if ([photoProjectInfo length] > 0) {
                photoProjectInfo = [NSString stringWithFormat:@"%@,%@",photoProjectInfo,base64];
            } else {
                photoProjectInfo = base64;
            }
            
        }
        
        
    } else {
        selectedAssets1 = [NSMutableArray arrayWithArray:assets];
        
        for (UIImage *image in photos) {
            NSData * imageData = UIImageJPEGRepresentation(image, 0.3);
            
            NSString * base64 = [imageData base64EncodedStringWithOptions:kNilOptions];
            
            if ([photoWorkRoom length] > 0) {
                photoWorkRoom = [NSString stringWithFormat:@"%@,%@",photoWorkRoom,base64];
            } else {
                photoWorkRoom = base64;
            }
            
        }
        
        
    }
    
    [applyTable reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //    [self.btn setImage:image forState:UIControlStateNormal];
    [photoArray[flog - 100] addObject:image];
    [applyTable reloadData];
    
    NSData * imageData = UIImageJPEGRepresentation(image, 0.3);
    
    NSString * base64 = [imageData base64EncodedStringWithOptions:kNilOptions];
    
    switch (flog) {
        case 100:
            if ([photoProjectInfo length] > 0) {
                photoProjectInfo = [NSString stringWithFormat:@"%@,%@",photoProjectInfo,base64];
            } else {
                photoProjectInfo = base64;
            }
            break;
        case 101:
            if ([photoWorkRoom length] > 0) {
                photoWorkRoom = [NSString stringWithFormat:@"%@,%@",photoWorkRoom,base64];
            } else {
                photoWorkRoom = base64;
            }
            break;
        default:
            break;
    }
    
    
    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)textDetail:(NSString *)detail :(NSInteger)index
{
    switch (index) {
        case 5:
            [params setObject:detail forKey:@"name"];
            break;
        case 6:
            [params setObject:detail forKey:@"phone"];
            break;
        case 7:
            [params setObject:detail forKeyedSubscript:@"weixin"];
            break;
        case 8:
            [params setObject:detail forKeyedSubscript:@"email"];
            break;
        default:
            break;
    }
}

-(void)applyClick
{
    [postData postData:URL_PostDesignerApply PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:postData]) {
            
            joinDesResultViewController *joinDes = [[joinDesResultViewController alloc] init];
            [self.navigationController pushViewController:joinDes animated:YES];
            
            
        }
    }];
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
