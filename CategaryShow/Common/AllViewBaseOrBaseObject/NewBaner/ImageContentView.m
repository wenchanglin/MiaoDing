//
//  ImageContentView.m
//  新型轮播图
//
//  Created by zhao on 16/3/21.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import "ImageContentView.h"
#import <UIButton+WebCache.h>
#import <CoreText/CoreText.h>

@interface ImageContentView ()

@property(nonatomic,retain)UIButton *btn;
@property(nonatomic,retain)UIImageView *alpha;
@property(nonatomic,copy)BtnBlock btnBlock;
@property (nonatomic, retain) UIView *vi;
@end


@implementation ImageContentView
{
    NSMutableArray *labels;
    NSMutableArray *numArr;
    NSMutableArray *dataArr;
}

-(instancetype) initWithContentFrame:(CGRect)frame andimgUrlStr:(NSString *)imgStr andIntroStr:(NSString *)strIntro andBtnBlock:(BtnBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds= YES;
        self.btnBlock = block;
        self.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,imgStr]] forState:UIControlStateNormal];
        self.btn.contentMode=UIViewContentModeScaleAspectFill;
        [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
        
        self.alpha = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

        [self.alpha setImage:[UIImage imageNamed:@"AlphaColthesAndDesginer"]];
        [self addSubview:self.alpha];
        
        
        
        NSString *stringInto;
        NSString *stringFirst;
        if (![strIntro isEqualToString:@" "] && ![strIntro isEqualToString:@""]&&strIntro !=nil&&![strIntro isKindOfClass:[NSNull class]] ) {
            stringInto =[strIntro substringFromIndex:1];
            stringFirst = [strIntro substringToIndex:1];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:stringInto];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:3];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [stringInto length])];
            
            CGFloat hight = [self calculateTextHeight:[UIFont systemFontOfSize:14] givenText:stringInto givenWidth:SCREEN_WIDTH - 24] + 10;
            _vi = [[UIView alloc] initWithFrame:CGRectMake(44, frame.size.height - hight - 80,frame.size.width - 24 - 22 , hight)];
            [self addSubview:_vi];
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.frame = _vi.bounds;
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            [_vi.layer addSublayer:textLayer];
            textLayer.alignmentMode = kCAAlignmentJustified;
            textLayer.wrapped = YES;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, frame.size.height - hight - 80 - 10, 30, 30)];
            [label setText:stringFirst];
            [label setTextColor:[UIColor whiteColor]];
            [label setFont:Font_26];
            [self addSubview:label];
            
            
            
            
            UIFont *font = [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:14];
            NSArray *familyNames = [UIFont familyNames];
            for( NSString *familyName in familyNames ){
                
               // printf( "Family: %s \n", [familyName UTF8String] );
                
                NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
                for( NSString *fontName in fontNames ){
                    
                 //   printf( "\tFont: %s \n", [fontName UTF8String] );
                }
            }
            
            NSString *str = stringInto;
            
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
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 1)];
            dataArr = [NSMutableArray arrayWithObjects:(__bridge id _Nonnull)(fontRef),attribs,string,str,textLayer, nil];
            
            numArr = [NSMutableArray array];
            for (int i = 0; i < str.length; i++) {
                [numArr addObject:[NSNumber numberWithInt:i]];
                [self performSelector:@selector(changeToBlack) withObject:nil afterDelay:0.1 * i];
            }
            CFRelease(fontRef);
        } else {
             stringInto =strIntro ;
        }
        
        
        
        
    }
    return self;
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
-(instancetype)initWithContentFrame:(CGRect)frame andimgStr:(NSString *)imgStr  andBtnBlock:(BtnBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds= YES;
        self.btnBlock = block;
        self.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.btn.layer.contents = (id)[UIImage imageNamed:imgStr].CGImage;
        [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.btn.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:self.btn];
        self.alpha = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

        [self.alpha setImage:[UIImage imageNamed:@"AlphaColthesAndDesginer"]];
        [self addSubview:self.alpha];
    }
    return self;
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


-(void)btnClick:(UIButton *)sender
{
    self.btnBlock();
}


- (void)imageOffsetValue:(float)value {
    
    CGRect centerToWindow = [self convertRect:self.bounds toView:self.window];
    
    CGFloat centerX = CGRectGetMidX(centerToWindow);
    CGPoint windowCenter = self.window.center;
    CGFloat cellOffsetX = centerX - windowCenter.x;
    CGAffineTransform transX = CGAffineTransformMakeTranslation(- cellOffsetX * value, 0);

    self.btn.transform = transX;
    

    
    
}



@end
