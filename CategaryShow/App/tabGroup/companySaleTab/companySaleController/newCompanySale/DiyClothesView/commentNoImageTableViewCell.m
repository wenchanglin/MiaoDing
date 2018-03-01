//
//  commentNoImageTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/13.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "commentNoImageTableViewCell.h"



@implementation commentNoImageTableViewCell
{
    UIImageView *headImg;
    UILabel *nameLabel;
    UILabel *contentLabel;
    UILabel *labelInto;
    UILabel *timeLabel;
    UIImageView *imageVip;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
         [self setUp];
        
    }
    
    return self;
}

-(void)setUp{
    
    UIView *contentView = self.contentView;
    
    headImg =[ UIImageView new];
    [contentView addSubview:headImg];
    
    headImg.sd_layout
    .leftSpaceToView(contentView, 22)
    .topSpaceToView(contentView, 13)
    .heightIs(50)
    .widthIs(50);
    [headImg.layer setCornerRadius:25];
    [headImg.layer setMasksToBounds:YES];
    
    
    nameLabel = [UILabel new];
    [contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(headImg.mas_right).with.offset(15);
        make.top.equalTo(contentView.mas_top).with.offset(22);
        make.height.equalTo(@15);
        
    }];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    
    imageVip = [UIImageView new];
    [contentView addSubview:imageVip];
    
    imageVip.sd_layout
    .leftSpaceToView(nameLabel, 10)
    .centerYEqualToView(nameLabel)
    .widthIs(25)
    .heightIs(11);
    
    timeLabel = [UILabel new];
    [contentView addSubview:timeLabel];
    
    timeLabel.sd_layout
    .leftSpaceToView(headImg, 15)
    .topSpaceToView(nameLabel, 6)
    .widthIs(100)
    .heightIs(15);
    [timeLabel setTextColor:[UIColor lightGrayColor]];
    [timeLabel setFont:[UIFont systemFontOfSize:10]];
    
    
    contentLabel = [UILabel new];
    [contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView.mas_left).with.offset(22);
        make.top.equalTo(headImg.mas_bottom).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-22);
        
    }];
    
//    contentView.sd_layout
//    .leftSpaceToView(contentView, 22)
//    .topSpaceToView(headImg, 10)
//    .rightSpaceToView(contentView, 22)
//    .aut
    
    
    
    
    labelInto = [UILabel new];
    [contentView addSubview:labelInto];
    
    labelInto.sd_layout
    .leftSpaceToView(contentView, 22)
    .topSpaceToView(contentLabel, 12)
    .widthIs(200)
    .autoHeightRatio(0);
    [labelInto setTextColor:[UIColor lightGrayColor]];
    [labelInto setFont:[UIFont systemFontOfSize:11]];
    
    
    
}

-(void)setModel:(commentModel *)model
{
    _model = model;
    [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_model.commentDic stringForKey:@"avatar"]]]];
   [nameLabel setText:[_model.commentDic stringForKey:@"user_name"]];
    [contentLabel setText:[_model.commentDic stringForKey:@"content"]];
    [contentLabel setFont:[UIFont systemFontOfSize:12]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[_model.commentDic stringForKey:@"content"]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[_model.commentDic stringForKey:@"content"] length])];
    contentLabel.attributedText = attributedString;
    [contentLabel setNumberOfLines:0];
    [contentLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLabel setText:[self getFriendlyDateString:[_model.commentDic integerForKey:@"c_time"]]];
    
    [imageVip sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[_model.commentDic objectForKey:@"user_grade"] stringForKey:@"img2"]]]];
    [labelInto setText:[_model.commentDic stringForKey:@"goods_intro"]];
    
    [labelInto updateLayout];
    [contentLabel updateLayout];
    [nameLabel updateLayout];
    [self setupAutoHeightWithBottomView:labelInto bottomMargin:12];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (NSString*) getFriendlyDateString : (long long) lngDate {
    
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:lngDate];
    
    NSDate *myDate = [NSDate date];
    
    NSString *DIF;
    NSString *strDate;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsNow = [[NSDateComponents alloc] init];
    NSDateComponents *compsCur = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    compsNow = [calendar components:unitFlags fromDate:myDate];
    compsCur = [calendar components:unitFlags fromDate:curDate];
    
    if ([compsCur day]==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year]) {
        DIF=@"今天";
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"HH:mm"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        strDate=[NSString stringWithFormat:@"%@ %@",DIF,dateStr];
        
    }else if ([compsCur day]+1==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year]){
        DIF=@"昨天";
        
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"HH:mm"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        
        strDate=[NSString stringWithFormat:@"%@ %@",DIF,dateStr];
    }else{
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"MM-dd"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        
        strDate=dateStr;
    }
    
    return strDate;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
