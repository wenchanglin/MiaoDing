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
    UILabel*label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, 31, 80, 20)];
    label1.text =@"热销商品";
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];

    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
   UIFont*font= [UIFont fontWithName:@"PingFangTC-Regular" size:14];
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.6f};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:label1.text attributes:dic];
    label1.attributedText = attributeStr;
    label1.textAlignment=NSTextAlignmentCenter;
    label1.textColor =[UIColor colorWithHexString:@"#202020"];
    [contentView addSubview:label1];
    
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
    .topSpaceToView(label1,10)
    .bottomEqualToView(contentView);
    //注册cell和ReusableView（相当于头部）
    
    [noThreeCollection registerClass:[mainClothesSaleCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [noThreeCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    [noThreeCollection setBackgroundColor:[UIColor whiteColor]];
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
//    cell.backgroundColor=[UIColor blueColor];
    [cell.imageDesigner sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, deModel.img]] placeholderImage:[UIImage imageNamed:@"loading"]];;
    if (iPadDevice) {
        NSString*height = ((IndexTypeModel *)modelArray[0]).img_info;
        [cell.imageDesigner mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo((SCREEN_WIDTH-20)/2.5/[height floatValue]-61);
        }];
    }
   
    [cell.nameLabel setText:deModel.goods_name];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",deModel.sell_price];
    [cell sizeToFit];
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    IndexTypeModel *deModel = modelArray[0];
    if(iPadDevice)
    {
        return CGSizeMake((SCREEN_WIDTH-20)/2.5, (SCREEN_WIDTH-20)/2.5/[deModel.img_info floatValue]);
    }
    return CGSizeMake(SCREEN_WIDTH/2.5, SCREEN_WIDTH/2);//CGSizeMake(169.5+16, 105+28);
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
