//
//  LabelAndBoyOrGirl.m
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "LabelAndBoyOrGirl.h"
#import "NKColorSwitch.h"
#import "MeasureLabelAndTextFieldModel.h"
@implementation LabelAndBoyOrGirl
{
    UILabel *titleName;
    
    UIImageView *boyImage;
    UIImageView *girlImage;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
    }
    return self;
}


-(void)createView
{
    UIView *contentView = self.contentView;
    
    if (!titleName) {
        titleName = [UILabel new];
        [contentView addSubview:titleName];
        
        
        titleName.sd_layout
        .leftSpaceToView(contentView, 12)
        .topSpaceToView(contentView, 12)
        .widthIs(80)
        .bottomSpaceToView(contentView, 15);
        [titleName setFont:Font_14];
       
        
        
        _swithGirlOrBoy = [[NKColorSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 77, 10, 60, 30)];
        [contentView addSubview:_swithGirlOrBoy];
        
        [_swithGirlOrBoy setTintColor:[UIColor lightGrayColor]];
        [_swithGirlOrBoy setOnTintColor:[UIColor blackColor]];
        [_swithGirlOrBoy setThumbTintColor:[UIColor whiteColor]];
        [_swithGirlOrBoy setShape:kNKColorSwitchShapeRectangle];
        
        
       
      
    }
    
    
    
}

-(void)setModel:(MeasureLabelAndTextFieldModel *)model
{
    _model = model;
    [titleName setText:model.titleName];
   
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
