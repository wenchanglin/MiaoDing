//
//  ClothesForPayNoAddressTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/7.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "ClothesForPayNoAddressTableViewCell.h"

@implementation ClothesForPayNoAddressTableViewCell

{
    UILabel *worningLabel;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    
    return self;
}

-(void)setUp
{
    UIView *contentView = self.contentView;
    worningLabel = [UILabel new];
    [self.contentView addSubview:worningLabel];
    worningLabel.sd_layout
    .leftSpaceToView(contentView, 12)
    .centerYEqualToView(contentView)
    .rightSpaceToView(contentView,10)
    .heightIs(20);
    [worningLabel setTextColor:[UIColor colorWithHexString:@"#222222"]];
    [worningLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
}

-(void)setModel:(AddressModel *)model
{
    _model = model;
    [worningLabel setText:model.userAddress];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
