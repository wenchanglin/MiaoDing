//
//  styleChoose.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/8.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "styleChoose.h"
#import "priceChooseTableViewCell.h"
@implementation styleChoose
{

    UITableView *priceChoose;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

-(void)setUp
{
    
    priceChoose = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45 * ([_model.price count] + 1)) style:UITableViewStylePlain];
    priceChoose.delegate = self;
    priceChoose.dataSource = self;
    [priceChoose registerClass:[priceChooseTableViewCell class] forCellReuseIdentifier:@"choosePrice"];
    priceChoose.scrollEnabled =NO;
    [priceChoose setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:priceChoose];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_model.price count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    priceChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"choosePrice" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row == 0) {
        [cell.titleLabel setText:@"请选择版型"];
        [cell.priceRemark setHidden:YES];
        [cell.priceLabel setHidden:YES];
        [cell.titleLabel setHidden:NO];
        [cell setBackgroundColor:[UIColor blackColor]];
        [cell.titleLabel setFont:Font_16];;
        [cell.titleLabel setTextColor:[UIColor whiteColor]];
        [cell.lineView setHidden:YES];
    } else {
//        [cell.lineView setHidden:NO];
//        [cell.priceRemark setHidden:NO];
//        [cell.priceLabel setHidden:NO];
//        [cell.titleLabel setHidden:YES];
//        [cell.priceLabel setText:[_model.price[indexPath.row - 1] stringForKey:@"price"]];
//        [cell.priceRemark setText:[_model.price[indexPath.row - 1] stringForKey:@"priceRemark"]];
//        [cell.priceRemark setFont:Font_14];
//        [cell.priceLabel setTextColor:[UIColor blackColor]];
//        [cell.priceLabel setFont:Font_14];
//        [cell.priceLabel setBackgroundColor:[UIColor whiteColor]];
        
        [cell.titleLabel setText:[_model.price[indexPath.row - 1] stringForKey:@"styleName"]];
        [cell.priceRemark setHidden:YES];
        [cell.priceLabel setHidden:YES];
        [cell.titleLabel setHidden:NO];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.titleLabel setFont:Font_16];;
        [cell.titleLabel setTextColor:[UIColor blackColor]];
        [cell.lineView setHidden:YES];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        if ([_delegate respondsToSelector:@selector(clickStyleChoose:)]) {
            [_delegate clickStyleChoose:indexPath.row - 1];
        }
    }
    
}

-(void)setModel:(choosePriceModel *)model
{
    _model = model;
    [self setUp];
}



@end
