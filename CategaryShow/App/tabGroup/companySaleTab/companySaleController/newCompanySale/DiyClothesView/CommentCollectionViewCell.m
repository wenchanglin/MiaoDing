//
//  CommentCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/9.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "CommentCollectionViewCell.h"
#import "PhotoCollectionViewCell.h"
@implementation CommentCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

-(void)setUp
{

    UIView *contentView = self.contentView;
    
   
    
    
    if(_modelComment.collectArray.count > 0 && ![[_modelComment.commentDic stringForKey:@"id"] isEqualToString:@""])
    {
        UILabel *labelLike = [UILabel new];
        [contentView addSubview:labelLike];
        
        labelLike.sd_layout
        .leftSpaceToView(contentView, 22)
        .topSpaceToView(contentView, 10)
        .heightIs(20)
        .widthIs(200);
        [labelLike setFont:[UIFont boldSystemFontOfSize:14]];
        [labelLike setText:[NSString stringWithFormat:@"喜爱（%@人）", _modelComment.likeNum]];
        
        if (_modelComment.collectArray.count > 5) {
            for (int i = 0; i < 5;  i ++) {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(22 + ((SCREEN_WIDTH - 100) / 5 + 14) * i, 43, (SCREEN_WIDTH - 100) / 5, (SCREEN_WIDTH - 100) / 5)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_modelComment.collectArray[i] stringForKey:@"avatar"]]]];
                [image.layer setCornerRadius:(SCREEN_WIDTH - 100) / 5 / 2];
                [image.layer setMasksToBounds:YES];
                [contentView addSubview:image];
            }
        } else {
            for (int i = 0; i < _modelComment.collectArray.count;  i ++) {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(22 + ((SCREEN_WIDTH - 100) / 5 + 14) * i, 43 , (SCREEN_WIDTH - 100) / 5, (SCREEN_WIDTH - 100) / 5)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_modelComment.collectArray[i] stringForKey:@"avatar"]]]];
                [image.layer setCornerRadius:(SCREEN_WIDTH - 100) / 5 / 2];
                [image.layer setMasksToBounds:YES];
                [contentView addSubview:image];
            }
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43 + (SCREEN_WIDTH - 100) / 5 + 15, SCREEN_WIDTH, 1)];
        [lineView setBackgroundColor:getUIColor(Color_background)];
        [contentView addSubview:lineView];
        
        
        UILabel *commentLabel = [UILabel new];
        [contentView addSubview:commentLabel];
        commentLabel.sd_layout
        .leftSpaceToView(contentView, 22)
        .topSpaceToView(lineView, 13)
        .widthIs(200)
        .heightIs(20);
        [commentLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [commentLabel setText:[NSString stringWithFormat:@"评价（%@人）", _modelComment.comentNum]];
        
        UILabel *moreLabel = [UILabel new];
        [contentView addSubview:moreLabel];
        [moreLabel setText:@"查看更多 >"];
        moreLabel.sd_layout
        .rightSpaceToView(contentView, 22)
        .topSpaceToView(lineView, 13)
        .widthIs(70)
        .heightIs(20);
        [moreLabel setTextAlignment:NSTextAlignmentCenter];
        [moreLabel setFont:[UIFont systemFontOfSize:12]];
        [moreLabel setTextColor:getUIColor(Color_TKClolor)];
        
        
        
        UIImageView *headImg =[ UIImageView new];
        [contentView addSubview:headImg];
        
        headImg.sd_layout
        .leftSpaceToView(contentView, 22)
        .topSpaceToView(commentLabel, 13)
        .heightIs(50)
        .widthIs(50);
        [headImg.layer setCornerRadius:25];
        [headImg.layer setMasksToBounds:YES];
        [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_modelComment.commentDic stringForKey:@"avatar"]]]];
        
     
        
        
        
        
        UILabel* nameLabel = [UILabel new];
        [contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(headImg.mas_right).with.offset(15);
            make.top.equalTo(commentLabel.mas_bottom).with.offset(22);
            make.height.equalTo(@15);
            
        }];
        
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        [nameLabel setText:[_modelComment.commentDic stringForKey:@"user_name"]];
        
        UIImageView * imageVip = [UIImageView new];
        [contentView addSubview:imageVip];
        
        imageVip.sd_layout
        .leftSpaceToView(nameLabel, 10)
        .centerYEqualToView(nameLabel)
        .widthIs(25)
        .heightIs(11);
        
        UILabel * timeLabel = [UILabel new];
        [contentView addSubview:timeLabel];
        
        timeLabel.sd_layout
        .leftSpaceToView(headImg, 15)
        .topSpaceToView(nameLabel, 6)
        .widthIs(100)
        .heightIs(15);
        [timeLabel setTextColor:[UIColor lightGrayColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:10]];
        
        [timeLabel setText:[self getFriendlyDateString:[_modelComment.commentDic integerForKey:@"c_time"]]];
        [imageVip sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[_modelComment.commentDic objectForKey:@"user_grade"] stringForKey:@"img2"]]]];
        
        
        
        
        
        UILabel *contentLabel = [UILabel new];
        [contentView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(contentView.mas_left).with.offset(25);
            make.top.equalTo(headImg.mas_bottom).with.offset(10);
            make.right.equalTo(contentView.mas_right).with.offset(-25);
            make.height.lessThanOrEqualTo(@50);
        }];
        
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[_modelComment.commentDic stringForKey:@"content"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3.0];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[_modelComment.commentDic stringForKey:@"content"] length])];
        contentLabel.attributedText = attributedString;
        [contentLabel setNumberOfLines:0];
        [contentLabel setFont:[UIFont systemFontOfSize:12]];
        
        if ([[_modelComment.commentDic arrayForKey:@"img_list"] count] > 0) {
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
            UICollectionView* collectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowL];
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
        }
        
       
        
        
    } else if (_modelComment.collectArray.count == 0 && ![[_modelComment.commentDic stringForKey:@"id"] isEqualToString:@""]) {
        UILabel *commentLabel = [UILabel new];
        [contentView addSubview:commentLabel];
        commentLabel.sd_layout
        .leftSpaceToView(contentView, 22)
        .topSpaceToView(contentView, 13)
        .widthIs(200)
        .heightIs(20);
        [commentLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [commentLabel setText:[NSString stringWithFormat:@"评价（%@人）", _modelComment.comentNum]];
        
        UIImageView *headImg =[ UIImageView new];
        [contentView addSubview:headImg];
        
        headImg.sd_layout
        .leftSpaceToView(contentView, 22)
        .topSpaceToView(commentLabel, 13)
        .heightIs(50)
        .widthIs(50);
        [headImg.layer setCornerRadius:25];
        [headImg.layer setMasksToBounds:YES];
        [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_modelComment.commentDic stringForKey:@"avatar"]]]];
        
        UILabel* nameLabel = [UILabel new];
        [contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(headImg.mas_right).with.offset(15);
            make.top.equalTo(commentLabel.mas_bottom).with.offset(22);
            make.height.equalTo(@15);
            
        }];
        
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        [nameLabel setText:[_modelComment.commentDic stringForKey:@"user_name"]];
        
        UIImageView * imageVip = [UIImageView new];
        [contentView addSubview:imageVip];
        
        imageVip.sd_layout
        .leftSpaceToView(nameLabel, 10)
        .centerYEqualToView(nameLabel)
        .widthIs(25)
        .heightIs(11);
        
        UILabel * timeLabel = [UILabel new];
        [contentView addSubview:timeLabel];
        
        timeLabel.sd_layout
        .leftSpaceToView(headImg, 15)
        .topSpaceToView(nameLabel, 6)
        .widthIs(100)
        .heightIs(15);
        [timeLabel setTextColor:[UIColor lightGrayColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:10]];
        
        [timeLabel setText:[self getFriendlyDateString:[_modelComment.commentDic integerForKey:@"c_time"]]];
        [imageVip sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[_modelComment.commentDic objectForKey:@"user_grade"] stringForKey:@"img2"]]]];
        
        UILabel *contentLabel = [UILabel new];
        [contentView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(contentView.mas_left).with.offset(22);
            make.top.equalTo(headImg.mas_bottom).with.offset(10);
            make.right.equalTo(contentView.mas_right).with.offset(22);
            
        }];
        
        [contentLabel setText:[_modelComment.commentDic stringForKey:@"content"]];
        [contentLabel setFont:[UIFont systemFontOfSize:12]];
        
        if ([[_modelComment.commentDic arrayForKey:@"img_list"] count] > 0) {
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
            UICollectionView* collectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowL];
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
        }
        
       
    } else if (_modelComment.collectArray.count > 0 && [[_modelComment.commentDic stringForKey:@"id"] isEqualToString:@""]) {
        UILabel *labelLike = [UILabel new];
        [contentView addSubview:labelLike];
        
        labelLike.sd_layout
        .leftSpaceToView(contentView, 22)
        .topSpaceToView(contentView, 10)
        .heightIs(20)
        .widthIs(200);
        [labelLike setFont:[UIFont boldSystemFontOfSize:14]];
        [labelLike setText:[NSString stringWithFormat:@"喜爱（%@人）", _modelComment.likeNum]];
        
        if (_modelComment.collectArray.count > 5) {
            for (int i = 0; i < 5;  i ++) {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(22 + ((SCREEN_WIDTH - 100) / 5 + 14) * i, 43 , (SCREEN_WIDTH - 100) / 5, (SCREEN_WIDTH - 100) / 5)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_modelComment.collectArray[i] stringForKey:@"avatar"]]]];
                [image.layer setCornerRadius:(SCREEN_WIDTH - 100) / 5 / 2];
                [image.layer setMasksToBounds:YES];
                [contentView addSubview:image];
            }
        } else {
            for (int i = 0; i < _modelComment.collectArray.count;  i ++) {
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(22 + ((SCREEN_WIDTH - 100) / 5 + 14) * i, 43, (SCREEN_WIDTH - 100) / 5, (SCREEN_WIDTH - 100) / 5)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_modelComment.collectArray[i] stringForKey:@"avatar"]]]];
                [image.layer setCornerRadius:(SCREEN_WIDTH - 100) / 5 / 2];
                [image.layer setMasksToBounds:YES];
                [contentView addSubview:image];
            }
        }

    }
    
    UIImageView *top = [UIImageView new];
    [contentView addSubview:top];
    top.sd_layout
    .centerXEqualToView(contentView)
    .widthIs(205)
    .bottomSpaceToView(contentView, 8)
    .heightIs(12);
    [top setImage:[UIImage imageNamed:@"getTop"]];
    
    
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return [[_modelComment.commentDic arrayForKey:@"img_list"] count];
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setBackgroundColor:getUIColor(Color_background)];
    [cell.photoV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[_modelComment.commentDic arrayForKey:@"img_list"] objectAtIndex:indexPath.item]]]];
    [cell.photoV setContentMode:UIViewContentModeScaleAspectFit];
    [cell.photoV.layer setMasksToBounds:YES];
    return cell;
}


-(void)setModelComment:(commentModel *)modelComment
{
    _modelComment = modelComment;
    
    [self setUp];
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

@end
