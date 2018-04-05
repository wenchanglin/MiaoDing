//
//  commentViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/9.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "commentViewController.h"
#import "PhotoCollectionViewCell.h"
#import "TZImagePickerController.h"
@interface commentViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,TZImagePickerControllerDelegate,UITextViewDelegate>

@end

@implementation commentViewController
{
    UICollectionView *collectionV;
    NSMutableArray *photoArrayM;
    NSMutableArray *selectedAssets;
    NSString *photoProjectInfo;
    
    
    NSMutableDictionary *params;
    
    BaseDomain *postData;
    NSTimer *timer;
    UIAlertView *alert;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    photoProjectInfo = @"";
    postData = [BaseDomain getInstance:NO];
    params = [NSMutableDictionary dictionary];
    selectedAssets = [NSMutableArray array];
    photoArrayM  = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"addPicture"], nil];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self settabTitle:@"发表评价"];
    [self createView];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)createView
{
    
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    backView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    .heightIs(500)
    .widthIs(340);
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.masksToBounds = NO;
    [[backView layer] setShadowOffset:CGSizeMake(0, 3)]; // 阴影的范围
    [[backView layer] setShadowRadius:3];                // 阴影扩散的范围控制
    [[backView layer] setShadowOpacity:0.5];               // 阴影透明度
    [[backView layer] setShadowColor:[UIColor grayColor].CGColor];
    
    UIImageView *headCircle = [UIImageView new];
    [backView addSubview:headCircle];
    headCircle.sd_layout
    .centerXEqualToView(backView)
    .topSpaceToView(backView, 40)
    .heightIs(86)
    .widthIs(86);
    [headCircle.layer setCornerRadius:43];
    [headCircle.layer setMasksToBounds:YES];
    [headCircle setImage:[UIImage imageNamed:@"commendCircel"]];
    
    
    UIImageView *headImg = [UIImageView new];
    [backView addSubview:headImg];
    
    headImg.sd_layout
    .centerXEqualToView(headCircle)
    .centerYEqualToView(headCircle)
    .heightIs(80)
    .widthIs(80);
    [headImg.layer setCornerRadius:40];
    [headImg.layer setMasksToBounds:YES];
    [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_goodsDic stringForKey:@"goods_thumb"]]]];
    
    
    UILabel *clothName = [UILabel new];
    [backView addSubview:clothName];
    clothName.sd_layout
    .topSpaceToView(headCircle, 15)
    .centerXEqualToView(backView)
    .heightIs(25)
    .widthIs(200);
    [clothName setFont:Font_16];
    [clothName setText:[_goodsDic stringForKey:@"goods_name"]];
    [clothName setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *labelPL = [UILabel new];
    [backView addSubview:labelPL];
    labelPL.sd_layout
    .topSpaceToView(clothName, 65)
    .centerXEqualToView(backView)
    .heightIs(20)
    .widthIs(200);
    [labelPL setText:@"- 评价内容 -"];
    [labelPL setFont:Font_14];
    [labelPL setTextAlignment:NSTextAlignmentCenter];
    
    
    UIView *commendView = [UIView new];
    [backView addSubview:commendView];
    commendView.sd_layout
    .centerXEqualToView(backView)
    .topSpaceToView(labelPL, 12)
    .heightIs(130)
    .leftSpaceToView(backView, 10)
    .rightSpaceToView(backView, 10);
    [commendView.layer setBorderWidth:1];
    [commendView.layer setBorderColor:getUIColor(Color_circle).CGColor];
    
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    [flowL setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置每一个item的大小
    flowL.itemSize = CGSizeMake(50 , 50 );
    flowL.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    //列
    flowL.minimumInteritemSpacing = 10;
    //行
    flowL.minimumLineSpacing = 10;
    //创建集合视图
    collectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowL];
    collectionV.backgroundColor = [UIColor whiteColor];
    // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 5);
    collectionV.delegate = self;
    collectionV.dataSource = self;
    //添加集合视图
    [commendView addSubview:collectionV];
    collectionV.sd_layout
    .leftSpaceToView(commendView, 10)
    .heightIs(80)
    .bottomEqualToView(commendView)
    .rightSpaceToView(commendView, 10);
    //注册对应的cell
    [collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    UITextView *textView = [UITextView new];
    [commendView addSubview:textView];
    textView.sd_layout
    .leftSpaceToView(commendView, 20)
    .rightSpaceToView(commendView, 20)
    .topSpaceToView(commendView, 10)
    .bottomSpaceToView(collectionV, 0);
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeyDone;
    
    UIButton *button = [UIButton new];
    [backView addSubview:button];
    button.sd_layout
    .centerXEqualToView(backView)
    .bottomSpaceToView(backView, 38)
    .widthIs(120)
    .heightIs(40);
    [button setTitle:@"提交评价" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button setBackgroundColor:[UIColor blackColor]];
    [button.layer setCornerRadius:3];
    [button.layer setMasksToBounds:YES];
    
    [button addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)commentClick
{
    if ([[params stringForKey:@"content"] length] < 15) {
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入不少于15个字的评价" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cantComm) userInfo:nil repeats:NO];
    } else {
        [params setObject:_orderId forKey:@"order_id"];
        if (![photoProjectInfo isEqualToString:@""]) {
            [params setObject:photoProjectInfo forKey:@"img_list"];
        }
        
        [params setObject:[_goodsDic stringForKey:@"goods_id"] forKey:@"goods_id"];
        [params setObject:[_goodsDic stringForKey:@"id"] forKey:@"car_id"];
        
        [postData postData:URL_AddCommend PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                
                alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评价成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myLog) userInfo:nil repeats:NO];
                
                
            }
            
        }];
    }
    
    
}

-(void)cantComm
{
    if (timer.isValid) {
        [timer invalidate];
    }
    timer=nil;
    [alert dismissWithClickedButtonIndex:0 animated:YES];

}
-(void)myLog
{
    
    if (timer.isValid) {
        [timer invalidate];
    }
    timer=nil;
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"commentSuccess" object:nil];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [params setObject:textView.text forKey:@"content"];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [UIView commitAnimations];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [UIView commitAnimations];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [photoArrayM count];
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setBackgroundColor:getUIColor(Color_background)];
    cell.photoV.image = photoArrayM[indexPath.item];
    if (indexPath.row == [photoArrayM count] - 1) {
        [cell.photoV setContentMode:UIViewContentModeCenter];
    } else {
        [cell.photoV setContentMode:UIViewContentModeScaleAspectFit];
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == [photoArrayM count] - 1) {
        [self collectionAddClick];
    }
}

-(void)collectionAddClick
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 columnNumber:5 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = selectedAssets;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    photoProjectInfo = @"";
    
    
    [photoArrayM removeAllObjects];
    for (UIImage *img in photos) {
        [photoArrayM addObject:img];
    }
    [photoArrayM addObject:[UIImage imageNamed:@"addPicture"]];
    
    
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
    
    
    
    [collectionV reloadData];
    
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //    [self.btn setImage:image forState:UIControlStateNormal];
    [photoArrayM insertObject:image atIndex:[photoArrayM count] - 1];
    [collectionV reloadData];
    
    
    NSData * imageData = UIImageJPEGRepresentation(image, 0.3);
    
    NSString * base64 = [imageData base64EncodedStringWithOptions:kNilOptions];
    
    
    if ([photoProjectInfo length] > 0) {
        photoProjectInfo = [NSString stringWithFormat:@"%@,%@",photoProjectInfo,base64];
    } else {
        photoProjectInfo = base64;
    }
    
    
    
    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
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
