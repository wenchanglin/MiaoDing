//
//  MianLiaoCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/11.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "MianLiaoCell.h"
#import "colorChooseCollectionViewCell.h"
#import "newDiyMianLiaoModel.h"
@implementation MianLiaoCell

{
    UICollectionView *mianliao;
    NSInteger flog;
    UIImageView * bigImageView;
    UIWindow * window;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        flog = 0;
        
        [self setUp];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [mianliao reloadData];
}

-(void)setUp
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //  [flowLayout setMinimumLineSpacing:15];
    //  [flowLayout setMinimumInteritemSpacing:43];
    //  flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    mianliao = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -10, SCREEN_WIDTH,  (SCREEN_WIDTH - 60) / 4+35) collectionViewLayout:flowLayout];
    //设置代理
    mianliao.delegate = self;
    mianliao.dataSource = self;
    [self.contentView addSubview:mianliao];
    mianliao.backgroundColor = [UIColor whiteColor];
    mianliao.showsHorizontalScrollIndicator = NO;
    //注册cell和ReusableView（相当于头部）
    [mianliao registerClass:[colorChooseCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [mianliao registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_mianLiaoArray count];
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
    newDiyMianLiaoModel*model = _mianLiaoArray[indexPath.item];
    colorChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell.colorImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.img]]];
    cell.bigImage.tag = indexPath.item +2000;
    [cell.bigImage addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bigImage addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchDown];
    NSString * string1 = model.name;
    NSString * string2;
    if (string1.length>4) {
        string2 = [string1 substringWithRange:NSMakeRange(0, 4)];
        [cell.colorName setText:string2];

    }
    else
    {
        [cell.colorName setText:string1];

    }
    if (indexPath.item == flog) {
        [cell.colorChoose setHidden:NO];
        [cell.colorChoose setImage:[UIImage imageNamed:@"JuXC"]];
    } else {
        [cell.colorChoose setHidden:YES];
    }
    [cell sizeToFit];
    return cell;
}
-(void)up:(UIButton *)btn
{
   
    flog =btn.tag-2000;
    [mianliao reloadData];
    for (UIView * view in window.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    [window removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(mianLiaoClick:)]) {
        [_delegate mianLiaoClick:flog];
    }
//    WCLLog(@"你点击了一下");
}
-(void)down:(UIButton *)btn
{
    window= [UIApplication sharedApplication].keyWindow;
    bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-110, 128, 220, 220)];
    newDiyMianLiaoModel*model = _mianLiaoArray[btn.tag-2000];

    [bigImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.img]]];
    [window addSubview:bigImageView];
//    WCLLog(@"你按下了我");
    
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((SCREEN_WIDTH - 60) / 4+10,(SCREEN_WIDTH - 60) / 4+20);
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
//    flog = indexPath.item;
//    [mianliao reloadData];
//    if ([_delegate respondsToSelector:@selector(mianLiaoClick:)]) {
//        [_delegate mianLiaoClick:indexPath.item];
//    }
}

@end
