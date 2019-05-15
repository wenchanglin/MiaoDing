//
//  CommentCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/9.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "CommentCollectionViewCell.h"
#import "PhotoCollectionViewCell.h"
#import "diyClothesDetailModel.h"
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
    if(_modelComment.collectArray.count > 0)
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
                collect_listModel*model4 =_modelComment.collectArray[i];
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(22 + ((SCREEN_WIDTH - 100) / 5 + 14) * i, 43, (SCREEN_WIDTH - 100) / 5, (SCREEN_WIDTH - 100) / 5)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model4.head_ico]]];
                [image.layer setCornerRadius:(SCREEN_WIDTH - 100) / 5 / 2];
                [image.layer setMasksToBounds:YES];
                [contentView addSubview:image];
            }
        } else {
            for (int i = 0; i < _modelComment.collectArray.count;  i ++) {
                collect_listModel*model5 =_modelComment.collectArray[i];
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(22 + ((SCREEN_WIDTH - 100) / 5 + 14) * i, 43 , (SCREEN_WIDTH - 100) / 5, (SCREEN_WIDTH - 100) / 5)];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model5.head_ico]]];
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
   
    return 0;//[[_modelComment.commentDic arrayForKey:@"img_list"] count];
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
