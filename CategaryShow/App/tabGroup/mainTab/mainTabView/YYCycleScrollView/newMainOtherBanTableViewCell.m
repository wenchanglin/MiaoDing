//
//  newMainOtherBanTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/13.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "newMainOtherBanTableViewCell.h"

@implementation newMainOtherBanTableViewCell

{
    UIImageView *mainImg;
    UILabel *nameLabel;
    UILabel *nameContent;
    UILabel *numberWatch;
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
    [self setBackgroundColor:[UIColor whiteColor]];
    
    //    UIImageView *bgView = [UIImageView new];
    //    [contentView addSubview:bgView];
    //    bgView.sd_layout
    //    .topSpaceToView(contentView,10)
    //    .leftSpaceToView(contentView,12)
    //    .rightSpaceToView(contentView,12)
    //    .bottomSpaceToView(contentView, 10);
    //    [bgView setBackgroundColor:[UIColor whiteColor]];
    //    bgView.layer.masksToBounds = NO;
    //    [[bgView layer] setShadowOffset:CGSizeMake(0, 3)]; // 阴影的范围
    //    [[bgView layer] setShadowRadius:3];                // 阴影扩散的范围控制
    //    [[bgView layer] setShadowOpacity:0.5];               // 阴影透明度
    //    [[bgView layer] setShadowColor:[UIColor grayColor].CGColor];
    
    
    
    mainImg = [UIImageView new];
    [contentView addSubview:mainImg];
    mainImg.sd_layout
    .topEqualToView(contentView)
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .bottomSpaceToView(contentView, 1);
    
    
    //    nameLabel = [UILabel new];
    //    [bgView addSubview:nameLabel];
    //    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(bgView.mas_left).with.offset(16);
    //        make.top.equalTo(bgView.mas_top).with.offset(192);
    //        make.height.equalTo(@15);
    //        make.right.equalTo(bgView.mas_right).with.offset(-16);
    //    }];
    //    [nameLabel setFont:Font_14];
    //
    //    nameContent = [UILabel new];
    //    [bgView addSubview:nameContent];
    //    [nameContent mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(nameLabel.mas_right).with.offset(0);
    //        make.top.equalTo(bgView.mas_top).with.offset(192);
    //        make.height.equalTo(@15);
    //        make.right.equalTo(bgView.mas_right).with.offset(-5);
    //    }];
    //    [nameContent setFont:Font_14];
    //    [nameContent setTextAlignment:NSTextAlignmentLeft];
    //
    //    numberWatch = [UILabel new];
    //    [bgView addSubview:numberWatch];
    //    [numberWatch mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(bgView.mas_left).with.offset(16);
    //        make.top.equalTo(nameContent.mas_bottom).with.offset(10);
    //        make.height.equalTo(@15);
    //    }];
    //    [numberWatch setFont:[UIFont systemFontOfSize:10]];
    //    [numberWatch setTextColor:getUIColor(Color_numberWatch)];
    
}

-(void)setModel:(NewMainModel *)model
{
    _model = model;
    [mainImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model.img]]];
    mainImg.contentMode = UIViewContentModeScaleAspectFill;
    [mainImg.layer setMasksToBounds:YES];
    
    
    
    [nameLabel setText:model.name];
    [nameContent setText:model.title];
    [numberWatch setText:model.sub_title];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
