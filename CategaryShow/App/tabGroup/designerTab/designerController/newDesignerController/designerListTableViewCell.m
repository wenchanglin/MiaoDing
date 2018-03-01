//
//  designerListTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/5.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "designerListTableViewCell.h"

@implementation designerListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imgDesigner = [[UIImageView alloc] initWithFrame:CGRectZero];
        _name = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_imgDesigner];
        [self.contentView addSubview:_name];
        
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *contentView = self.contentView;
    _imgDesigner.sd_layout
    .leftEqualToView(contentView)
    .topEqualToView(contentView)
    .rightEqualToView(contentView)
    .bottomSpaceToView(contentView, 2);
    [_imgDesigner setContentMode:UIViewContentModeScaleAspectFill];
    [_imgDesigner.layer setMasksToBounds:YES];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).with.offset(-20);
        make.centerY.equalTo(contentView.mas_centerY);
        make.width.equalTo(@150);
    }];
    [_name setTextAlignment:NSTextAlignmentCenter];
    [_name setTextColor:[UIColor whiteColor]];
    [_name setNumberOfLines:0];
    [_name setFont:Font_16];

    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
