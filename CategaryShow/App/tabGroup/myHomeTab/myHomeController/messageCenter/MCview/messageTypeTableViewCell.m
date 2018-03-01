//
//  messageTypeTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/4.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "messageTypeTableViewCell.h"

@implementation messageTypeTableViewCell
{
    UIImageView *messageHead;
    UILabel *messageName;
    UILabel *messageContent;
    UILabel *messageTime;
    UILabel *labelCount;
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
    messageHead = [UIImageView new];
    [contentView addSubview:messageHead];
    messageHead.sd_layout
    .leftSpaceToView(contentView, 12)
    .centerYEqualToView(contentView)
    .widthIs(25)
    .heightIs(25);
//    [messageHead.layer setCornerRadius:25];
//    [messageHead.layer setMasksToBounds:YES];
    
//    labelCount = [UILabel new];
//    [contentView addSubview:labelCount];
//    [labelCount setTextAlignment:NSTextAlignmentCenter];
//    [labelCount setFont:[UIFont systemFontOfSize:12]];
//    labelCount.sd_layout
//    .leftSpaceToView(contentView, 45)
//    .topSpaceToView(contentView, 13)
//    .heightIs(15)
//    .widthIs(15);
//    [labelCount.layer setCornerRadius:(7.5)];
//    [labelCount.layer setMasksToBounds:YES];
//    [labelCount setBackgroundColor:[UIColor redColor]];
//    [labelCount setTextColor:[UIColor whiteColor]];
//    
    messageName = [UILabel new];
     [contentView addSubview:messageName];
    messageName.sd_layout
    .leftSpaceToView(messageHead, 9)
    .centerYEqualToView(contentView)
    .heightIs (15)
    .widthIs(100);
    [messageName setFont:[UIFont boldSystemFontOfSize:14]];
//
//    messageTime = [UILabel new];
//    [contentView addSubview:messageTime];
//    messageTime.sd_layout
//    .leftSpaceToView(messageName, 10)
//    .rightSpaceToView(contentView, 11)
//    .heightIs(15)
//    .topSpaceToView(contentView, 13);
//    [messageTime setFont:[UIFont systemFontOfSize:12]];
//    [messageTime setTextColor:getUIColor(Color_saveColor)];
//    [messageTime setTextAlignment:NSTextAlignmentRight];
    
    
//    messageContent = [UILabel new];
//     [contentView addSubview:messageContent];
//    messageContent.sd_layout
//    .leftSpaceToView(messageHead,10)
//    .bottomSpaceToView(contentView, 12)
//    .heightIs(15)
//    .rightSpaceToView(contentView, 11);
//    [messageContent setFont:[UIFont systemFontOfSize:13]];
//    [messageContent setTextColor:getUIColor(Color_active)];
    

    
    

}

-(void)setModel:(messageTypeModel *)model
{
    [messageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL, model.messageImage]]];
    [messageName setText:model.messageName];
    if ([[model.messageLastMsg stringForKey:@"title"] length] > 0) {
        [messageContent setText:[model.messageLastMsg stringForKey:@"title"]];
    } else {
        [messageContent setText:@"暂无通知"];

    }
    
    if ([[model.messageLastMsg stringForKey:@"c_time"] length] > 0) {
        [messageTime setText:[self dateToString:[model.messageLastMsg stringForKey:@"c_time"]]];
    } else {
        [messageTime setText:@""];
    }
    [labelCount setText:model.unReadCount];
    if ([model.unReadCount integerValue] > 0) {
        [labelCount setHidden:NO];
    } else {
        [labelCount setHidden:YES];
    }
    
    
    
}

-(NSString *)dateToString:(NSString *)dateString
{
    
    NSTimeInterval time=[dateString doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
