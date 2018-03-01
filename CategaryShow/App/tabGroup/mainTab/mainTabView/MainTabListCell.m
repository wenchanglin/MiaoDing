//
//  MainTabListCell.m
//  CategaryShow
//
//  Created by APPLE on 16/8/23.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MainTabListCell.h"
#import "MainTabModel.h"
#import "lowCollectionViewCell.h"
@implementation MainTabListCell
{
    UILabel *timeLabel;
    
    UIImageView *_imageView;

    UILabel *TitleLabel;
    
    UICollectionView *noThreeCollection;
    
    UILabel *fenLeiLabel;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
    }
    
    return self;
}

-(void)setUp {
    
    UIView *contentView = self.contentView;
    [self setBackgroundColor:[UIColor whiteColor]];
    
    
    
    _imageView = [UIImageView new];
    [self.contentView addSubview:_imageView];
    _imageView.sd_layout
    .topSpaceToView(contentView,0)
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(390 / 2);
    
//    TitleLabel = [UILabel new];
//    [self.contentView addSubview:TitleLabel];
//    TitleLabel.sd_layout
//    .topSpaceToView(contentView,40)
//    .leftEqualToView(contentView)
//    .rightEqualToView(contentView)
//    .heightIs(40);
//    TitleLabel.center = self.contentView.center;
//    TitleLabel.font = [UIFont boldSystemFontOfSize:24];
//    
//    TitleLabel.textColor = [UIColor whiteColor];
//    TitleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    fenLeiLabel = [UILabel new];
//    [self.contentView addSubview:fenLeiLabel];
//    fenLeiLabel.sd_layout
//    .topSpaceToView(TitleLabel,10)
//    .widthIs(80)
//    .centerXEqualToView(contentView)
//    .heightIs(30);
//    [fenLeiLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [fenLeiLabel.layer setBorderWidth:1];
//    
//    fenLeiLabel.font = [UIFont boldSystemFontOfSize:18];
//    fenLeiLabel.textColor = [UIColor whiteColor];
//    fenLeiLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *SJX = [UIImageView new];
    [contentView addSubview:SJX];
    
    SJX.sd_layout
    .topSpaceToView(_imageView,0)
    .centerXEqualToView(_imageView)
    .heightIs(9)
    .widthIs(16);
    [SJX setImage:[UIImage imageNamed:@"DSJ"]];
    

    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    noThreeCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    //设置代理
    noThreeCollection.showsHorizontalScrollIndicator = NO;
    noThreeCollection.delegate = self;
    noThreeCollection.dataSource = self;
    [self.contentView addSubview:noThreeCollection];

    noThreeCollection.sd_layout
    .centerYEqualToView(contentView)
    .centerXEqualToView(contentView)
    .topSpaceToView(_imageView, 10)
    .heightIs(contentView.frame.size.width / 3);

    //注册cell和ReusableView（相当于头部）
    
//    noThreeCollection.pagingEnabled = YES ;
    
    [noThreeCollection registerClass:[lowCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [noThreeCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    [noThreeCollection setBackgroundColor:[UIColor whiteColor]];
    
    [self setupAutoHeightWithBottomView:noThreeCollection bottomMargin:10];
    
    // 当你不确定哪个view在自动布局之后会排布在cell最下方的时候可以调用次方法将所有可能在最下方的view都传过去
    
}




-(void)setModel:(MainTabModel *)model
{
    _model = model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model.ImageUrl]]];
   _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_imageView.layer setMasksToBounds:YES];
    [fenLeiLabel setText:[NSString stringWithFormat:@"%@", model.fenLei]];
    
    [noThreeCollection reloadData];
    [TitleLabel setText:model.titleContent];
   
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_model.imageArray count];
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
    lowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
//    [cell.imageShow setImage:[UIImage imageNamed:_model.imageArray[indexPath.item]]];
    [cell.imageShow sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _model.imageArray[indexPath.item]]]];
    cell.backgroundColor = [UIColor whiteColor];
    [cell sizeToFit];
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH / 3, SCREEN_WIDTH / 3);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(clickCollectionItem:tag:)]) {
        [_delegate clickCollectionItem:indexPath.item tag:self.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
