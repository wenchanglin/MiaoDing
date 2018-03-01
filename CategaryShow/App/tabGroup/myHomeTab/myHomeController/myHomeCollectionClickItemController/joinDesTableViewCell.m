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
        
        UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
        [flowL setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //设置每一个item的大小
        flowL.itemSize = CGSizeMake((self.frame.size.width - 60 -15) / 5 , (self.frame.size.width - 60 - 15) / 5 );
        flowL.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
        //列
        flowL.minimumInteritemSpacing = 10;
        //行
        flowL.minimumLineSpacing = 10;
        //创建集合视图
        self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(12, 30, SCREEN_WIDTH - 30, ([UIScreen mainScreen].bounds.size.width - 60 - 18) / 5 + 10) collectionViewLayout:flowL];
        _collectionV.backgroundColor = [UIColor whiteColor];
        // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 5);
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        //添加集合视图
        [self.contentView addSubview:_collectionV];
        
        //注册对应的cell
        [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
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
