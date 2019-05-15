//
//  MyOrderDetailListTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MyOrderDetailListTableViewCell.h"
#import "MorePeiJianView.h"
@implementation MyOrderDetailListTableViewCell
{
    UILabel *clothesStatus;
    UILabel *dingNumber;
    NSArray*childsArr;
    UICollectionView*childCollectionView;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UIView *contentView = self.contentView;
    dingNumber = [UILabel new];
    [contentView addSubview:dingNumber];
    dingNumber.sd_layout
    .leftSpaceToView(contentView, 13)
    .topSpaceToView(contentView, 8)
    .widthIs(contentView.frame.size.width - 50)
    .heightIs(20);
    [dingNumber setFont:Font_12];
    
    clothesStatus = [UILabel new];
    [contentView addSubview:clothesStatus];
    clothesStatus.sd_layout
    .rightSpaceToView(contentView,26)
    .topSpaceToView(contentView, 8)
    .heightIs(20)
    .widthIs(80);
    [clothesStatus setFont:Font_12];
    [clothesStatus setTextAlignment:NSTextAlignmentRight];
}

-(void)setModel:(mineOrderDetailModel *)model
{
    _model = model;
    childsArr = model.childOrders;
    if (!childCollectionView) {
        [self createCollection];
    }
    else
    {
        [childCollectionView reloadData];
    }
    [dingNumber setText: [NSString stringWithFormat:@"订单编号: %@", _model.order_sn]];
    [clothesStatus setText:_model.status_text];

}
-(void)createCollection
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 0;
    childCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    //设置代理
    childCollectionView.delegate = self;
    childCollectionView.dataSource = self;
    childCollectionView.showsVerticalScrollIndicator = NO;
    childCollectionView.scrollEnabled=NO;
    [childCollectionView registerClass:[waitForPayCollectionCell class] forCellWithReuseIdentifier:@"waitForPayCollectionCell"];
    childCollectionView.backgroundColor =[UIColor whiteColor];
    [self addSubview:childCollectionView];
    [childCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dingNumber.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(-10);
    }];
    UIView *line2 = [UIView new];
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(childCollectionView.mas_bottom).offset(5);
        make.left.mas_equalTo(13);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(SCREEN_WIDTH-13);
    }];
    [line2 setBackgroundColor:getUIColor(Color_myOrderLine)];
   
}
-(void)clickMineOrderListMoreLabel:(NSInteger)item
{
    childOrdersModel *model = childsArr[item];
    if (model.category_id==2) {
        if (model.sku.count>1) {
            [MorePeiJianView showWithData:model.sku withTitle:@"更多配件" isChengPing:model.category_id  withDoneBlock:^(NSString * _Nonnull string) {
            }];
        }
    }
    else
    {
        if (model.part.count>1) {
            [MorePeiJianView showWithData:model.part withTitle:@"更多配件" isChengPing:model.category_id withDoneBlock:^(NSString * _Nonnull string) {
            }];
        }
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [childsArr count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    waitForPayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"waitForPayCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.itemIdex = indexPath.item;
    cell.delegate =self;
    childOrdersModel *model = childsArr[indexPath.item];
    cell.model = model;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, 90);
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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
