//
//  DiyAllPicCell.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/6.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "DiyAllPicCell.h"

@implementation DiyAllPicCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
-(UIImageView *)picImageView
{
    if (!_picImageView) {
        _picImageView= [[UIImageView alloc]init];
        _picImageView.contentMode=UIViewContentModeScaleAspectFill;
        _picImageView.layer.masksToBounds=YES;
        [self addSubview:_picImageView];
    }
    return _picImageView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
