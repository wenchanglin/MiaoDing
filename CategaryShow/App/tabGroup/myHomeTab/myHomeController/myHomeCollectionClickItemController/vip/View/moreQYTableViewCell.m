//
//  moreQYTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/5/8.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "moreQYTableViewCell.h"

@implementation moreQYTableViewCell
{
    UICollectionView *collection;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        _collectionArray = [NSMutableArray array];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(13, 5, SCREEN_WIDTH - 26, 148)];
        [backView setBackgroundColor:[UIColor whiteColor]];
        backView.layer.masksToBounds = NO;
        [[backView layer] setShadowOffset:CGSizeMake(0, 2)]; // 阴影的范围
        [[backView layer] setShadowRadius:4];                // 阴影扩散的范围控制
        [[backView layer] setShadowOpacity:0.5];               // 阴影透明度
        [[backView layer] setShadowColor:[UIColor lightGrayColor].CGColor];
        [self.contentView addSubview:backView];
        
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, backView.frame.size.width, 15)];
        [_titleLabel setFont:Font_16];
        [backView addSubview:_titleLabel];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setMinimumLineSpacing:0];
        collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [backView addSubview:collection];
        collection.sd_layout
        .leftEqualToView(backView)
        .topSpaceToView(_titleLabel, 5)
        .rightEqualToView(backView)
        .bottomEqualToView(backView);
        collection.delegate = self;
        collection.dataSource = self;
        collection.showsHorizontalScrollIndicator = NO;
        [collection setBackgroundColor:[UIColor whiteColor]];
        [collection registerClass:[moreQYCollectionViewCell class] forCellWithReuseIdentifier:@"vipItem"];
        [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        
    }
    
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_collectionArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"vipItem";
    moreQYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[_collectionArray objectAtIndex:indexPath.item] stringForKey:@"img"]]]];
    cell.text.text = [[_collectionArray objectAtIndex:indexPath.item] stringForKey:@"name"];
    
    
    [cell sizeToFit];
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((SCREEN_WIDTH - 26) / 3, 148 - 50);
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


-(void)layoutSubviews
{
    [super layoutSubviews];
    [collection reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
