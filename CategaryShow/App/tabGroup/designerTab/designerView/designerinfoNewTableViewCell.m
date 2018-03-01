//
//  designerinfoNewTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/13.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "designerinfoNewTableViewCell.h"

@implementation designerinfoNewTableViewCell

{
    UIImageView *designerHead;
    UILabel *designerName;
    UILabel *time;
    UILabel *clothesName;
    UIImageView *clothesImg;
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

    
    UIImageView *image = [UIImageView new];
    [contentView addSubview:image];
    image.sd_layout
    .leftSpaceToView(contentView,8)
    .rightSpaceToView(contentView,8)
    .topEqualToView(contentView)
    .bottomEqualToView(contentView);
    [image setImage:[UIImage imageNamed:@"designerClothesBack"]];
    
    clothesImg = [UIImageView new];
    [image addSubview:clothesImg];
    clothesImg.sd_layout
    .leftSpaceToView(image,7)
    .topSpaceToView(image,7)
    .rightSpaceToView(image,7)
    .bottomSpaceToView(image,7);
    [clothesImg.layer setMasksToBounds:YES];
    [clothesImg.layer setCornerRadius:3];
    [clothesImg setContentMode:UIViewContentModeScaleAspectFit];
    
    
    
    UIImageView *backAlpha = [UIImageView new];
    [image addSubview:backAlpha];
    backAlpha.sd_layout
    .leftSpaceToView(image,7)
    .topSpaceToView(image,7)
    .rightSpaceToView(image,7)
    .bottomSpaceToView(image,7);
    [backAlpha setImage:[UIImage imageNamed:@"AlphaColthesAndDesginer"]];
    [backAlpha.layer setCornerRadius:3];
    [backAlpha.layer setMasksToBounds:YES];
    
    time = [UILabel new];
    [image addSubview:time];
    time.sd_layout
    .leftSpaceToView(image, 26)
    .bottomSpaceToView(image, 15)
    .heightIs(15)
    .rightSpaceToView(image, 20);
    [time setFont:[UIFont systemFontOfSize:10]];
    [time setTextColor:[UIColor whiteColor]];
    
    clothesName = [UILabel new];
    [image addSubview:clothesName];
    clothesName.sd_layout
    .leftSpaceToView(image, 26)
    .bottomSpaceToView(time, 5)
    .heightIs(20)
    .rightSpaceToView(image, 20);
    [clothesName setFont:Font_16];
    [clothesName setTextColor:[UIColor whiteColor]];

}

-(void)setModel:(designerModel *)model
{
    
    _model = model;
    [designerHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.designerHead]]];
    [designerName setText:model.designerName];
    [time setText:model.p_time];
    [clothesName setText:model.titlename];
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.clothesImage]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
