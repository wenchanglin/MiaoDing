//
//  JCFlipPage.m
//  JCFlipPageView
//
//  Created by ThreegeneDev on 14-8-8.
//  Copyright (c) 2014年 JimpleChen. All rights reserved.
//

#import "JCFlipPage.h"

@implementation JCFlipPage
{
    UIImageView *imageForClothes;
    UIButton *designerBtn;
    UILabel *title;
    UILabel *name;
    UILabel *descript;
    UIImageView *headImage;
}
@synthesize reuseIdentifier = _reuseIdentifier;

- (void)dealloc
{
}

- (void)prepareForReuse
{
    
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _reuseIdentifier = reuseIdentifier;
        
#warning ! a temp label
        
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    UIView *contentView = self;
    imageForClothes = [UIImageView new];
    [contentView addSubview:imageForClothes];
    
    
    imageForClothes.sd_layout
    .leftEqualToView(contentView)
    .topEqualToView(contentView)
    .rightEqualToView(contentView)
    .bottomEqualToView(contentView);
    
    //    AlphaColthesAndDesginer
    
    UIImageView *imageAlpha = [UIImageView new];
    [contentView addSubview:imageAlpha];
    imageAlpha.sd_layout
    .leftEqualToView(contentView)
    .topEqualToView(contentView)
    .rightEqualToView(contentView)
    .bottomEqualToView(contentView);
    [imageAlpha setImage:[UIImage imageNamed:@"AlphaColthesAndDesginer"]];
    [imageAlpha setUserInteractionEnabled:YES];
    
    
    
    _designer = [UIButton new];
    [contentView addSubview:_designer];
    _designer.sd_layout
    .rightEqualToView(contentView)
    .bottomEqualToView(contentView)
    .leftEqualToView(contentView)
    .heightIs(100);
    
    _designerClothes = [UIButton new];
    [contentView addSubview:_designerClothes];
    _designerClothes.sd_layout
    .rightEqualToView(contentView)
    .topEqualToView(contentView)
    .leftEqualToView(contentView)
    .heightIs(contentView.frame.size.height - 100);
    
    
    title = [UILabel new];
    [contentView addSubview:title];
    [title setTextAlignment:NSTextAlignmentLeft];
    title.sd_layout
    .leftSpaceToView(contentView,12)
    .bottomSpaceToView(contentView,28)
    .widthIs(SCREEN_WIDTH - 24)
    .heightIs(28);
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:Font_20];
    
    
    
    
    
    
    
    
    
    descript = [UILabel new];
    [contentView addSubview:descript];
    descript.sd_layout
    .leftSpaceToView(contentView, 12)
    .topSpaceToView(title, 2)
    .widthIs(100)
    .heightIs(15);
    
    //    [descript setNumberOfLines:2];
    [descript setFont:[UIFont systemFontOfSize:10]];
    [descript setTextColor:[UIColor whiteColor]];
    //    [descript setShadowColor:[UIColor blackColor]];
    
    
    name = [UILabel new];
    [contentView addSubview:name];
    name.sd_layout
    .leftSpaceToView(descript, 0)
    .topSpaceToView(title, 2)
    .rightSpaceToView(contentView, 30)
    .heightIs(15);
    [name setTextAlignment:NSTextAlignmentLeft];
    [name setFont:[UIFont systemFontOfSize:10]];
    [name setTextColor:[UIColor whiteColor]];
    [name setShadowColor:[UIColor blackColor]];
    
}

-(void)setModel:(designerModel *)model
{
    _model = model;
//    [imageForClothes sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.img]]];
//    imageForClothes.contentMode = UIViewContentModeScaleAspectFill;
//    [imageForClothes.layer setMasksToBounds:YES];
//
//    if (![model.goods_id isEqualToString:@""]) {
//        [title setText:model.name];
//        if ([model.uname length] > 0) {
//            [name setText:model.uname];
//        }
//        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:model.p_time];
//        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle1 setLineSpacing:2];
//        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.p_time length])];
//        [descript setAttributedText:attributedString1];
//        [descript sizeToFit];
//        
//        [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.avatar]]];
//    }
//    
    
}


- (void)setReuseIdentifier:(NSString *)identifier
{
    _reuseIdentifier = identifier;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
