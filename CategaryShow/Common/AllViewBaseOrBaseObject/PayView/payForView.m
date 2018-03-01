//
//  payForView.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/8.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "payForView.h"
#import "payTypeModel.h"
#import "payTypeTableViewCell.h"
@implementation payForView
{
    UILabel *titleLabel;
    UIButton *cancelBtn;
    UITableView *tablePay;
    UILabel *priceLable;
    NSMutableArray *typeArray;
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
        payTypeModel *model = [payTypeModel new];
        model.typeImage = @"zhifubao";
        model.typeName = @"支付宝";
        model.chooseIf = YES;
        model.typeRemark =@"推荐支付宝用户使用";
        payTypeModel *model1 = [payTypeModel new];
        model1.typeImage = @"weixin";
        model1.typeName = @"微信支付";
        model1.typeRemark =@"推荐微信用户使用";
        model1.chooseIf = NO;
        typeArray = [NSMutableArray arrayWithObjects:model,model1, nil];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUp];
    }
    
    return self;
}

-(void)setUp
{
    titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    
    titleLabel.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self,13)
    .widthIs(100)
    .heightIs(20);
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"支付方式"];
    
    cancelBtn = [UIButton new];
    [self addSubview:cancelBtn];
    cancelBtn.sd_layout
    .leftSpaceToView(self,15)
    .topSpaceToView(self,13)
    .heightIs(20)
    .widthIs(20);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelPayClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self,46)
    .heightIs(1);
    [lineView setBackgroundColor:getUIColor(Color_payViewLine)];
    
    tablePay = [[UITableView alloc] initWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, 54 * 2) style:UITableViewStylePlain];
    tablePay.delegate = self;
    tablePay.dataSource =self;
    [tablePay registerClass:[payTypeTableViewCell class] forCellReuseIdentifier:@"payType"];
    [self addSubview:tablePay];
    
    UILabel *heji = [UILabel new];
    [self addSubview:heji];
    heji.sd_layout
    .leftSpaceToView(self, 16)
    .topSpaceToView(tablePay, 20)
    .heightIs(20)
    .widthIs(40);
    [heji setFont:[UIFont systemFontOfSize:15]];
    [heji setText:@"合计:"];
    
    
    priceLable = [UILabel new];
    [self addSubview:priceLable];
    priceLable.sd_layout
    .leftSpaceToView(heji,5)
    .topSpaceToView(tablePay,20)
    .heightIs(20)
    .widthIs(SCREEN_WIDTH / 2);
   
    [priceLable setFont:[UIFont systemFontOfSize:15]];
    [priceLable setTextAlignment:NSTextAlignmentLeft];
    
    UIButton *buttonPay = [UIButton new];
    [self addSubview:buttonPay];
    buttonPay.sd_layout
    .centerXEqualToView(self)
    .bottomSpaceToView(self,18)
    .widthIs(280)
    .heightIs(39);
    [buttonPay setBackgroundColor:getUIColor(Color_myBagToPayButton)];
    [buttonPay setTitle:@"确认付款" forState:UIControlStateNormal];
    [buttonPay addTarget:self action:@selector(goToBuy) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
     [priceLable setText:[NSString stringWithFormat:@"￥%@",_price]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [typeArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    payTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payType" forIndexPath:indexPath];
    cell.model = typeArray[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)cancelPayClick
{
    
    if ([_delegate respondsToSelector:@selector(cancelClick)]) {
        [_delegate cancelClick];
    }
}

-(void)reloadView
{
    [priceLable setText:[NSString stringWithFormat:@"￥%.2f",[_price floatValue]]];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < [typeArray count]; i ++) {
        payTypeModel *model = typeArray[i];
        if (indexPath.row == i) {
            
            model.chooseIf = YES;
        } else {
            model.chooseIf = NO;
        }
    }
    
    [tablePay reloadData];
    
    if ([_delegate respondsToSelector:@selector(clickItem:)]) {
        [_delegate clickItem:indexPath.row];
    }
}

-(void)goToBuy
{
    if ([_delegate respondsToSelector:@selector(payClick)]) {
        [_delegate payClick];
    }
}

@end









