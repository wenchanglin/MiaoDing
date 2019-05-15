//
//  WLheaderTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/25.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "WLheaderTableViewCell.h"

@implementation WLheaderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *imageHead = [UIImageView new];
        [self.contentView addSubview:imageHead];
        imageHead.sd_layout
        .leftSpaceToView(self.contentView, 20)
        .centerYEqualToView(self.contentView)
        .widthIs(55 /2 )
        .heightIs(25);
        [imageHead setImage:[UIImage imageNamed:@"wlCar"]];
        
        
        self.wlName = [UILabel new];
        [self.contentView addSubview:_wlName];
        _wlName.sd_layout
        .leftSpaceToView(imageHead, 10)
        .topSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(17);
        [_wlName setFont:[UIFont systemFontOfSize:13]];
        
        
        
        self.wlNum = [UILabel new];
        [self.contentView addSubview:_wlNum];
        _wlNum.sd_layout
        .leftSpaceToView(imageHead, 10)
        .topSpaceToView(_wlName, 10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(17);
        [_wlNum setFont:[UIFont systemFontOfSize:13]];
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
