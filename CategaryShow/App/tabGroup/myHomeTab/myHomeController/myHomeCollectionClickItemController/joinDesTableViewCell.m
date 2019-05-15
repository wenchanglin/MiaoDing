//
//  joinDesTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/22.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "joinDesTableViewCell.h"
#import "PhotoCollectionViewCell.h"
@implementation joinDesTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, SCREEN_WIDTH - 28, 20)];
        [_remarkLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:_remarkLabel];
        
       
        
    }
    
    return self;
}


-(void)setPhotoArrayM:(NSMutableArray *)photoArrayM
{
    _photoArrayM = photoArrayM;
    if(self.collectionV)
    {
        [self.collectionV reloadData];
    }
    else
    {
        UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
        [flowL setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //设置每一个item的大小
        
        //创建集合视图
        if(iPadDevice)
        {
        self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(12, 30, SCREEN_WIDTH - 24, 170) collectionViewLayout:flowL];
        }
        else
        {

             self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(12, 30, SCREEN_WIDTH - 30, ([UIScreen mainScreen].bounds.size.width - 60 - 18) / 5 + 10) collectionViewLayout:flowL];
        }
        _collectionV.backgroundColor = [UIColor whiteColor];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        //添加集合视图
        [self.contentView addSubview:_collectionV];
        
        //注册对应的cell
        [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_photoArrayM.count == 0) {
        return 0;
    }
    else{
        return _photoArrayM.count;
    }
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.photoV.image = self.photoArrayM[indexPath.item];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPadDevice) {
        return CGSizeMake((SCREEN_WIDTH - 60-20) / 5, (SCREEN_WIDTH -60-20) / 5 );//
    }
    else
    {
        return CGSizeMake((SCREEN_WIDTH - 60 -20) / 5 , (SCREEN_WIDTH - 60 - 20) / 5 );
    }
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (iPadDevice) {
        return UIEdgeInsetsMake(5, 10, 10, 10);
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(collectionClick::)]) {
        [_delegate collectionClick:indexPath.item :self.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
