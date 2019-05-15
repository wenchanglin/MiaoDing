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
    UIView * fenGeView;
    UIImageView * rightImageView;
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

    messageName = [UILabel new];
    [messageName setFont:[UIFont fontWithName:@"PingFangSC-Light" size:16]];
    messageName.textColor = [UIColor colorWithHexString:@"#222222"];
     [contentView addSubview:messageName];
    messageName.sd_layout
    .leftSpaceToView(messageHead, 9)
    .centerYEqualToView(contentView)
    .heightIs (22)
    .widthIs(100);
    
    fenGeView = [UIView new];
    fenGeView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [contentView addSubview:fenGeView];
    [fenGeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageName.mas_bottom).offset(12);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(9);
    }];
    rightImageView = [UIImageView new];
    rightImageView.backgroundColor = [UIColor blueColor];
    rightImageView.image = [UIImage imageNamed:@"rightDes"];
    [contentView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.6);
        make.centerY.equalTo(messageName.mas_centerY);
    }];
 

    
    

}

-(void)setModel:(messageTypeModel *)model
{
    [messageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL, model.img]]];
    [messageName setText:model.name];
    [labelCount setText:[NSString stringWithFormat:@"%@",@(model.unread_message_num)]];
    if (model.unread_message_num > 0) {
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
