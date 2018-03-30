//
//  positionTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "positionTableViewCell.h"
#import "positionCollectionViewCell.h"
@implementation positionTableViewCell
{
    UICollectionView *position;
    NSInteger flog;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        flog = 0;
        _positionArray = [NSMutableArray array];
        [self setUp];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [position reloadData];
}

-(void)setUp
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    [flowLayout setMinimumLineSpacing:15];
//    [flowLayout setMinimumInteritemSpacing:43];
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    position = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH,  (SCREEN_WIDTH - 60) / 4+20) collectionViewLayout:flowLayout];
    
    //设置代理
    position.delegate = self;
    position.dataSource = self;
    [self.contentView addSubview:position];
    position.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    
    
    
    [position registerClass:[positionCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [position registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_positionArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    positionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell.positionImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_positionArray[indexPath.item] stringForKey:@"img"]]]];
    [cell.nameLabel setText:[_positionArray[indexPath.item] stringForKey:@"name"]];
    [cell sizeToFit];
    
    if (indexPath.item == flog) {
        [cell.chooseImage  setImage:[UIImage imageNamed:@"JuXC"]];
    } else {
        [cell.chooseImage  setImage:[UIImage imageNamed:@"JuX"]];
    }
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((SCREEN_WIDTH - 60) / 4+10,(SCREEN_WIDTH - 60)  / 4+20);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0,0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    flog = indexPath.item;
    [position reloadData];
    
    if ([_delegate respondsToSelector:@selector(positionClick:)]) {
        [_delegate positionClick:indexPath.item];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
