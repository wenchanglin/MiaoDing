//
//  priceChooseTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/8.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "priceChooseTableViewCell.h"

@implementation priceChooseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        
        
        
        _priceLabel = [UILabel new];
        [self.contentView addSubview:_priceLabel];
       
        
        _priceRemark = [UILabel new];
        [self.contentView addSubview:_priceRemark];
        
        
       
        
    }
    
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.sd_layout
    .rightEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .topEqualToView(self.contentView);
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_centerX).with.offset(-10);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        
    }];
    
    [_priceLabel setTextAlignment:NSTextAlignmentRight];
    
    [_priceRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).with.offset(10);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    [_lineView setBackgroundColor:getUIColor(Color_myTabIconLineColor)];
    [self addSubview:_lineView];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
