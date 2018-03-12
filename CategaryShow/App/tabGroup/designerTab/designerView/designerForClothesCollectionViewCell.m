//
//  designerForClothesCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/21.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//
#import <CoreText/CoreText.h>

#import "designerForClothesCollectionViewCell.h"

@implementation designerForClothesCollectionViewCell

{
    UIImageView *backImage;
    UIImageView *headImage;
    UILabel *nameLabel;
    UILabel *descripLabel;
    UILabel *designerDetail;
    
        NSMutableArray *labels;
        NSMutableArray *numArr;
        NSMutableArray *dataArr;
    UIView *vi;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
       
        [self setUp];
        
    }
    
    return self;
}

-(void)setUp
{
    UIView *contentView = self.contentView;
    backImage = [UIImageView new];
    [contentView addSubview:backImage];
    backImage.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topEqualToView(contentView)
    .bottomEqualToView(contentView);
    [backImage setContentMode:UIViewContentModeScaleAspectFill];
    [backImage.layer setMasksToBounds:YES];
    
    UIImageView *backAlpha = [UIImageView new];
    [contentView addSubview:backAlpha];
    backAlpha.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topEqualToView(contentView)
    .bottomEqualToView(contentView);
    [backAlpha setImage:[UIImage imageNamed:@"AlphaColthesAndDesginer"]];
    
    
    vi = [[UIView alloc] initWithFrame:CGRectZero];
    //    vi.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:vi];
    
    

}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [designerDetail setText:_intro];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_intro];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_intro length])];
    designerDetail.attributedText = attributedString;
    CGFloat hight = [self calculateTextHeight:[UIFont systemFontOfSize:14] givenText:_intro givenWidth:SCREEN_WIDTH - 24];
    vi.frame = CGRectMake(12, self.contentView.frame.size.height - hight - 80, self.contentView.frame.size.width - 24 , hight);
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = vi.bounds;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [vi.layer addSublayer:textLayer];
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    UIFont *font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:14];
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames ){
        
       // printf( "Family: %s \n", [familyName UTF8String] );
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames ){
            
        //    printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
    
    NSString *str = _intro;
    
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:str];
    CFStringRef fontName = (__bridge CFStringRef)(font.fontName);
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor clearColor].CGColor,
                              (__bridge id)kCTFontAttributeName:(__bridge id)fontRef
                              };
    [string setAttributes:attribs range:NSMakeRange(0, str.length)];
    
    dataArr = [NSMutableArray arrayWithObjects:(__bridge id _Nonnull)(fontRef),attribs,string,str,textLayer, nil];
    numArr = [NSMutableArray array];
    for (int i = 0; i < str.length; i++) {
        [numArr addObject:[NSNumber numberWithInt:i]];
        [self performSelector:@selector(changeToBlack) withObject:nil afterDelay:0.1 * i];
    }
    CFRelease(fontRef);
    
}

- (void)changeToBlack {
    CTFontRef fontRef = (__bridge CTFontRef)(dataArr[0]);
    NSMutableAttributedString *string = dataArr[2];
    NSNumber *num = [numArr firstObject];
    int y = [num intValue];
    NSDictionary *attribs = dataArr[1];
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor whiteColor].CGColor,
                (__bridge id)kCTFontAttributeName:(__bridge id)fontRef
                };
    [string setAttributes:attribs range:NSMakeRange(y, 1)];
    if (numArr.count > 1) {
        [numArr removeObjectAtIndex:0];
    }
    CATextLayer *textLayer = [dataArr lastObject];
    textLayer.string = string;
}

-(void)setModel:(designerModel *)model
{
    _model = model;
    [backImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _pictureUrl]]];
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.avatar]]];
    [nameLabel setText:model.uname];
    [descripLabel setText:model.tag];
      
}

- (CGFloat) calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(CGFloat)width{
    CGFloat delta;
    if ([text isEqualToString:@""]) {
        delta = 0;
    } else {
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        
        delta = size.height;
    }
    
    
    return delta;
    
}

@end
