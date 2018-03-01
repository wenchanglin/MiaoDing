//
//  TakePhotosView.m
//  SmartCityBusiness
//
//  Created by Eric Che on 12/2/14.
//  Copyright (c) 2014 Eric Che. All rights reserved.
//

#import "TakePhotosView.h"
#import "PhotoCollectionViewCell.h"
#import "UIButton+Block.h"
#import <MobileCoreServices/MobileCoreServices.h>

//#import "ResizePhotoViewController.h"
#import "UIImage+Additions.h"
#import "UICliper.h"
#import "UIImageView+Addtions.h"

#define ORIGINAL_MAX_WIDTH 640.0f
@implementation TakePhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)awakeFromNib{
    self.photosArr=[[NSMutableArray alloc]init];
    UINib *photoCell=[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:photoCell forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];

    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    self.photoCountLb.text=[NSString stringWithFormat:@"%lu/%ld",(unsigned long)_photosArr.count,(long)_maxPhotosCount];
    
    __weak TakePhotosView * weakself =self;
    
    [self.takePhotoButton addBlock:^{
        UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:@"选择图片获取方式" delegate:weakself cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
        actionSheet.tag=10010;
        [actionSheet showInView:weakself.window];
    } forControlEvents:UIControlEventTouchUpInside];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photosArr.count;//_photosArr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    
    [cell.imgView setImage:[_photosArr objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:@"这是正要做的" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除？",@"删除？", nil];
    actionSheet.tag=indexPath.row;
    [actionSheet showInView:self];
//    self.collectionViewDidSelectItemAtIndexPathBlcok(collectionView,indexPath);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    SCBAppDelegate *app=(SCBAppDelegate*)[UIApplication sharedApplication].delegate;
    if (_actionSheetClickedAtIndexBlock) {
        self.actionSheetClickedAtIndexBlock(actionSheet,buttonIndex);
    }else{
        if (actionSheet.tag==10010) {
            if (buttonIndex==2) {
                return;
            }
            UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
            if (buttonIndex==0) {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            }else if(buttonIndex==1){
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            
            
            imagePickerController.delegate=self;
            [self.window addSubview:imagePickerController.view];
//            [app.drawerController presentViewController:imagePickerController animated:YES completion:^{}];
            
        }else{
            if (buttonIndex==2) {
                return;
            }
            [self.photosArr removeObjectAtIndex:actionSheet.tag];
            [self reloadPhotos];
        }
    }
    
}
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    
//}
-(void)setUpPhotos:(NSArray*)photos setMaxCount:(NSInteger)maxCount{
    if (photos) {
        [self.photosArr addObjectsFromArray:photos];
    }
    self.maxPhotosCount=maxCount;
    [self reloadPhotos];
}
-(void)reloadPhotos{
    if (_photosArr&&_photosArr.count>0) {
        self.photoCountLb.text=[NSString stringWithFormat:@"%lu/%ld",(unsigned long)_photosArr.count,(long)_maxPhotosCount];
    }
    [self.collectionView reloadData];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    times=1;
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSLog(@"img is %f  %f",portraitImg.size.width,portraitImg.size.height);
    
    UIView *maskView=[[UIView alloc]initWithFrame:picker.view.bounds];
    [maskView setBackgroundColor:[UIColor blackColor]];
    [picker.view addSubview:maskView];
    CGSize imgSize=portraitImg.size;
    
    float bbb=imgSize.height*(self.window.bounds.size.width/imgSize.width);
    UIImage *tmpImg=[portraitImg imageByScalingToSize:CGSizeMake(self.window.bounds.size.width, bbb)];
    NSLog(@"imgWidth is %f",tmpImg.size.height);
    UIImageView *imageView=[[UIImageView alloc]initWithImage:portraitImg];
    [imageView setFrame:CGRectMake(0, 0, tmpImg.size.width, tmpImg.size.height)];
    
    [imageView setTag:10010];
    
    
    [maskView addSubview:imageView];
    UICliper *cliper=[[UICliper alloc]initWithImageView:imageView];
    [cliper setclipEDGE:CGRectMake(imageView.frame.size.width/2.0-100, imageView.frame.size.height/2.0-100, 200, 200)];
    
    
    [imageView setCenter:maskView.center];
    [imageView addSubview:cliper];
    
    
    UIButton *cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setFrame:CGRectMake(10, maskView.frame.size.height-30, 60, 30)];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [maskView addSubview:cancleButton];
    [cancleButton addBlock:^{
        
        [maskView removeFromSuperview];
        [picker.view removeFromSuperview];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rotationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rotationButton setFrame:CGRectMake(0, 0, 60, 30)];
    [rotationButton setTitle:@"旋转" forState:UIControlStateNormal];
    [maskView addSubview:rotationButton];
    rotationButton.center=CGPointMake(maskView.center.x, cancleButton.center.y);
    [rotationButton addBlock:^{
        [[maskView viewWithTag:10010]removeFromSuperview];
        
        
        
        UIImage *newImg=[portraitImg imageRotatedByDegrees:90*times];
        times++;
        CGSize imgSize1=newImg.size;
        
        float bbb=imgSize1.height*(self.window.bounds.size.width/imgSize1.width);
        UIImage *tmpImg1=[newImg imageByScalingToSize:CGSizeMake(self.window.bounds.size.width, bbb)];
        UIImageView *imageView=[[UIImageView alloc]initWithImage:tmpImg1];
        [imageView setFrame:CGRectMake(0, 0, tmpImg1.size.width, tmpImg1.size.height)];
        [imageView setImage:tmpImg1];
        [imageView setTag:10010];
        UICliper *cliper=[[UICliper alloc]initWithImageView:imageView];
        [cliper setclipEDGE:CGRectMake(imageView.frame.size.width/2.0-100, imageView.frame.size.height/2.0-100, 200, 200)];
        
        
        [imageView setCenter:maskView.center];
        [imageView addSubview:cliper];
        [maskView addSubview:imageView];
        //            [UIView animateWithDuration:1 animations:^{
        //
        //
        ////                [imageView setImage:newImg];
        //            } completion:^(BOOL finished) {
        //
        //                if (finished)
        //                {
        //
        //                }
        //            }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *comfirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [comfirmButton setFrame:CGRectMake(maskView.frame.size.width-70, maskView.frame.size.height-30, 60, 30)];
    [comfirmButton setTitle:@"选中" forState:UIControlStateNormal];
    [maskView addSubview:comfirmButton];
    [comfirmButton addBlock:^{
        
        
        [self.photosArr addObject:[cliper getClipImageRect:[cliper getclipRect]]];
        [self reloadPhotos];
        [maskView removeFromSuperview];
        [picker.view removeFromSuperview];
    } forControlEvents:UIControlEventTouchUpInside];
    
//    [picker dismissViewControllerAnimated:YES completion:^() {
//
//
//
//
//    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.view removeFromSuperview];
//    [picker dismissViewControllerAnimated:YES completion:^(){
//    }];
}


@end
