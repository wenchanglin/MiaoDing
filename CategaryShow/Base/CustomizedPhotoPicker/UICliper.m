
#import "UICliper.h"
#define EDGE_WIDTH 20
@implementation UICliper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}
- (id)initWithImageView:(UIImageView*)iv
{
    CGRect r = [iv bounds];
    self = [super initWithFrame:r];
    if (self) {
        [iv addSubview:self];
        [iv setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
       
        cliprect = CGRectMake(self.center.x, self.center.y, 100, 100);
        grayAlpha = [[[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.6] CGColor];
        [self setMultipleTouchEnabled:NO];
        touchPoint = self.center;
        imgView = iv;
        
    }
    return self;
}

/**/
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    //绘制剪裁区域外半透明效果
    CGContextSetFillColorWithColor(context, grayAlpha);
    CGRect r = CGRectMake(0, 0, rect.size.width, cliprect.origin.y);
    CGContextFillRect(context, r);
    r = CGRectMake(0, cliprect.origin.y, cliprect.origin.x, cliprect.size.height);
    CGContextFillRect(context, r);
    r = CGRectMake(cliprect.origin.x + cliprect.size.width, cliprect.origin.y, rect.size.width - cliprect.origin.x - cliprect.size.width, cliprect.size.height);
    CGContextFillRect(context, r);
    r = CGRectMake(0, cliprect.origin.y + cliprect.size.height, rect.size.width, rect.size.height - cliprect.origin.y - cliprect.size.height+1);
    CGContextFillRect(context, r);
    //绘制剪裁区域的格子

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    touchPoint = [touch locationInView:self];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    float x1=.0f, x2=.0f, y1=.0f, y2=.0f;
    float x = touchPoint.x;
    float y = touchPoint.y;
    if (fabsf(x-cliprect.origin.x)<EDGE_WIDTH) //左
    {
        float offy = y-cliprect.origin.y;
        if (fabsf(offy)<EDGE_WIDTH) { //左上角
            x1 = p.x - touchPoint.x;
            y1 = p.y - touchPoint.y;
        }else if(fabsf(offy-cliprect.size.height)<EDGE_WIDTH){ //左下角
            x1 = p.x - touchPoint.x;
            y2 = p.y - touchPoint.y;
        }else if(y>cliprect.origin.y && y<cliprect.origin.y+cliprect.size.height) { //左中部
            x1 = p.x - touchPoint.x;
        }
    }else if(fabsf(x-cliprect.origin.x-cliprect.size.width)<EDGE_WIDTH) //右
    {
        float offy = y-cliprect.origin.y;
        if (fabsf(offy)<EDGE_WIDTH) { //右上角
            x2 = p.x -touchPoint.x;
            y1 = p.y -touchPoint.y;
        }else if(fabsf(offy-cliprect.size.height)<EDGE_WIDTH) { //右下角
            x2 = p.x - touchPoint.x;
            y2 = p.y - touchPoint.y;
        }else if(y>cliprect.origin.y && y<cliprect.origin.y+cliprect.size.height) { //右中部
            x2 = p.x - touchPoint.x;
        }
    }else if(fabsf(y-cliprect.origin.y)<EDGE_WIDTH){ //上
        if (x>cliprect.origin.x && x< cliprect.size.width) { //上中
            y1 = p.y - touchPoint.y;
        }
    }else if(fabsf(y-cliprect.origin.y-cliprect.size.height)<EDGE_WIDTH){ //下
        if (x>cliprect.origin.x && x< cliprect.size.width) { //下中
            y2 = p.y - touchPoint.y;
        }
    }else if((x>cliprect.origin.x && x< cliprect.origin.x+cliprect.size.width)&&(y>cliprect.origin.y && y<cliprect.origin.y+cliprect.size.height)){ //正中
        cliprect.origin.x += (p.x -touchPoint.x);
        cliprect.origin.y += (p.y -touchPoint.y);
        if (cliprect.origin.x<0) {
            cliprect.origin.x=0;
        }else if(cliprect.origin.x>self.bounds.size.width-cliprect.size.width)
        {
            cliprect.origin.x=self.bounds.size.width-cliprect.size.width;
        }
        if (cliprect.origin.y<0) {
            cliprect.origin.y=0;
        }else if(cliprect.origin.y>self.bounds.size.height-cliprect.size.height)
        {
            cliprect.origin.y=self.bounds.size.height-cliprect.size.height;
        }
    }else {
        return;
    }
    //修改rect
//    [self ChangeclipEDGE:x1 x2:x2 y1:y1 y2:y2];
    [self setNeedsDisplay];
    touchPoint = p;
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchPoint = CGPointZero;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)setclipEDGE:(CGRect)rect
{
    cliprect = rect;
    [self setNeedsDisplay];
}


- (CGRect)getclipRect
{
//    [self ChangeclipEDGE:0 x2:0 y1:0 y2:0];
    [self setNeedsDisplay];
    float imgsize = [imgView image].size.width;
    float viewsize = [imgView frame].size.width;
    float scale = imgsize/viewsize;
    CGRect r = CGRectMake(cliprect.origin.x*scale, cliprect.origin.y*scale, cliprect.size.width*scale, cliprect.size.height*scale);
    return r;
}

-(void)setClipRect:(CGRect)rect
{
    cliprect = rect;
    [self setNeedsDisplay];
}

-(UIImage*)getClipImageRect:(CGRect)rect
{
    CGImageRef imgrefout = CGImageCreateWithImageInRect([imgView.image CGImage], rect);
    UIImage *img_ret = [[UIImage alloc]initWithCGImage:imgrefout];
    return img_ret;
}


@end
