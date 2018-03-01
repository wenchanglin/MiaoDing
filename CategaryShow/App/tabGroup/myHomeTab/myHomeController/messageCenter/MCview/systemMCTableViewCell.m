//
//  systemMCTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/5.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "systemMCTableViewCell.h"

@implementation systemMCTableViewCell
{
    UILabel *titleLabel;
    UILabel *textContent;
    UILabel *timeLable;
    UILabel *companyName;
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
    UIView *contentView = self.contentView;
    titleLabel = [UILabel new];
    [contentView addSubview:titleLabel];
    titleLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(contentView, 20)
    .rightSpaceToView(contentView, 20)
    .heightIs(15);
    [titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    textContent = [UILabel new];
    [contentView addSubview:textContent];
    textContent.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(titleLabel, 10)
    .rightSpaceToView(contentView, 25)
    .autoHeightRatio(0);
    [textContent setFont:[UIFont systemFontOfSize:10]];
    
    timeLable = [UILabel new];
    [contentView addSubview:timeLable];
    timeLable.sd_layout
    .rightSpaceToView(contentView, 25)
    .leftSpaceToView(contentView, 20)
    .heightIs(15)
    .topSpaceToView(textContent, 10);
    [timeLable setTextAlignment:NSTextAlignmentRight];
    [timeLable setFont:[UIFont systemFontOfSize:10]];
    
    
    companyName = [UILabel new];
    [contentView addSubview:companyName];
    companyName.sd_layout
    .rightSpaceToView(contentView, 25)
    .leftSpaceToView(contentView, 20)
    .heightIs(15)
    .topSpaceToView(timeLable, 0);
    [companyName setTextAlignment:NSTextAlignmentRight];
    [companyName setFont:[UIFont systemFontOfSize:10]];
    
    [self setupAutoHeightWithBottomView:companyName bottomMargin:14];
    
}

-(void)setModel:(messageListModel *)model
{
    _model = model;
    [titleLabel setText:model.mcTitle];
    
    NSString *_test  = model.mcContent;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    CGFloat emptylen = textContent.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = 2.0f;//行间距
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    textContent.attributedText = attrText;

    [timeLable setText:[self dateToString:model.mcTime]];
    [companyName setText:@"云工场科技有限公司"];
}

-(NSString *)dateToString:(NSString *)dateString
{

    NSTimeInterval time=[dateString doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
