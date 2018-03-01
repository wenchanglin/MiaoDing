//
//  dateForBodyTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/3/1.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "dateForBodyTableViewCell.h"

@implementation dateForBodyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_detailLabel];
        
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(20, 0, self.frame.size.width / 3 - 19,  self.frame.size.height);
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 3 - 1, 5, 1, self.frame.size.height - 10)];
    [lineView setBackgroundColor:getUIColor(Color_myTabIconLineColor)];
    [self.contentView addSubview:lineView];
    
    _detailLabel.frame = CGRectMake(self.frame.size.width / 3 + 15, 0, self.frame.size.width / 3 * 2 - 15, self.frame.size.height);
    [_detailLabel setFont:[UIFont systemFontOfSize:14]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
