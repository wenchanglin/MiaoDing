//
//  diyClothesDetailCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/19.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "diyClothesDetailCollectionViewCell.h"
#import "YYCycleScrollView.h"
#import "pictureDIyCollectionViewCell.h"
#import "footCollectionReusableView.h"
#import "imgListModel.h"
@implementation diyClothesDetailCollectionViewCell
{    

    UILabel *nameLabel;
    UILabel *subNameLabel;
    UIPageControl *page;
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _banerArray = [NSMutableArray array];
            
    
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.footerReferenceSize = CGSizeMake(80, self.frame.size.height - 104);
        //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
        _clotehImageCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 104) collectionViewLayout:flowLayout];
        //设置代理
        _clotehImageCollect.delegate = self;
        _clotehImageCollect.dataSource = self;
        [self.contentView addSubview:_clotehImageCollect];
        _clotehImageCollect.backgroundColor = [UIColor whiteColor];
        //注册cell和ReusableView（相当于头部）
//        _clotehImageCollect.alwaysBounceVertical = YES;
        _clotehImageCollect.pagingEnabled = YES ;
        _clotehImageCollect.showsHorizontalScrollIndicator = NO;
        [_clotehImageCollect registerClass:[pictureDIyCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_clotehImageCollect registerClass:[footCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ReusableView"];
        
        page = [UIPageControl new];
        [self.contentView addSubview:page];
        page.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .bottomSpaceToView(self.contentView, 114)
        .heightIs(15)
        .leftSpaceToView(self.contentView,10);
       
        page.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
        page.pageIndicatorTintColor = [UIColor grayColor];// 设置非选中页的圆点颜色
        
        page.currentPageIndicatorTintColor = [UIColor whiteColor];
        
        
   
        [self setUp];
        
    }
    
    return self;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_banerArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    imgListModel*model2=_banerArray[indexPath.row];
    pictureDIyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell.clothesIntroPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model2.img]]];
    [cell sizeToFit];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 104);

}

-(void)setUp
{
    UIView *contentView = self.contentView;
    nameLabel = [UILabel new];
    [contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(20);
        make.bottom.equalTo(contentView.mas_bottom).with.offset(-55);
        make.height.equalTo(@25);
    }];
    [nameLabel setFont:Font_26];
    
    subNameLabel = [UILabel new];
    [contentView addSubview:subNameLabel];
    subNameLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(nameLabel, 10)
    .rightSpaceToView(contentView, 20)
    .heightIs(20);
    [subNameLabel setTextAlignment:NSTextAlignmentRight];
    [subNameLabel setFont:[UIFont systemFontOfSize:18]];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 设置页码
    page.currentPage = pageNum;
    if (scrollView.contentOffset.x > SCREEN_WIDTH * ([_banerArray count] - 1) + 80) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLowView" object:nil];
    }
}
// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableView = header;
    }
    reusableView.backgroundColor = [UIColor greenColor];
    if (kind == UICollectionElementKindSectionFooter)
    {
        footCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor whiteColor];
        reusableView = footerview;
    }
    return reusableView;
}


-(void)setModel:(diyClothesDetailModel *)model
{
    _model = model;
    [subNameLabel setText:model.content];
    [nameLabel setText:model.name];
     page.numberOfPages = [_banerArray count];//指定页面个数
    [_clotehImageCollect reloadData];
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(clickBanerItem:)]) {
        [_delegate clickBanerItem:indexPath.item];
    }
}


@end
