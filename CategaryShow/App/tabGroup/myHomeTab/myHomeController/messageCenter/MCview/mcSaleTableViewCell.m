//
//  mcSaleTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/5.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "mcSaleTableViewCell.h"

@implementation mcSaleTableViewCell
{
    UILabel *titleLabel;
    UIImageView *imageContent;
    UILabel *textContent;
    UILabel *detailWorning;
    UIImageView *enterImg;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createContentView];
        
    }
    return self;
}

-(void)createContentView
{
    UIView *content = self.contentView;
    titleLabel = [UILabel new];
    [content addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(content, 20)
    .topSpaceToView(content, 12)
    .heightIs(15)
    .rightSpaceToView(content, 20);
    [titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    
    imageContent = [UIImageView new];
    [content addSubview:imageContent];
    
    imageContent.sd_layout
    .leftSpaceToView(content, 20)
    .topSpaceToView(titleLabel, 10)
    .heightIs(278 / 2)
    .rightSpaceToView(content, 20);
    imageContent.contentMode = UIViewContentModeScaleAspectFill;
    [imageContent.layer setMasksToBounds:YES];
    
    textContent = [UILabel new];
    [content addSubview:textContent];
    
    textContent.sd_layout
    .leftSpaceToView(content, 20)
    .topSpaceToView(imageContent,0)
    .heightIs(36)
    .rightSpaceToView(content, 20);
    [textContent setTextColor:getUIColor(Color_active)];
    [textContent setFont:[UIFont systemFontOfSize:13]];
    
    UIView *lineView = [UIView new];
    [content addSubview:lineView];
    lineView.sd_layout
    .leftSpaceToView(content, 20)
    .rightSpaceToView(content, 20)
    .heightIs(1)
    .topSpaceToView(textContent, 0);
    [lineView setBackgroundColor:getUIColor(Color_background)];
    
    UILabel *detail = [UILabel new];
    [content addSubview:detail];
    
    detail.sd_layout
    .leftSpaceToView(content, 20)
    .widthIs(100)
    .bottomEqualToView(content)
    .topSpaceToView(lineView, 0);
    [detail setFont:[UIFont systemFontOfSize:10]];
    [detail setText:@"查看详情"];

    
}

-(void)setModel:(messageListModel *)model
{
    _model = model;
    [titleLabel setText:model.mcTitle];
    [imageContent sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.mcImg]]];
    [textContent setText:model.mcContent];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
