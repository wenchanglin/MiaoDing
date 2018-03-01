//
//  TakePhotosView.h
//  SmartCityBusiness
//
//  Created by Eric Che on 12/2/14.
//  Copyright (c) 2014 Eric Che. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSInteger (^UICollectionViewnumberOfItemsInSectionBlock)(UICollectionView *collectionView, NSInteger section);
typedef UICollectionViewCell* (^UICollectionViewcellForItemAtIndexPathBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
typedef void (^UICollectionViewDidSelectItemAtIndexPathBlcok)(UICollectionView *collectionView,NSIndexPath *indexPath);
typedef void(^ActionSheetClickedAtIndexBlock)(UIActionSheet *actionSheet, NSInteger index);
@interface TakePhotosView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSInteger times;
}
@property(assign,nonatomic)UICollectionViewnumberOfItemsInSectionBlock collectionViewnumberOfItemsInSectionBlock;
@property(assign,nonatomic)UICollectionViewcellForItemAtIndexPathBlock collectionViewcellForItemAtIndexPathBlock;
@property(assign,nonatomic)UICollectionViewDidSelectItemAtIndexPathBlcok collectionViewDidSelectItemAtIndexPathBlcok;
@property(assign,nonatomic)ActionSheetClickedAtIndexBlock actionSheetClickedAtIndexBlock;
@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property(retain,nonatomic)NSMutableArray *photosArr;
@property (retain, nonatomic) IBOutlet UIButton *takePhotoButton;

@property (retain, nonatomic) IBOutlet UILabel *photoCountLb;
@property(nonatomic,assign)NSInteger maxPhotosCount;
-(void)setUpPhotos:(NSArray*)photos setMaxCount:(NSInteger)maxCount;
-(void)reloadPhotos;
@end






