
#import <UIKit/UIKit.h>

@interface UICliper : UIView
{
    UIImageView *imgView;
    CGRect cliprect;
    CGColorRef grayAlpha;
    CGPoint touchPoint;
}

- (id)initWithImageView:(UIImageView*)iv;



- (void)setclipEDGE:(CGRect)rect;

- (CGRect)getclipRect;

-(void)setClipRect:(CGRect)rect;

-(UIImage*)getClipImageRect:(CGRect)rect;

@end
