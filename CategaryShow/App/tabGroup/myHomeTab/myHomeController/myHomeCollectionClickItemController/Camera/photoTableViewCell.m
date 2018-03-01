//
//  photoTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/13.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "photoTableViewCell.h"

@implementation photoTableViewCell
{
    UILabel *namePhoto;
    UIImageView *photo;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
        
    }
    
    return self;
}

-(void)setUp {
    UIView *contentView = self.contentView;
    namePhoto = [UILabel new];
    [contentView addSubview:namePhoto];
    
    namePhoto.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(contentView, 10)
    .widthIs(50)
    .heightIs(20);
    [namePhoto setFont:[UIFont systemFontOfSize:16]];
    [namePhoto setTextColor:[UIColor blackColor]];
    
    photo = [UIImageView new];
    [contentView addSubview:photo];
    photo.sd_layout
    .leftSpaceToView(contentView, 50)
    .topSpaceToView(namePhoto,10)
    .widthIs(150)
    .heightIs(236);
    
    
}

-(void)setModel:(photoModel *)model

{
    _model = model;
    [namePhoto setText:model.photoName];
    [photo setImage:model.photo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
