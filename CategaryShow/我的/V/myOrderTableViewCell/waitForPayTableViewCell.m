//
//  waitForPayTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "waitForPayTableViewCell.h"
#import "orderModel.h"
#import "MorePeiJianView.h"
@implementation waitForPayTableViewCell

{
    UILabel *clothesStatus;
    UILabel *dingNumber;
    NSArray*childsArr;
    UILabel *clothesPrice;
    UICollectionView*childCollectionView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
        make.bottom.mas_equalTo(-50);
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
    clothesPrice = [UILabel new];
    [clothesPrice setFont:Font_12];
    [self addSubview:clothesPrice];
    [clothesPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(5);
        make.left.equalTo(line2);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(30);
    }];
    _payFor = [UIButton new];
    [self addSubview:_payFor];
    
    _payFor.sd_layout
    .rightSpaceToView(self, 13)
    .topSpaceToView(line2, 9.5)
    .widthIs(60)
    .heightIs(25);
    [_payFor.layer setCornerRadius:2];
    [_payFor.layer setMasksToBounds:YES];
    [_payFor.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_payFor.layer setBorderWidth:1];
    [_payFor.titleLabel setFont:[UIFont systemFontOfSize:11.5]];
    [_payFor.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    //    [_payFor setTitle:@"立即付款" forState:UIControlStateNormal];
    //    [_payFor setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [_payFor addTarget:self action:@selector(ClickPay) forControlEvents:UIControlEventTouchUpInside];
    
    
    _cancelOrder = [UIButton new];
    
    [self addSubview:_cancelOrder];
    _cancelOrder.sd_layout
    .rightSpaceToView(_payFor, 13)
    .topSpaceToView(line2, 9.5)
    .widthIs(70)
    .heightIs(25);
    [_cancelOrder.layer setCornerRadius:1];
    [_cancelOrder.layer setMasksToBounds:YES];
    [_cancelOrder.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_cancelOrder.layer setBorderWidth:1];
    [_cancelOrder.titleLabel setFont:[UIFont systemFontOfSize:11.5]];
    [_cancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
    //    [_cancelOrder addTarget:self action:@selector(ClickCancel) forControlEvents:UIControlEventTouchUpInside];
    [_cancelOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(void)setModel:(orderModel *)model
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
    [clothesPrice setText:[NSString stringWithFormat:@"实付：¥%.2f",[_model.payable_amount floatValue]-[_model.giftcard_eq_money floatValue]]];
    
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
    if ([self.delegate respondsToSelector:@selector(waitPayclickItemToDetailWithOrderSn:withStatus:)]) {
        [self.delegate waitPayclickItemToDetailWithOrderSn:_model.order_sn withStatus:_model.status];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
