//
//  commentHaveImageTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/13.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "commentHaveImageTableViewCell.h"
#import "PhotoCollectionViewCell.h"
@implementation commentHaveImageTableViewCell

{
    UIImageView *headImg;
    UILabel *nameLabel;
    UILabel *contentLabel;
    UICollectionView* collectionV;
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
//    nameLabel .sd_layout
//    .leftSpaceToView(headImg, 15)
//    .topSpaceToView(contentView, 22)
//    .widthIs(200)
//    .heightIs(15);
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
    
    
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    [flowL setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置每一个item的大小
    flowL.itemSize = CGSizeMake((SCREEN_WIDTH - 50) / 3 , (SCREEN_WIDTH -50) / 3 );
    flowL.sectionInset = UIEdgeInsetsMake(0, 2, 0, 2);
    //列
    flowL.minimumInteritemSpacing = 2;
    //行
    flowL.minimumLineSpacing = 2;
    //创建集合视图
     collectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowL];
    collectionV.backgroundColor = [UIColor whiteColor];
    // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 5);
    collectionV.delegate = self;
    collectionV.dataSource = self;
    //添加集合视图
    [contentView addSubview:collectionV];
    collectionV.sd_layout
    .leftSpaceToView(contentView, 22)
    .heightIs((SCREEN_WIDTH - 48) / 3 + 4)
    .topSpaceToView(contentLabel, 15)
    .rightSpaceToView(contentView, 22);
    //注册对应的cell
    [collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionV setShowsHorizontalScrollIndicator:NO];
    
    labelInto = [UILabel new];
    [contentView addSubview:labelInto];
    
    labelInto.sd_layout
    .leftSpaceToView(contentView, 22)
    .topSpaceToView(collectionV, 15)
    .widthIs(200)
    .heightIs(15);
    [labelInto setFont:[UIFont systemFontOfSize:11]];
    [labelInto setTextColor:[UIColor lightGrayColor]];

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
    [labelInto setText:[_model.commentDic stringForKey:@"goods_intro"]];
    
    [timeLabel setText:[self getFriendlyDateString:[_model.commentDic integerForKey:@"c_time"]]];
    [imageVip sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[_model.commentDic objectForKey:@"user_grade"] stringForKey:@"img2"]]]];
    [labelInto updateLayout];
    [contentLabel updateLayout];
    [nameLabel updateLayout];
    
    [collectionV reloadData];
    
    [self setupAutoHeightWithBottomView:labelInto bottomMargin:10];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [[_model.commentDic arrayForKey:@"img_list"] count];
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setBackgroundColor:getUIColor(Color_background)];
    [cell.photoV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[_model.commentDic arrayForKey:@"img_list"] objectAtIndex:indexPath.item]]]];
    [cell.photoV setContentMode:UIViewContentModeScaleAspectFit];
    [cell.photoV.layer setMasksToBounds:YES];
    return cell;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(clickCollectionItem:tag:)]) {
        [_delegate clickCollectionItem:indexPath.item tag:self.tag];
    }
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
