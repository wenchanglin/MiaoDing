//
//  MyHomeListTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/8/25.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MyHomeListTableViewCell.h"

@implementation MyHomeListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        _titleArray = [NSMutableArray arrayWithObjects:@"我的订单", @"购物袋", @"优惠券", @"我的收藏",@"预约量体", @"穿衣测试", @"设计师入驻",@"私人顾问",@"邀请好友", nil];
        self.imageArray = [NSMutableArray arrayWithObjects:@"MyOrder",@"BuyBag", @"YHQ",@"mySave",@"YuYue",@"wearTest", @"designer",@"SiRen",@"invite", nil];
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 0;
        //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
         self.collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85 * 3) collectionViewLayout:flowLayout];
        
        //设置代理
        self.collect.delegate = self;
        self.collect.dataSource = self;
        [self.contentView addSubview:self.collect];
        [_collect setBackgroundColor:getUIColor(Color_background)];
        self.collect.backgroundColor = [UIColor whiteColor];
        
        //注册cell和ReusableView（相当于头部）
        [self.collect registerClass:[MianTabFourCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        [self.collect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_titleArray count];
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
    MianTabFourCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    if (indexPath.item < 3) {
        [cell.topView setHidden:YES];
    } else {
        [cell.topView setHidden:NO];
    }
    
    if (indexPath.item == 0 || indexPath.item % 3 == 0) {
        [cell.leftView setHidden:YES];
    } else {
        [cell.leftView setHidden:NO];
    }
    
    if (indexPath.item == 8) {
        [cell.YJXImage setHidden:NO];
    } else {
        [cell.YJXImage setHidden:YES];

    }
    
    cell.imgView.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.item]];
    cell.text.text = [_titleArray objectAtIndex:indexPath.item];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((self.frame.size.width)/3, 85);
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
    if ([_delegate respondsToSelector:@selector(collectionSelect::)]) {
        [_delegate collectionSelect:_titleArray :indexPath.item];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
