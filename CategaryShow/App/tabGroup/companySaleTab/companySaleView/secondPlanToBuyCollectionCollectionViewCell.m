//
//  secondPlanToBuyCollectionCollectionViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/9/11.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "secondPlanToBuyCollectionCollectionViewCell.h"
#import "CompanySaleModel.h"
@implementation secondPlanToBuyCollectionCollectionViewCell
{
    UIImageView *clothesImage;
    UILabel *priceLabel;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    

    clothesImage = [UIImageView new];
    clothesImage.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:clothesImage];
    clothesImage.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
}

-(void)setModel:(CompanySaleModel *)model
{
    _model = model;
    
    
    
    [clothesImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _model.clothesUrl]]];
            
    
     
   
    
    
}



@end
