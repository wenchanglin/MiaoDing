//
//  DesignerTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/17.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "DesignerTableViewCell.h"
#import "IndexTypeModel.h"
@implementation DesignerTableViewCell
{
    UICollectionView *noThreeCollection;
    NSMutableArray *modelArray;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        modelArray = [NSMutableArray array];
        
        
    }
    
    return self;
}

-(void)setUp
{
    UIView *contentView = self.contentView;
    [self setBackgroundColor:[UIColor whiteColor]];
    
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
    .centerXEqualToView(contentView)
    .centerYEqualToView(contentView)
    .widthIs(SCREEN_WIDTH)
    .topSpaceToView(contentView,0)
    .bottomEqualToView(contentView);

    
    
    //注册cell和ReusableView（相当于头部）
    
    //    noThreeCollection.pagingEnabled = YES ;
    
    [noThreeCollection registerClass:[mainClothesSaleCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [noThreeCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    [noThreeCollection setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [modelArray count];
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
    IndexTypeModel *deModel = modelArray[indexPath.item];
    mainClothesSaleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //    [cell.imageShow setImage:[UIImage imageNamed:_model.imageArray[indexPath.item]]];
//    [cell.imageShow sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _model.imageArray[indexPath.item]]]];
    [cell.imageDesigner sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, deModel.img]] placeholderImage:[UIImage imageNamed:@"logoImage"]];;
//    [cell.nameLabel setText:deModel.name];
   
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [cell sizeToFit];
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH/2-6, (SCREEN_WIDTH-36)/2/169.5*105+24);//CGSizeMake(169.5+16, 105+28);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 6, 0, 6);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(clickCollectionItem:)]) {
        [_delegate clickCollectionItem:indexPath.item];
    }
}

-(void)setModel:(NewDesignerArray *)model
{
    _model = model;
    [modelArray removeAllObjects];
    for (NSDictionary * dic in model.designerArray ) {
        IndexTypeModel *deModel = [IndexTypeModel mj_objectWithKeyValues:dic];
        [modelArray addObject:deModel];
    }
    
    if (noThreeCollection) {
        [self collectionViewReload];
    } else {
        [self setUp];
    }
    
    
}

-(void)collectionViewReload
{
    
   
    [noThreeCollection reloadData];
}

@end
